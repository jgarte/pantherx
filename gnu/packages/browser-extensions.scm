;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2020 Marius Bakke <marius@gnu.org>
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

(define-module (gnu packages browser-extensions)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu build chromium-extension)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages python))

(define play-to-kodi
  (package
    (name "play-to-kodi")
    (version "1.9.1")
    (home-page "https://github.com/khloke/play-to-xbmc-chrome")
    (source (origin
              (method git-fetch)
              (uri (git-reference (url home-page) (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "01rmcpbkn9vhcd8mrah2jmd2801k2r5fz7aqvp22hbwmh2z5f1ch"))))
    (build-system copy-build-system)
    (synopsis "Send website contents to Kodi")
    (description
     "Play to Kodi is a browser add-on that can send video, audio, and other
supported content to the Kodi media center.")
    (license license:expat)))

(define-public play-to-kodi/chromium
  (make-chromium-extension play-to-kodi))

(define uassets
  (let ((commit "0b1bde3958d98ba4d78b0a28cda1239c2fc1d918"))
    (origin
      (method git-fetch)
      (uri (git-reference
            (url "https://github.com/uBlockOrigin/uAssets")
            (commit commit)))
      (file-name (git-file-name "uAssets" (string-take commit 9)))
      (sha256
       (base32
        "0f5j3dcglra7y4ad3gryq6mgavc7pcn4rkkc5wf1mnnk00bnn4gk")))))

(define ublock-origin
  (package
    (name "ublock-origin")
    (version "1.32.0")
    (home-page "https://github.com/gorhill/uBlock")
    (source (origin
              (method git-fetch)
              (uri (git-reference (url home-page) (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "14k04lww9nlx1f1pjkz542fd2la255c6yd72d0ri86k0m9i3vk7z"))))
    (build-system gnu-build-system)
    (outputs '("xpi" "firefox" "chromium"))
    (arguments
     '(#:tests? #f                      ;no tests
       #:allowed-references ()
       #:phases
       (modify-phases (map (lambda (phase)
                             (assq phase %standard-phases))
                           '(set-paths unpack patch-source-shebangs))
         (add-after 'unpack 'link-uassets
           (lambda* (#:key native-inputs inputs #:allow-other-keys)
             (symlink (string-append (assoc-ref (or native-inputs inputs)
                                                "uassets"))
                      "../uAssets")
             #t))
         (add-after 'unpack 'make-files-writable
           (lambda _
             ;; The build system copies some files and later tries
             ;; modifying them.
             (for-each make-file-writable (find-files "."))
             #t))
         (add-after 'patch-source-shebangs 'build-xpi
           (lambda _
             (invoke "./tools/make-firefox.sh" "all")))
         (add-after 'build-xpi 'build-chromium
           (lambda _
             (invoke "./tools/make-chromium.sh")))
         (add-after 'build-chromium 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((firefox (assoc-ref outputs "firefox"))
                   (xpi (assoc-ref outputs "xpi"))
                   (chromium (assoc-ref outputs "chromium")))
               (install-file "dist/build/uBlock0.firefox.xpi"
                             (string-append xpi "/lib/mozilla/extensions"))
               (copy-recursively "dist/build/uBlock0.firefox" firefox)
               (copy-recursively "dist/build/uBlock0.chromium" chromium)
               #t))))))
    (native-inputs
     `(("python" ,python-wrapper)
       ("uassets" ,uassets)
       ("zip" ,zip)))
    (synopsis "Block unwanted content from web sites")
    (description
     "uBlock Origin is a @dfn{wide spectrum blocker} for IceCat and
ungoogled-chromium.")
    (license license:gpl3+)))

(define-public ublock-origin/chromium
  (make-chromium-extension ublock-origin "chromium"))
