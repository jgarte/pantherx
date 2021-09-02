;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2021 Maxime Devos <maximedevos@telenet.be>
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

(define-module (test-minetest)
  #:use-module (guix memoization)
  #:use-module (guix import minetest)
  #:use-module (guix import utils)
  #:use-module (guix tests)
  #:use-module (json)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (srfi srfi-34)
  #:use-module (srfi srfi-64))


;; Some procedures for populating a ‘fake’ ContentDB server.

(define* (make-package-sexp #:key
                            (guix-name "minetest-foo")
                            (home-page "https://example.org/foo")
                            (repo "https://example.org/foo.git")
                            (synopsis "synopsis")
                            (guix-description "description")
                            (guix-license
                             '(list license:cc-by-sa4.0 license:lgpl3+))
                            (inputs '())
                            (upstream-name "Author/foo")
                            #:allow-other-keys)
  `(package
     (name ,guix-name)
     ;; This is not a proper version number but ContentDB does not include
     ;; version numbers.
     (version "2021-07-25")
     (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url ,(and (not (eq? repo 'null)) repo))
              (commit #f)))
        (sha256
         (base32 #f))
        (file-name (git-file-name name version))))
     (build-system minetest-mod-build-system)
     ,@(maybe-propagated-inputs inputs)
     (home-page ,home-page)
     (synopsis ,synopsis)
     (description ,guix-description)
     (license ,guix-license)
     (properties
      ,(list 'quasiquote
             `((upstream-name . ,upstream-name))))))

(define* (make-package-json #:key
                            (author "Author")
                            (name "foo")
                            (media-license "CC-BY-SA-4.0")
                            (license "LGPL-3.0-or-later")
                            (short-description "synopsis")
                            (long-description "description")
                            (repo "https://example.org/foo.git")
                            (website "https://example.org/foo")
                            (forums 321)
                            (score 987.654)
                            (downloads 123)
                            (type "mod")
                            #:allow-other-keys)
  `(("author" . ,author)
    ("content_warnings" . #())
    ("created_at" . "2018-05-23T19:58:07.422108")
    ("downloads" . ,downloads)
    ("forums" . ,forums)
    ("issue_tracker" . "https://example.org/foo/issues")
    ("license" . ,license)
    ("long_description" . ,long-description)
    ("maintainers" . #("maintainer"))
    ("media_license" . ,media-license)
    ("name" . ,name)
    ("provides" . #("stuff"))
    ("release" . 456)
    ("repo" . ,repo)
    ("score" . ,score)
    ("screenshots" . #())
    ("short_description" . ,short-description)
    ("state" . "APPROVED")
    ("tags" . #("some" "tags"))
    ("thumbnail" . null)
    ("title" . "The name")
    ("type" . ,type)
    ("url" . ,(string-append "https://content.minetest.net/packages/"
                             author "/" name "/download/"))
    ("website" . ,website)))

(define* (make-releases-json #:key (commit #f) (title "") #:allow-other-keys)
  `#((("commit" . ,commit)
      ("downloads" . 469)
      ("id" . 8614)
      ("max_minetest_version" . null)
      ("min_minetest_version" . null)
      ("release_date" . "2021-07-25T01:10:23.207584")
      ("title" . "2021-07-25"))))

(define* (make-dependencies-json #:key (author "Author")
                                 (name "foo")
                                 (requirements '(("default" #f ())))
                                 #:allow-other-keys)
  `((,(string-append author "/" name)
     . ,(list->vector
         (map (match-lambda
                ((symbolic-name optional? implementations)
                 `(("is_optional" . ,optional?)
                   ("name" . ,symbolic-name)
                   ("packages" . ,(list->vector implementations)))))
              requirements)))
    ("something/else" . #())))

(define* (make-packages-keys-json #:key (author "Author")
                                  (name "Name")
                                  (type "mod"))
  `(("author" . ,author)
    ("name" . ,name)
    ("type" . ,type)))

(define (call-with-packages thunk . argument-lists)
  ;; Don't reuse results from previous tests.
  (invalidate-memoization! contentdb-fetch)
  (invalidate-memoization! minetest->guix-package)
  (define (scm->json-port scm)
    (open-input-string (scm->json-string scm)))
  (define (handle-package url requested-author requested-name . rest)
    (define relevant-argument-list
      (any (lambda (argument-list)
             (apply (lambda* (#:key (author "Author") (name "foo")
                              #:allow-other-keys)
                      (and (equal? requested-author author)
                           (equal? requested-name name)
                           argument-list))
                    argument-list))
           argument-lists))
    (when (not relevant-argument-list)
      (error "the package ~a/~a should be irrelevant, but ~a is fetched"
             requested-author requested-name url))
    (scm->json-port
     (apply (match rest
              (("") make-package-json)
              (("dependencies" "") make-dependencies-json)
              (("releases" "") make-releases-json)
              (_ (error "TODO ~a" rest)))
            relevant-argument-list)))
  (define (handle-mod-search sort)
    ;; Produce search results, sorted by SORT in descending order.
    (define arguments->key
      (match sort
        ("score" (lambda* (#:key (score 987.654) #:allow-other-keys)
                   score))
        ("downloads" (lambda* (#:key (downloads 123) #:allow-other-keys)
                       downloads))))
    (define argument-list->key (cut apply arguments->key <>))
    (define (greater x y)
      (> (argument-list->key x) (argument-list->key y)))
    (define sorted-argument-lists (sort-list argument-lists greater))
    (define* (arguments->json #:key (author "Author") (name "Foo") (type "mod")
                              #:allow-other-keys)
      (and (string=? type "mod")
           `(("author" . ,author)
             ("name" . ,name)
             ("type" . ,type))))
    (define argument-list->json (cut apply arguments->json <>))
    (scm->json-port
     (list->vector (filter-map argument-list->json sorted-argument-lists))))
  (mock ((guix http-client) http-fetch
         (lambda* (url #:key headers)
           (unless (string-prefix? "mock://api/packages/" url)
             (error "the URL ~a should not be used" url))
           (define resource
             (substring url (string-length "mock://api/packages/")))
           (define components (string-split resource #\/))
           (match components
             ((author name . rest)
              (apply handle-package url author name rest))
             (((? (cut string-prefix? "?type=mod&q=" <>) query))
              (handle-mod-search
               (cond ((string-contains query "sort=score") "score")
                     ((string-contains query "sort=downloads") "downloads")
                     (#t (error "search query ~a has unknown sort key"
                                query)))))
             (_
              (error "the URL ~a should have an author and name component"
                     url)))))
        (parameterize ((%contentdb-api "mock://api/"))
          (thunk))))

(define* (minetest->guix-package* #:key (author "Author") (name "foo")
                                  (sort %default-sort-key)
                                  #:allow-other-keys)
  (minetest->guix-package (string-append author "/" name) #:sort sort))

(define (imported-package-sexp* primary-arguments . secondary-arguments)
  "Ask the importer to import a package specified by PRIMARY-ARGUMENTS,
during a dynamic where that package and the packages specified by
SECONDARY-ARGUMENTS are available on ContentDB."
  (apply call-with-packages
         (lambda ()
           ;; The memoization cache is reset by call-with-packages
           (apply minetest->guix-package* primary-arguments))
   primary-arguments
   secondary-arguments))

(define (imported-package-sexp . extra-arguments)
  "Ask the importer to import a package specified by EXTRA-ARGUMENTS,
during a dynamic extent where that package is available on ContentDB."
  (imported-package-sexp* extra-arguments))

(define-syntax-rule (test-package test-case . extra-arguments)
  (test-equal test-case
    (make-package-sexp . extra-arguments)
    (imported-package-sexp . extra-arguments)))

(define-syntax-rule (test-package* test-case primary-arguments extra-arguments
                                   ...)
  (test-equal test-case
    (apply make-package-sexp primary-arguments)
    (imported-package-sexp* primary-arguments extra-arguments ...)))

(test-begin "minetest")


;; Package names
(test-package "minetest->guix-package")
(test-package "minetest->guix-package, _ → - in package name"
              #:name "foo_bar"
              #:guix-name "minetest-foo-bar"
              #:upstream-name "Author/foo_bar")

(test-equal "elaborate names, unambigious"
  "Jeija/mesecons"
  (call-with-packages
   (cut elaborate-contentdb-name "mesecons")
   '(#:name "mesecons" #:author "Jeija")
   '(#:name "something" #:author "else")))

(test-equal "elaborate name, ambigious (highest score)"
  "Jeija/mesecons"
  (call-with-packages
   ;; #:sort "score" is the default
   (cut elaborate-contentdb-name "mesecons")
   '(#:name "mesecons" #:author "Jeijc" #:score 777)
   '(#:name "mesecons" #:author "Jeijb" #:score 888)
   '(#:name "mesecons" #:author "Jeija" #:score 999)))


(test-equal "elaborate name, ambigious (most downloads)"
  "Jeija/mesecons"
  (call-with-packages
   (cut elaborate-contentdb-name "mesecons" #:sort "downloads")
   '(#:name "mesecons" #:author "Jeijc" #:downloads 777)
   '(#:name "mesecons" #:author "Jeijb" #:downloads 888)
   '(#:name "mesecons" #:author "Jeija" #:downloads 999)))


;; Determining the home page
(test-package "minetest->guix-package, website is used as home page"
              #:home-page "web://site"
              #:website "web://site")
(test-package "minetest->guix-package, if absent, the forum is used"
              #:home-page '(minetest-topic 628)
              #:forums 628
              #:website 'null)
(test-package "minetest->guix-package, if absent, the git repo is used"
              #:home-page "https://github.com/minetest-mods/mesecons"
              #:forums 'null
              #:website 'null
              #:repo "https://github.com/minetest-mods/mesecons")
(test-package "minetest->guix-package, all home page information absent"
              #:home-page #f
              #:forums 'null
              #:website 'null
              #:repo 'null)



;; Dependencies
(test-package* "minetest->guix-package, unambigious dependency"
  (list #:requirements '(("mesecons" #f
                          ("Jeija/mesecons"
                           "some-modpack/containing-mese")))
        #:inputs '("minetest-mesecons"))
  (list #:author "Jeija" #:name "mesecons")
  (list #:author "some-modpack" #:name "containing-mese" #:type "modpack"))

(test-package* "minetest->guix-package, ambigious dependency (highest score)"
  (list #:name "frobnicate"
        #:guix-name "minetest-frobnicate"
        #:upstream-name "Author/frobnicate"
        #:requirements '(("frob" #f
                          ("Author/foo" "Author/bar")))
        ;; #:sort "score" is the default
        #:inputs '("minetest-bar"))
  (list #:author "Author" #:name "foo" #:score 0)
  (list #:author "Author" #:name "bar" #:score 9999))

(test-package* "minetest->guix-package, ambigious dependency (most downloads)"
  (list #:name "frobnicate"
        #:guix-name "minetest-frobnicate"
        #:upstream-name "Author/frobnicate"
        #:requirements '(("frob" #f
                          ("Author/foo" "Author/bar")))
        #:inputs '("minetest-bar")
        #:sort "downloads")
  (list #:author "Author" #:name "foo" #:downloads 0)
  (list #:author "Author" #:name "bar" #:downloads 9999))

(test-package "minetest->guix-package, optional dependency"
              #:requirements '(("mesecons" #t
                                ("Jeija/mesecons"
                                 "some-modpack/containing-mese")))
              #:inputs '())


;; License
(test-package "minetest->guix-package, identical licenses"
              #:guix-license 'license:lgpl3+
              #:license "LGPL-3.0-or-later"
              #:media-license "LGPL-3.0-or-later")

;; Sorting
(let* ((make-package
        (lambda arguments
          (json->package (apply make-package-json arguments))))
       (x (make-package #:score 0))
       (y (make-package #:score 1))
       (z (make-package #:score 2)))
  (test-equal "sort-packages, already sorted"
    (list z y x)
    (sort-packages (list z y x)))
  (test-equal "sort-packages, reverse"
    (list z y x)
    (sort-packages (list x y z))))

(test-end "minetest")
