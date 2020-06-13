;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012, 2013, 2014, 2015, 2016, 2017 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2014 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2020 Arun Isaac <arunisaac@systemreboot.net>
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

(define-module (guix combinators)
  #:use-module (ice-9 match)
  #:use-module (ice-9 vlist)
  #:export (fold2
            fold-tree
            fold-tree-leaves
            compile-time-value))

;;; Commentary:
;;;
;;; This module provides useful combinators that complement SRFI-1 and
;;; friends.
;;;
;;; Code:

(define fold2
  (case-lambda
    ((proc seed1 seed2 lst)
     "Like `fold', but with a single list and two seeds."
     (let loop ((result1 seed1)
                (result2 seed2)
                (lst     lst))
       (if (null? lst)
           (values result1 result2)
           (call-with-values
               (lambda () (proc (car lst) result1 result2))
             (lambda (result1 result2)
               (loop result1 result2 (cdr lst)))))))
    ((proc seed1 seed2 lst1 lst2)
     "Like `fold', but with a two lists and two seeds."
     (let loop ((result1 seed1)
                (result2 seed2)
                (lst1    lst1)
                (lst2    lst2))
       (if (or (null? lst1) (null? lst2))
           (values result1 result2)
           (call-with-values
               (lambda () (proc (car lst1) (car lst2) result1 result2))
             (lambda (result1 result2)
               (loop result1 result2 (cdr lst1) (cdr lst2)))))))))

(define (fold-tree proc init children roots)
  "Call (PROC NODE RESULT) for each node in the tree that is reachable from
ROOTS, using INIT as the initial value of RESULT.  The order in which nodes
are traversed is not specified, however, each node is visited only once, based
on an eq? check.  Children of a node to be visited are generated by
calling (CHILDREN NODE), the result of which should be a list of nodes that
are connected to NODE in the tree, or '() or #f if NODE is a leaf node."
  (let loop ((result init)
             (seen vlist-null)
             (lst roots))
    (match lst
      (() result)
      ((head . tail)
       (if (not (vhash-assq head seen))
           (loop (proc head result)
                 (vhash-consq head #t seen)
                 (match (children head)
                   ((or () #f) tail)
                   (children (append tail children))))
           (loop result seen tail))))))

(define (fold-tree-leaves proc init children roots)
  "Like fold-tree, but call (PROC NODE RESULT) only for leaf nodes."
  (fold-tree
   (lambda (node result)
     (match (children node)
       ((or () #f) (proc node result))
       (else result)))
   init children roots))

(define-syntax compile-time-value                 ;not quite at home
  (syntax-rules ()
    "Evaluate the given expression at compile time.  The expression must
evaluate to a simple datum."
    ((_ exp)
     (let-syntax ((v (lambda (s)
                       (let ((val exp))
                         (syntax-case s ()
                           (_ #`'#,(datum->syntax s val)))))))
       v))))

;;; combinators.scm ends here
