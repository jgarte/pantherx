;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016, 2017, 2018, 2019, 2020 Ludovic Courtès <ludo@gnu.org>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (guix transformations)
  #:use-module (guix i18n)
  #:use-module (guix store)
  #:use-module (guix packages)
  #:use-module (guix profiles)
  #:use-module (guix diagnostics)
  #:autoload   (guix download) (download-to-store)
  #:autoload   (guix git-download) (git-reference? git-reference-url)
  #:autoload   (guix git) (git-checkout git-checkout? git-checkout-url)
  #:use-module (guix utils)
  #:use-module (guix memoization)
  #:use-module (guix gexp)

  ;; Use the procedure that destructures "NAME-VERSION" forms.
  #:use-module ((guix build utils)
                #:select ((package-name->name+version
                           . hyphen-package-name->name+version)))

  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-11)
  #:use-module (srfi srfi-26)
  #:use-module (srfi srfi-34)
  #:use-module (srfi srfi-37)
  #:use-module (ice-9 match)
  #:export (options->transformation
            manifest-entry-with-transformations

            show-transformation-options-help
            %transformation-options))

;;; Commentary:
;;;
;;; This module implements "package transformation options"---tools for
;;; package graph rewriting.  It contains the graph rewriting logic, but also
;;; the tip of its user interface: command-line option handling.
;;;
;;; Code:

(module-autoload! (current-module) '(gnu packages)
                  '(specification->package))

(define (numeric-extension? file-name)
  "Return true if FILE-NAME ends with digits."
  (string-every char-set:hex-digit (file-extension file-name)))

(define (tarball-base-name file-name)
  "Return the \"base\" of FILE-NAME, removing '.tar.gz' or similar
extensions."
  ;; TODO: Factorize.
  (cond ((not (file-extension file-name))
         file-name)
        ((numeric-extension? file-name)
         file-name)
        ((string=? (file-extension file-name) "tar")
         (file-sans-extension file-name))
        ((file-extension file-name)
         =>
         (match-lambda
           ("scm" file-name)
           (_     (tarball-base-name (file-sans-extension file-name)))))
        (else
         file-name)))


;; Files to be downloaded.
(define-record-type <downloaded-file>
  (downloaded-file uri recursive?)
  downloaded-file?
  (uri        downloaded-file-uri)
  (recursive? downloaded-file-recursive?))

(define download-to-store*
  (store-lift download-to-store))

(define-gexp-compiler (compile-downloaded-file (file <downloaded-file>)
                                               system target)
  "Download FILE and return the result as a store item."
  (match file
    (($ <downloaded-file> uri recursive?)
     (download-to-store* uri #:recursive? recursive?))))

(define* (package-with-source p uri #:optional version)
  "Return a package based on P but with its source taken from URI.  Extract
the new package's version number from URI."
  (let ((base (tarball-base-name (basename uri))))
    (let-values (((_ version*)
                  (hyphen-package-name->name+version base)))
      (package (inherit p)
               (version (or version version*
                            (package-version p)))

               ;; Use #:recursive? #t to allow for directories.
               (source (downloaded-file uri #t))))))


;;;
;;; Transformations.
;;;

(define (transform-package-source sources)
  "Return a transformation procedure that replaces package sources with the
matching URIs given in SOURCES."
  (define new-sources
    (map (lambda (uri)
           (match (string-index uri #\=)
             (#f
              ;; Determine the package name and version from URI.
              (call-with-values
                  (lambda ()
                    (hyphen-package-name->name+version
                     (tarball-base-name (basename uri))))
                (lambda (name version)
                  (list name version uri))))
             (index
              ;; What's before INDEX is a "PKG@VER" or "PKG" spec.
              (call-with-values
                  (lambda ()
                    (package-name->name+version (string-take uri index)))
                (lambda (name version)
                  (list name version
                        (string-drop uri (+ 1 index))))))))
         sources))

  (lambda (obj)
    (let loop ((sources  new-sources)
               (result   '()))
      (match obj
        ((? package? p)
         (match (assoc-ref sources (package-name p))
           ((version source)
            (package-with-source p source version))
           (#f
            p)))
        (_
         obj)))))

(define (evaluate-replacement-specs specs proc)
  "Parse SPECS, a list of strings like \"guile=guile@2.1\" and return a list
of package spec/procedure pairs as expected by 'package-input-rewriting/spec'.
PROC is called with the package to be replaced and its replacement according
to SPECS.  Raise an error if an element of SPECS uses invalid syntax, or if a
package it refers to could not be found."
  (define not-equal
    (char-set-complement (char-set #\=)))

  (map (lambda (spec)
         (match (string-tokenize spec not-equal)
           ((spec new)
            (cons spec
                  (let ((new (specification->package new)))
                    (lambda (old)
                      (proc old new)))))
           (x
            (raise (formatted-message
                    (G_ "invalid replacement specification: ~s")
                    spec)))))
       specs))

(define (transform-package-inputs replacement-specs)
  "Return a procedure that, when passed a package, replaces its direct
dependencies according to REPLACEMENT-SPECS.  REPLACEMENT-SPECS is a list of
strings like \"guile=guile@2.1\" meaning that, any dependency on a package
called \"guile\" must be replaced with a dependency on a version 2.1 of
\"guile\"."
  (let* ((replacements (evaluate-replacement-specs replacement-specs
                                                   (lambda (old new)
                                                     new)))
         (rewrite      (package-input-rewriting/spec replacements)))
    (lambda (obj)
      (if (package? obj)
          (rewrite obj)
          obj))))

(define (transform-package-inputs/graft replacement-specs)
  "Return a procedure that, when passed a package, replaces its direct
dependencies according to REPLACEMENT-SPECS.  REPLACEMENT-SPECS is a list of
strings like \"gnutls=gnutls@3.5.4\" meaning that packages are built using the
current 'gnutls' package, after which version 3.5.4 is grafted onto them."
  (define (set-replacement old new)
    (package (inherit old) (replacement new)))

  (let* ((replacements (evaluate-replacement-specs replacement-specs
                                                   set-replacement))
         (rewrite      (package-input-rewriting/spec replacements)))
    (lambda (obj)
      (if (package? obj)
          (rewrite obj)
          obj))))

(define %not-equal
  (char-set-complement (char-set #\=)))

(define (package-git-url package)
  "Return the URL of the Git repository for package, or raise an error if
the source of PACKAGE is not fetched from a Git repository."
  (let ((source (package-source package)))
    (cond ((and (origin? source)
                (git-reference? (origin-uri source)))
           (git-reference-url (origin-uri source)))
          ((git-checkout? source)
           (git-checkout-url source))
          (else
           (raise
            (formatted-message (G_ "the source of ~a is not a Git reference")
                               (package-full-name package)))))))

(define (evaluate-git-replacement-specs specs proc)
  "Parse SPECS, a list of strings like \"guile=stable-2.2\", and return a list
of package pairs, where (PROC PACKAGE URL BRANCH-OR-COMMIT) returns the
replacement package.  Raise an error if an element of SPECS uses invalid
syntax, or if a package it refers to could not be found."
  (map (lambda (spec)
         (match (string-tokenize spec %not-equal)
           ((spec branch-or-commit)
            (define (replace old)
              (let* ((source (package-source old))
                     (url    (package-git-url old)))
                (proc old url branch-or-commit)))

            (cons spec replace))
           (_
            (raise
             (formatted-message (G_ "invalid replacement specification: ~s")
                                spec)))))
       specs))

(define (transform-package-source-branch replacement-specs)
  "Return a procedure that, when passed a package, replaces its direct
dependencies according to REPLACEMENT-SPECS.  REPLACEMENT-SPECS is a list of
strings like \"guile-next=stable-3.0\" meaning that packages are built using
'guile-next' from the latest commit on its 'stable-3.0' branch."
  (define (replace old url branch)
    (package
      (inherit old)
      (version (string-append "git." (string-map (match-lambda
                                                   (#\/ #\-)
                                                   (chr chr))
                                                 branch)))
      (source (git-checkout (url url) (branch branch)
                            (recursive? #t)))))

  (let* ((replacements (evaluate-git-replacement-specs replacement-specs
                                                       replace))
         (rewrite      (package-input-rewriting/spec replacements)))
    (lambda (obj)
      (if (package? obj)
          (rewrite obj)
          obj))))

(define (transform-package-source-commit replacement-specs)
  "Return a procedure that, when passed a package, replaces its direct
dependencies according to REPLACEMENT-SPECS.  REPLACEMENT-SPECS is a list of
strings like \"guile-next=cabba9e\" meaning that packages are built using
'guile-next' from commit 'cabba9e'."
  (define (replace old url commit)
    (package
      (inherit old)
      (version (if (and (> (string-length commit) 1)
                        (string-prefix? "v" commit)
                        (char-set-contains? char-set:digit
                                            (string-ref commit 1)))
                   (string-drop commit 1)        ;looks like a tag like "v1.0"
                   (string-append "git."
                                  (if (< (string-length commit) 7)
                                      commit
                                      (string-take commit 7)))))
      (source (git-checkout (url url) (commit commit)
                            (recursive? #t)))))

  (let* ((replacements (evaluate-git-replacement-specs replacement-specs
                                                       replace))
         (rewrite      (package-input-rewriting/spec replacements)))
    (lambda (obj)
      (if (package? obj)
          (rewrite obj)
          obj))))

(define (transform-package-source-git-url replacement-specs)
  "Return a procedure that, when passed a package, replaces its dependencies
according to REPLACEMENT-SPECS.  REPLACEMENT-SPECS is a list of strings like
\"guile-json=https://gitthing.com/…\" meaning that packages are built using
a checkout of the Git repository at the given URL."
  (define replacements
    (map (lambda (spec)
           (match (string-tokenize spec %not-equal)
             ((spec url)
              (cons spec
                    (lambda (old)
                      (package
                        (inherit old)
                        (source (git-checkout (url url)
                                              (recursive? #t)))))))
             (_
              (raise
               (formatted-message
                (G_ "~a: invalid Git URL replacement specification")
                spec)))))
         replacement-specs))

  (define rewrite
    (package-input-rewriting/spec replacements))

  (lambda (obj)
    (if (package? obj)
        (rewrite obj)
        obj)))

(define (package-dependents/spec top bottom)
  "Return the list of dependents of BOTTOM, a spec string, that are also
dependencies of TOP, a package."
  (define-values (name version)
    (package-name->name+version bottom))

  (define dependent?
    (mlambda (p)
      (and (package? p)
           (or (and (string=? name (package-name p))
                    (or (not version)
                        (version-prefix? version (package-version p))))
               (match (bag-direct-inputs (package->bag p))
                 (((labels dependencies . _) ...)
                  (any dependent? dependencies)))))))

  (filter dependent? (package-closure (list top))))

(define (package-toolchain-rewriting p bottom toolchain)
  "Return a procedure that, when passed a package that's either BOTTOM or one
of its dependents up to P so, changes it so it is built with TOOLCHAIN.
TOOLCHAIN must be an input list."
  (define rewriting-property
    (gensym " package-toolchain-rewriting"))

  (match (package-dependents/spec p bottom)
    (()                                           ;P does not depend on BOTTOM
     identity)
    (set
     ;; SET is the list of packages "between" P and BOTTOM (included) whose
     ;; toolchain needs to be changed.
     (package-mapping (lambda (p)
                        (if (or (assq rewriting-property
                                      (package-properties p))
                                (not (memq p set)))
                            p
                            (let ((p (package-with-c-toolchain p toolchain)))
                              (package/inherit p
                                (properties `((,rewriting-property . #t)
                                              ,@(package-properties p)))))))
                      (lambda (p)
                        (or (assq rewriting-property (package-properties p))
                            (not (memq p set))))
                      #:deep? #t))))

(define (transform-package-toolchain replacement-specs)
  "Return a procedure that, when passed a package, changes its toolchain or
that of its dependencies according to REPLACEMENT-SPECS.  REPLACEMENT-SPECS is
a list of strings like \"fftw=gcc-toolchain@10\" meaning that the package to
the left of the equal sign must be built with the toolchain to the right of
the equal sign."
  (define split-on-commas
    (cute string-tokenize <> (char-set-complement (char-set #\,))))

  (define (specification->input spec)
    (let ((package (specification->package spec)))
      (list (package-name package) package)))

  (define replacements
    (map (lambda (spec)
           (match (string-tokenize spec %not-equal)
             ((spec (= split-on-commas toolchain))
              (cons spec (map specification->input toolchain)))
             (_
              (raise
               (formatted-message
                (G_ "~a: invalid toolchain replacement specification")
                spec)))))
         replacement-specs))

  (lambda (obj)
    (if (package? obj)
        (or (any (match-lambda
                   ((bottom . toolchain)
                    ((package-toolchain-rewriting obj bottom toolchain) obj)))
                 replacements)
            obj)
        obj)))

(define (transform-package-with-debug-info specs)
  "Return a procedure that, when passed a package, set its 'replacement' field
to the same package but with #:strip-binaries? #f in its 'arguments' field."
  (define (non-stripped p)
    (package
      (inherit p)
      (arguments
       (substitute-keyword-arguments (package-arguments p)
         ((#:strip-binaries? _ #f) #f)))))

  (define (package-with-debug-info p)
    (if (member "debug" (package-outputs p))
        p
        (let loop ((p p))
          (match (package-replacement p)
            (#f
             (package
               (inherit p)
               (replacement (non-stripped p))))
            (next
             (package
               (inherit p)
               (replacement (loop next))))))))

  (define rewrite
    (package-input-rewriting/spec (map (lambda (spec)
                                         (cons spec package-with-debug-info))
                                       specs)))

  (lambda (obj)
    (if (package? obj)
        (rewrite obj)
        obj)))

(define (transform-package-tests specs)
  "Return a procedure that, when passed a package, sets #:tests? #f in its
'arguments' field."
  (define (package-without-tests p)
    (package/inherit p
      (arguments
       (substitute-keyword-arguments (package-arguments p)
         ((#:tests? _ #f) #f)))))

  (define rewrite
    (package-input-rewriting/spec (map (lambda (spec)
                                         (cons spec package-without-tests))
                                       specs)))

  (lambda (obj)
    (if (package? obj)
        (rewrite obj)
        obj)))

(define %transformations
  ;; Transformations that can be applied to things to build.  The car is the
  ;; key used in the option alist, and the cdr is the transformation
  ;; procedure; it is called with two arguments: the store, and a list of
  ;; things to build.
  `((with-source . ,transform-package-source)
    (with-input  . ,transform-package-inputs)
    (with-graft  . ,transform-package-inputs/graft)
    (with-branch . ,transform-package-source-branch)
    (with-commit . ,transform-package-source-commit)
    (with-git-url . ,transform-package-source-git-url)
    (with-c-toolchain . ,transform-package-toolchain)
    (with-debug-info . ,transform-package-with-debug-info)
    (without-tests . ,transform-package-tests)))

(define (transformation-procedure key)
  "Return the transformation procedure associated with KEY, a symbol such as
'with-source', or #f if there is none."
  (any (match-lambda
         ((k . proc)
          (and (eq? k key) proc)))
       %transformations))


;;;
;;; Command-line handling.
;;;

(define %transformation-options
  ;; The command-line interface to the above transformations.
  (let ((parser (lambda (symbol)
                  (lambda (opt name arg result . rest)
                    (apply values
                           (alist-cons symbol arg result)
                           rest)))))
    (list (option '("with-source") #t #f
                  (parser 'with-source))
          (option '("with-input") #t #f
                  (parser 'with-input))
          (option '("with-graft") #t #f
                  (parser 'with-graft))
          (option '("with-branch") #t #f
                  (parser 'with-branch))
          (option '("with-commit") #t #f
                  (parser 'with-commit))
          (option '("with-git-url") #t #f
                  (parser 'with-git-url))
          (option '("with-c-toolchain") #t #f
                  (parser 'with-c-toolchain))
          (option '("with-debug-info") #t #f
                  (parser 'with-debug-info))
          (option '("without-tests") #t #f
                  (parser 'without-tests)))))

(define (show-transformation-options-help)
  (display (G_ "
      --with-source=[PACKAGE=]SOURCE
                         use SOURCE when building the corresponding package"))
  (display (G_ "
      --with-input=PACKAGE=REPLACEMENT
                         replace dependency PACKAGE by REPLACEMENT"))
  (display (G_ "
      --with-graft=PACKAGE=REPLACEMENT
                         graft REPLACEMENT on packages that refer to PACKAGE"))
  (display (G_ "
      --with-branch=PACKAGE=BRANCH
                         build PACKAGE from the latest commit of BRANCH"))
  (display (G_ "
      --with-commit=PACKAGE=COMMIT
                         build PACKAGE from COMMIT"))
  (display (G_ "
      --with-git-url=PACKAGE=URL
                         build PACKAGE from the repository at URL"))
  (display (G_ "
      --with-c-toolchain=PACKAGE=TOOLCHAIN
                         build PACKAGE and its dependents with TOOLCHAIN"))
  (display (G_ "
      --with-debug-info=PACKAGE
                         build PACKAGE and preserve its debug info"))
  (display (G_ "
      --without-tests=PACKAGE
                         build PACKAGE without running its tests")))


(define (options->transformation opts)
  "Return a procedure that, when passed an object to build (package,
derivation, etc.), applies the transformations specified by OPTS and returns
the resulting objects.  OPTS must be a list of symbol/string pairs such as:

  ((with-branch . \"guile-gcrypt=master\")
   (without-tests . \"libgcrypt\"))

Each symbol names a transformation and the corresponding string is an argument
to that transformation."
  (define applicable
    ;; List of applicable transformations as symbol/procedure pairs in the
    ;; order in which they appear on the command line.
    (filter-map (match-lambda
                  ((key . value)
                   (match (transformation-procedure key)
                     (#f
                      #f)
                     (transform
                      ;; XXX: We used to pass TRANSFORM a list of several
                      ;; arguments, but we now pass only one, assuming that
                      ;; transform composes well.
                      (list key value (transform (list value)))))))
                (reverse opts)))

  (define (package-with-transformation-properties p)
    (package/inherit p
      (properties `((transformations
                     . ,(map (match-lambda
                               ((key value _)
                                (cons key value)))
                             applicable))
                    ,@(package-properties p)))))

  (lambda (obj)
    (define (tagged-object new)
      (if (and (not (eq? obj new))
               (package? new) (not (null? applicable)))
          (package-with-transformation-properties new)
          new))

    (tagged-object
     (fold (match-lambda*
             (((name value transform) obj)
              (let ((new (transform obj)))
                (when (eq? new obj)
                  (warning (G_ "transformation '~a' had no effect on ~a~%")
                           name
                           (if (package? obj)
                               (package-full-name obj)
                               obj)))
                new)))
           obj
           applicable))))

(define (package-transformations package)
  "Return the transformations applied to PACKAGE according to its properties."
  (match (assq-ref (package-properties package) 'transformations)
    (#f '())
    (transformations transformations)))

(define (manifest-entry-with-transformations entry)
  "Return ENTRY with an additional 'transformations' property if it's not
already there."
  (let ((properties (manifest-entry-properties entry)))
    (if (assq 'transformations properties)
        entry
        (let ((item (manifest-entry-item entry)))
          (manifest-entry
            (inherit entry)
            (properties
             (match (and (package? item)
                         (package-transformations item))
               ((or #f '())
                properties)
               (transformations
                `((transformations . ,transformations)
                  ,@properties)))))))))
