;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2017 David Craven <david@craven.ch>
;;; Copyright © 2017, 2020 Mathieu Othacehe <m.othacehe@gmail.com>
;;; Copyright © 2017 Leo Famulari <leo@famulari.name>
;;; Copyright © 2019 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2020 Jan (janneke) Nieuwenhuizen <janneke@gnu.org>
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

(define-module (gnu bootloader)
  #:use-module (guix discovery)
  #:use-module (guix records)
  #:use-module (guix ui)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 match)
  #:export (menu-entry
            menu-entry?
            menu-entry-label
            menu-entry-device
            menu-entry-linux
            menu-entry-linux-arguments
            menu-entry-initrd
            menu-entry-device-mount-point
            menu-entry-multiboot-kernel
            menu-entry-multiboot-arguments
            menu-entry-multiboot-modules

            menu-entry->sexp
            sexp->menu-entry

            bootloader
            bootloader?
            bootloader-name
            bootloader-package
            bootloader-installer
            bootloader-disk-image-installer
            bootloader-configuration-file
            bootloader-configuration-file-generator

            bootloader-configuration
            bootloader-configuration?
            bootloader-configuration-bootloader
            bootloader-configuration-target
            bootloader-configuration-menu-entries
            bootloader-configuration-default-entry
            bootloader-configuration-timeout
            bootloader-configuration-keyboard-layout
            bootloader-configuration-theme
            bootloader-configuration-terminal-outputs
            bootloader-configuration-terminal-inputs
            bootloader-configuration-serial-unit
            bootloader-configuration-serial-speed
            bootloader-configuration-additional-configuration

            %bootloaders
            lookup-bootloader-by-name))


;;;
;;; Menu-entry record.
;;;

(define-record-type* <menu-entry>
  menu-entry make-menu-entry
  menu-entry?
  (label           menu-entry-label)
  (device          menu-entry-device       ; file system uuid, label, or #f
                   (default #f))
  (device-mount-point menu-entry-device-mount-point
                   (default #f))
  (linux           menu-entry-linux
                   (default #f))
  (linux-arguments menu-entry-linux-arguments
                   (default '()))          ; list of string-valued gexps
  (initrd          menu-entry-initrd       ; file name of the initrd as a gexp
                   (default #f))
  (multiboot-kernel menu-entry-multiboot-kernel
                    (default #f))
  (multiboot-arguments menu-entry-multiboot-arguments
                       (default '()))      ; list of string-valued gexps
  (multiboot-modules menu-entry-multiboot-modules
                     (default '())))       ; list of multiboot commands, where
                                           ; a command is a list of <string>

(define (menu-entry->sexp entry)
  "Return ENTRY serialized as an sexp."
  (match entry
    (($ <menu-entry> label device mount-point linux linux-arguments initrd #f
                     ())
     `(menu-entry (version 0)
                  (label ,label)
                  (device ,device)
                  (device-mount-point ,mount-point)
                  (linux ,linux)
                  (linux-arguments ,linux-arguments)
                  (initrd ,initrd)))
    (($ <menu-entry> label device mount-point #f () #f
                     multiboot-kernel multiboot-arguments multiboot-modules)
     `(menu-entry (version 0)
                  (label ,label)
                  (device ,device)
                  (device-mount-point ,mount-point)
                  (multiboot-kernel ,multiboot-kernel)
                  (multiboot-arguments ,multiboot-arguments)
                  (multiboot-modules ,multiboot-modules)))))

(define (sexp->menu-entry sexp)
  "Turn SEXP, an sexp as returned by 'menu-entry->sexp', into a <menu-entry>
record."
  (match sexp
    (('menu-entry ('version 0)
                  ('label label) ('device device)
                  ('device-mount-point mount-point)
                  ('linux linux) ('linux-arguments linux-arguments)
                  ('initrd initrd) _ ...)
     (menu-entry
      (label label)
      (device device)
      (device-mount-point mount-point)
      (linux linux)
      (linux-arguments linux-arguments)
      (initrd initrd)))
    (('menu-entry ('version 0)
                  ('label label) ('device device)
                  ('device-mount-point mount-point)
                  ('multiboot-kernel multiboot-kernel)
                  ('multiboot-arguments multiboot-arguments)
                  ('multiboot-modules multiboot-modules) _ ...)
     (menu-entry
      (label label)
      (device device)
      (device-mount-point mount-point)
      (multiboot-kernel multiboot-kernel)
      (multiboot-arguments multiboot-arguments)
      (multiboot-modules multiboot-modules)))))


;;;
;;; Bootloader record.
;;;

;; The <bootloader> record contains fields expressing how the bootloader
;; should be installed. Every bootloader in gnu/bootloader/ directory
;; has to be described by this record.

(define-record-type* <bootloader>
  bootloader make-bootloader
  bootloader?
  (name                            bootloader-name)
  (package                         bootloader-package)
  (installer                       bootloader-installer)
  (disk-image-installer            bootloader-disk-image-installer
                                   (default #f))
  (configuration-file              bootloader-configuration-file)
  (configuration-file-generator    bootloader-configuration-file-generator))


;;;
;;; Bootloader configuration record.
;;;

;; The <bootloader-configuration> record contains bootloader independant
;; configuration used to fill bootloader configuration file.

(define-record-type* <bootloader-configuration>
  bootloader-configuration make-bootloader-configuration
  bootloader-configuration?
  (bootloader         bootloader-configuration-bootloader) ;<bootloader>
  (target             bootloader-configuration-target      ;string
                      (default #f))
  (menu-entries       bootloader-configuration-menu-entries ;list of <menu-entry>
                      (default '()))
  (default-entry      bootloader-configuration-default-entry ;integer
                      (default 0))
  (timeout            bootloader-configuration-timeout ;seconds as integer
                      (default 5))
  (keyboard-layout    bootloader-configuration-keyboard-layout ;<keyboard-layout> | #f
                      (default #f))
  (theme              bootloader-configuration-theme ;bootloader-specific theme
                      (default #f))
  (terminal-outputs   bootloader-configuration-terminal-outputs ;list of symbols
                      (default '(gfxterm)))
  (terminal-inputs    bootloader-configuration-terminal-inputs ;list of symbols
                      (default '()))
  (serial-unit        bootloader-configuration-serial-unit ;integer | #f
                      (default #f))
  (serial-speed       bootloader-configuration-serial-speed ;integer | #f
                      (default #f)))


;;;
;;; Bootloaders.
;;;

(define (bootloader-modules)
  "Return the list of bootloader modules."
  (all-modules (map (lambda (entry)
                      `(,entry . "gnu/bootloader"))
                    %load-path)
               #:warn warn-about-load-error))

(define %bootloaders
  ;; The list of publically-known bootloaders.
  (delay (fold-module-public-variables (lambda (obj result)
                                         (if (bootloader? obj)
                                             (cons obj result)
                                             result))
                                       '()
                                       (bootloader-modules))))

(define (lookup-bootloader-by-name name)
  "Return the bootloader called NAME."
  (or (find (lambda (bootloader)
              (eq? name (bootloader-name bootloader)))
            (force %bootloaders))
      (leave (G_ "~a: no such bootloader~%") name)))
