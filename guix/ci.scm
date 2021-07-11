;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2018, 2019, 2020, 2021 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2020 Mathieu Othacehe <othacehe@gnu.org>
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

(define-module (guix ci)
  #:use-module (guix http-client)
  #:use-module (guix utils)
  #:use-module (json)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 match)
  #:use-module (guix i18n)
  #:use-module (guix diagnostics)
  #:autoload   (guix channels) (channel)
  #:export (build-product?
            build-product-id
            build-product-type
            build-product-file-size
            build-product-path

            build?
            build-id
            build-derivation
            build-evaluation
            build-system
            build-status
            build-timestamp
            build-products

            checkout?
            checkout-commit
            checkout-channel

            evaluation?
            evaluation-id
            evaluation-spec
            evaluation-complete?
            evaluation-checkouts

            job?
            job-build-id
            job-status
            job-name

            %query-limit
            queued-builds
            latest-builds
            evaluation
            evaluation-jobs
            build
            job-build
            latest-evaluations
            evaluations-for-commit

            channel-with-substitutes-available))

;;; Commentary:
;;;
;;; This module provides a client to the HTTP interface of the Hydra and
;;; Cuirass continuous integration (CI) tools.
;;;
;;; Code:

(define-json-mapping <build-product> make-build-product
  build-product?
  json->build-product
  (id          build-product-id)                  ;integer
  (type        build-product-type)                ;string
  (file-size   build-product-file-size)           ;integer
  (path        build-product-path))               ;string

(define-syntax-rule (define-enumeration-mapping proc
                      (names integers) ...)
  (define (proc value)
    (match value
      (integers 'names) ...)))

(define-enumeration-mapping integer->build-status
  ;; Copied from 'build-status' in Cuirass.
  (submitted        -3)
  (scheduled        -2)
  (started          -1)
  (succeeded         0)
  (failed            1)
  (failed-dependency 2)
  (failed-other      3)
  (canceled          4))

(define-json-mapping <build> make-build build?
  json->build
  (id          build-id "id")                     ;integer
  (derivation  build-derivation)                  ;string | #f
  (evaluation  build-evaluation)                  ;integer
  (system      build-system)                      ;string
  (status      build-status "buildstatus"         ;symbol
               integer->build-status)
  (timestamp   build-timestamp)                   ;integer
  (products    build-products "buildproducts"     ;<build-product>*
               (lambda (products)
                 (map json->build-product
                      ;; Before Cuirass 3db603c1, #f is always returned.
                      (if (vector? products)
                          (vector->list products)
                          '())))))

(define-json-mapping <job> make-job job?
  json->job
  (build-id    job-build-id "build")              ;integer
  (status      job-status "status"                ;symbol
               integer->build-status)
  (name        job-name))                         ;string

(define-json-mapping <checkout> make-checkout checkout?
  json->checkout
  (commit      checkout-commit)                   ;string (SHA1)
  (channel     checkout-channel))                 ;string (name)

(define-json-mapping <evaluation> make-evaluation evaluation?
  json->evaluation
  (id          evaluation-id)                     ;integer
  (spec        evaluation-spec "specification")   ;string
  (complete?   evaluation-complete? "status"
               (match-lambda
                 (0 #t)
                 (_ #f)))                         ;Boolean
  (checkouts   evaluation-checkouts "checkouts"   ;<checkout>*
               (lambda (checkouts)
                 (map json->checkout
                      (vector->list checkouts)))))

(define %query-limit
  ;; Max number of builds requested in queries.
  1000)

(define (json-fetch url)
  (let* ((port (http-fetch url))
         (json (json->scm port)))
    (close-port port)
    json))

(define* (queued-builds url #:optional (limit %query-limit))
  "Return the list of queued derivations on URL."
  (let ((queue (json-fetch (string-append url "/api/queue?nr="
                                          (number->string limit)))))
    (map json->build (vector->list queue))))

(define* (latest-builds url #:optional (limit %query-limit)
                        #:key evaluation system job status)
  "Return the latest builds performed by the CI server at URL.  If EVALUATION
is an integer, restrict to builds of EVALUATION.  If SYSTEM is true (a system
string such as \"x86_64-linux\"), restrict to builds for SYSTEM."
  (define* (option name value #:optional (->string identity))
    (if value
        (string-append "&" name "=" (->string value))
        ""))

  (let ((latest (json-fetch (string-append url "/api/latestbuilds?nr="
                                           (number->string limit)
                                           (option "evaluation" evaluation
                                                   number->string)
                                           (option "system" system)
                                           (option "job" job)
                                           (option "status" status
                                                   number->string)))))
    ;; Note: Hydra does not provide a "derivation" field for entries in
    ;; 'latestbuilds', but Cuirass does.
    (map json->build (vector->list latest))))

(define (evaluation url evaluation)
  "Return the given EVALUATION performed by the CI server at URL."
  (let ((evaluation (json-fetch
                     (string-append url "/api/evaluation?id="
                                    (number->string evaluation)))))
    (json->evaluation evaluation)))

(define* (latest-evaluations url
                             #:optional (limit %query-limit)
                             #:key spec)
  "Return the latest evaluations performed by the CI server at URL.  If SPEC
is passed, only consider the evaluations for the given SPEC specification."
  (let ((spec (if spec
                  (format #f "&spec=~a" spec)
                  "")))
    (map json->evaluation
         (vector->list
          (json->scm
           (http-fetch
            (string-append url "/api/evaluations?nr="
                           (number->string limit)
                           spec)))))))

(define* (evaluations-for-commit url commit #:optional (limit %query-limit))
  "Return the evaluations among the latest LIMIT evaluations that have COMMIT
as one of their inputs."
  (filter (lambda (evaluation)
            (find (lambda (checkout)
                    (string=? (checkout-commit checkout) commit))
                  (evaluation-checkouts evaluation)))
          (latest-evaluations url limit)))

(define (evaluation-jobs url evaluation-id)
  "Return the list of jobs of evaluation EVALUATION-ID."
  (map json->job
       (vector->list
        (json->scm (http-fetch
                    (string-append url "/api/jobs?evaluation="
                                   (number->string evaluation-id)))))))

(define (build url id)
  "Look up build ID at URL and return it.  Raise &http-get-error if it is not
found (404)."
  (json->build
   (http-fetch (string-append url "/build/"       ;note: no "/api" here
                              (number->string id)))))

(define (job-build url job)
  "Return the build associated with JOB."
  (build url (job-build-id job)))

;; TODO: job history:
;; https://ci.guix.gnu.org/api/jobs/history?spec=master&names=coreutils.x86_64-linux&nr=10

(define (find-latest-commit-with-substitutes url)
  "Return the latest commit with available substitutes for the Guix package
definitions at URL.  Return false if no commit were found."
  (let* ((job-name (string-append "guix." (%current-system)))
         (build (match (latest-builds url 1
                                      #:job job-name
                                      #:status 0) ;success
                  ((build) build)
                  (_ #f)))
         (evaluation (and build
                          (evaluation url (build-evaluation build))))
         (commit (and evaluation
                      (match (evaluation-checkouts evaluation)
                        ((checkout)
                         (checkout-commit checkout))))))
    commit))

(define (channel-with-substitutes-available chan url)
  "Return a channel inheriting from CHAN but which commit field is set to the
latest commit with available substitutes for the Guix package definitions at
URL.  The current system is taken into account.

If no commit with available substitutes were found, the commit field is set to
false and a warning message is printed."
  (let ((commit (find-latest-commit-with-substitutes url)))
    (unless commit
      (warning (G_ "could not find available substitutes at ~a~%")
               url))
    (channel
     (inherit chan)
     (commit commit))))
