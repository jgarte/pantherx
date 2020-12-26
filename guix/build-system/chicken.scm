;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2020 raingloom <raingloom@riseup.net>
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

(define-module (guix build-system chicken)
  #:use-module (guix utils)
  #:use-module (guix derivations)
  #:use-module (guix search-paths)
  #:use-module (guix build-system)
  #:use-module (guix build-system gnu)
  #:use-module (guix packages)
  #:use-module (ice-9 match)
  #:export (%chicken-build-system-modules
            chicken-build
            chicken-build-system))

(define %chicken-build-system-modules
  ;; Build-side modules imported and used by default.
  `((guix build chicken-build-system)
    (guix build union)
    ,@%gnu-build-system-modules))

(define (default-chicken)
  ;; Lazily resolve the binding to avoid a circular dependency.
  ;; TODO is this actually needed in every build system?
  (let ((chicken (resolve-interface '(gnu packages chicken))))
      (module-ref chicken 'chicken)))

(define* (lower name
                #:key source inputs native-inputs outputs system target
                (chicken (default-chicken))
                #:allow-other-keys
                #:rest arguments)
  "Return a bag for NAME."
  (define private-keywords
    '(#:source #:target #:chicken #:inputs #:native-inputs))

  ;; TODO: cross-compilation support
  (and (not target)
       (bag
         (name name)
         (system system)
         (host-inputs `(,@(if source
                              `(("source" ,source))
                              '())
                        ,@inputs

                        ;; Keep the standard inputs of 'gnu-build-system', since
                        ;; Chicken compiles Scheme by using C as an intermediate
                        ;; language.
                        ,@(standard-packages)))
         (build-inputs `(("chicken" ,chicken)
                         ,@native-inputs))
         (outputs outputs)
         (build chicken-build)
         (arguments (strip-keyword-arguments private-keywords arguments)))))

(define* (chicken-build store name inputs
                   #:key
                   (phases '(@ (guix build chicken-build-system)
                               %standard-phases))
                   (outputs '("out"))
                   (search-paths '())
                   (egg-name "")
                   (unpack-path "")
                   (build-flags ''())
                   (tests? #t)
                   (system (%current-system))
                   (guile #f)
                   (imported-modules %chicken-build-system-modules)
                   (modules '((guix build chicken-build-system)
                              (guix build union)
                              (guix build utils))))
  (define builder
    `(begin
       (use-modules ,@modules)
       (chicken-build #:name ,name
                 #:source ,(match (assoc-ref inputs "source")
                             (((? derivation? source))
                              (derivation->output-path source))
                             ((source)
                              source)
                             (source
                              source))
                 #:system ,system
                 #:phases ,phases
                 #:outputs %outputs
                 #:search-paths ',(map search-path-specification->sexp
                                       search-paths)
                 #:egg-name ,egg-name
                 #:unpack-path ,unpack-path
                 #:build-flags ,build-flags
                 #:tests? ,tests?
                 #:inputs %build-inputs)))

  (define guile-for-build
    (match guile
      ((? package?)
       (package-derivation store guile system #:graft? #f))
      (#f                                         ; the default
       (let* ((distro (resolve-interface '(gnu packages commencement)))
              (guile  (module-ref distro 'guile-final)))
         (package-derivation store guile system
                             #:graft? #f)))))

  (build-expression->derivation store name builder
                                #:inputs inputs
                                #:system system
                                #:modules imported-modules
                                #:outputs outputs
                                #:guile-for-build guile-for-build))

(define chicken-build-system
  (build-system
    (name 'chicken)
    (description
     "Build system for Chicken Scheme programs")
    (lower lower)))
