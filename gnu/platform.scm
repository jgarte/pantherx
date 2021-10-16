;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2021 Mathieu Othacehe <othacehe@gnu.org>
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

(define-module (gnu platform)
  #:use-module (guix records)
  #:export (platform
            platform?
            platform-target
            platform-system
            platform-linux-architecture))


;;;
;;; Platform record.
;;;

;; Description of a platform supported by the GNU system.
(define-record-type* <platform> platform make-platform
  platform?
  (target             platform-target)               ;"x86_64-linux-gnu"
  (system             platform-system)               ;"x86_64-linux"
  (linux-architecture platform-linux-architecture    ;"amd64"
                      (default #f)))
