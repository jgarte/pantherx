;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Claes Wallin <claes.wallin@greatsinodevelopment.com>
;;; Copyright © 2016 Eric Le Bihan <eric.le.bihan.dev@free.fr>
;;; Copyright © 2017 Z. Ren <zren@dlut.edu.cn>
;;; Copyright © 2018, 2019, 2020 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2020 Oleg Pykhalov <go.wigust@gmail.com>
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

(define-module (gnu packages skarnet)
  #:use-module (gnu packages)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu))

(define-public skalibs
  (package
    (name "skalibs")
    (version "2.9.3.0")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "https://skarnet.org/software/skalibs/skalibs-"
                          version ".tar.gz"))
      (sha256
       (base32 "0i1vg3bh0w3bpj7cv0kzs6q9v2dd8wa2by8h8j39fh1qkl20f6ph"))))
    (build-system gnu-build-system)
    (arguments
     '(#:tests? #f                      ; no tests exist
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'reproducible
                    (lambda _
                      ;; Sort source files deterministically so that the *.a
                      ;; and *.so files are reproducible.
                      (substitute* "Makefile"
                        (("\\$\\(wildcard src/lib\\*/\\*.c\\)")
                         "$(sort $(wildcard src/lib*/*.c))"))
                      #t)))))
    (home-page "https://skarnet.org/software/skalibs/")
    (synopsis "Platform abstraction libraries for skarnet.org software")
    (description
     "This package provides lightweight C libraries isolating the developer
from portability issues, providing a unified systems API on all platforms,
including primitive data types, cryptography, and POSIX concepts like sockets
and file system operations.  It is used by all skarnet.org software.")
    (license isc)))

(define-public execline
  (package
    (name "execline")
    (version "2.6.1.1")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "https://skarnet.org/software/execline/execline-"
                          version ".tar.gz"))
      (sha256
       (base32 "0mmsnai3bkyhng0cxdz6bf7d6b7kbsxs4p39m63215lz6kq0hhrr"))))
    (build-system gnu-build-system)
    (inputs `(("skalibs" ,skalibs)))
    (arguments
     '(#:configure-flags (list
                          (string-append "--with-lib="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs")
                          (string-append "--with-sysdeps="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs/sysdeps"))
       #:phases (modify-phases %standard-phases
                  (add-after
                   'install 'post-install
                   (lambda* (#:key inputs outputs #:allow-other-keys)
                    (let* ((out (assoc-ref outputs "out"))
                           (bin (string-append out "/bin")))
                      (wrap-program (string-append bin "/execlineb")
                        `("PATH" ":" prefix (,bin)))))))
       #:tests? #f))                    ; no tests exist
    (home-page "https://skarnet.org/software/execline/")
    (license isc)
    (synopsis "Non-interactive shell-like language with minimal overhead")
    (description
     "Execline is a (non-interactive) scripting language, separated into a
parser (execlineb) and a set of commands meant to execute one another in a
chain-execution fashion, storing the whole script in the argument array.
It features conditional loops, getopt-style option handling, file name
globbing, redirection and other shell concepts, expressed as discrete commands
rather than in special syntax, minimizing runtime footprint and
complexity.")))

(define-public s6
  (package
   (name "s6")
   (version "2.9.2.0")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "https://skarnet.org/software/s6/s6-"
                         version ".tar.gz"))
     (sha256
      (base32 "1pfxx50shncg2s47ic4kp02jh1cxfjq75j3mnxjagyzzz0mbfg9n"))))
   (build-system gnu-build-system)
   (inputs `(("skalibs" ,skalibs)
             ("execline" ,execline)))
   (arguments
    `(#:configure-flags (list
                        (string-append "--with-lib="
                                       (assoc-ref %build-inputs "skalibs")
                                       "/lib/skalibs")
                        (string-append "--with-lib="
                                       (assoc-ref %build-inputs "execline")
                                       "/lib/execline")
                        (string-append "--with-sysdeps="
                                       (assoc-ref %build-inputs "skalibs")
                                       "/lib/skalibs/sysdeps"))
      #:tests? #f                       ; no tests exist
      #:phases
      (modify-phases %standard-phases
        (add-after 'install 'install-doc
          (lambda* (#:key outputs #:allow-other-keys)
            (let* ((out (assoc-ref outputs "out"))
                   (doc (string-append out "/share/doc/s6-" ,version)))
              (copy-recursively "doc" doc)
              #t))))))
   (home-page "https://skarnet.org/software/s6")
   (license isc)
   (synopsis "Small suite of programs for process supervision")
   (description
    "s6 is a small suite of programs for UNIX, designed to allow process
supervision (a.k.a. service supervision), in the line of daemontools and
runit, as well as various operations on processes and daemons.  It is meant to
be a toolbox for low-level process and service administration, providing
different sets of independent tools that can be used within or without the
framework, and that can be assembled together to achieve powerful
functionality with a very small amount of code.")))

(define-public s6-dns
  (package
   (name "s6-dns")
   (version "2.3.3.0")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "https://skarnet.org/software/s6-dns/s6-dns-"
                         version ".tar.gz"))
     (sha256
      (base32 "05l74ciflaahlgjpvy1g0slydwqclxgybxrkpvdddd2yzwc5kira"))))
    (build-system gnu-build-system)
    (inputs `(("skalibs" ,skalibs)))
    (arguments
     '(#:configure-flags (list
                          (string-append "--with-lib="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs")
                          (string-append "--with-sysdeps="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs/sysdeps"))
       #:tests? #f))                    ; no tests exist
    (home-page "https://skarnet.org/software/s6-dns")
    (license isc)
    (synopsis "Suite of DNS client programs")
    (description
     "s6-dns is a suite of DNS client programs and libraries for Unix systems,
as an alternative to the BIND, djbdns or other DNS clients.")))

(define-public s6-networking
  (package
   (name "s6-networking")
   (version "2.3.2.0")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "https://skarnet.org/software/s6-networking/s6-networking-"
                         version ".tar.gz"))
     (sha256
      (base32 "04kxj579pm4n5ifc3gfmrqj74vqqfqc82d69avzkn3yrc226mqxv"))))
    (build-system gnu-build-system)
    (inputs `(("skalibs" ,skalibs)
              ("execline" ,execline)
              ("s6" ,s6)
              ("s6-dns" ,s6-dns)))
    (arguments
     '(#:configure-flags (list
                          (string-append "--with-lib="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs")
                          (string-append "--with-lib="
                                         (assoc-ref %build-inputs "execline")
                                         "/lib/execline")
                          (string-append "--with-lib="
                                         (assoc-ref %build-inputs "s6")
                                         "/lib/s6")
                          (string-append "--with-lib="
                                         (assoc-ref %build-inputs "s6-dns")
                                         "/lib/s6-dns")
                          (string-append "--with-sysdeps="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs/sysdeps"))
       #:tests? #f))                    ; no tests exist
    (home-page "https://skarnet.org/software/s6-networking")
    (license isc)
    (synopsis "Suite of network utilities for Unix systems")
    (description
     "s6-networking is a suite of small networking utilities for Unix systems.
It includes command-line client and server management, TCP access control,
privilege escalation across UNIX domain sockets, IDENT protocol management and
clock synchronization.")))

(define-public s6-rc
  (package
   (name "s6-rc")
   (version "0.5.1.4")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "https://skarnet.org/software/s6-rc/s6-rc-"
                         version ".tar.gz"))
     (sha256
      (base32 "07q0ixpwsmj1v08l6vd7qywdg33zzn8vhm21kvp179bapdzs8sdg"))))
    (build-system gnu-build-system)
    (inputs `(("skalibs" ,skalibs)
              ("execline" ,execline)
              ("s6" ,s6)))
    (arguments
     '(#:configure-flags (list
                          (string-append "--with-lib="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs")
                          (string-append "--with-lib="
                                         (assoc-ref %build-inputs "execline")
                                         "/lib/execline")
                          (string-append "--with-lib="
                                         (assoc-ref %build-inputs "s6")
                                         "/lib/s6")
                          (string-append "--with-sysdeps="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs/sysdeps"))
       #:tests? #f))                    ; no tests exist
    (home-page "https://skarnet.org/software/s6-rc")
    (license isc)
    (synopsis "Service manager for s6-based systems")
    (description
     "s6-rc is a service manager for s6-based systems, i.e. a suite of
programs that can start and stop services, both long-running daemons and
one-time initialization scripts, in the proper order according to a dependency
tree.  It ensures that long-running daemons are supervised by the s6
infrastructure, and that one-time scripts are also run in a controlled
environment.")))

(define-public s6-portable-utils
  (package
   (name "s6-portable-utils")
   (version "2.2.3.0")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://skarnet.org/software/s6-portable-utils/s6-portable-utils-"
           version ".tar.gz"))
     (sha256
      (base32 "063zwifigg2b3wsixdcz4h9yvr6fkqssvx0iyfsprjfmm1yapfi9"))))
    (build-system gnu-build-system)
    (inputs `(("skalibs" ,skalibs)))
    (arguments
     '(#:configure-flags (list
                          (string-append "--with-lib="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs")
                          (string-append "--with-sysdeps="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs/sysdeps"))
       #:tests? #f))                    ; no tests exist
    (home-page "https://skarnet.org/software/s6-portable-utils")
    (license isc)
    (synopsis "Tiny command-line Unix utilities")
    (description
     "s6-portable-utils is a set of tiny general Unix utilities, often
performing well-known tasks such as @command{cut} and @command{grep}, but
optimized for simplicity and small size.  They were designed for embedded
systems and other constrained environments, but they work everywhere.")))

(define-public s6-linux-init
  (package
   (name "s6-linux-init")
   (version "1.0.5.1")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://skarnet.org/software/s6-linux-init/s6-linux-init-"
           version ".tar.gz"))
     (sha256
      (base32 "1gkbjldf4f7i3vmv251f9hw7ma09nh8zkwjmqi2gplpkf7z3i34p"))))
    (build-system gnu-build-system)
    (inputs
     `(("execline" ,execline)
       ("s6" ,s6)
       ("skalibs" ,skalibs)))
    (arguments
     '(#:configure-flags
       (list
        "--disable-static"
        (string-append "--with-lib="
                       (assoc-ref %build-inputs "skalibs")
                       "/lib/skalibs")
        (string-append "--with-lib="
                       (assoc-ref %build-inputs "execline")
                       "/lib/execline")
        (string-append "--with-lib="
                       (assoc-ref %build-inputs "s6")
                       "/lib/s6")
        (string-append "--with-sysdeps="
                       (assoc-ref %build-inputs "skalibs")
                       "/lib/skalibs/sysdeps"))
       #:tests? #f))                    ; no tests exist
    (home-page "https://skarnet.org/software/s6-linux-init")
    (license isc)
    (synopsis "Minimalistic tools to create an s6-based init system on Linux")
    (description
     "s6-linux-init is a set of minimalistic tools to create a s6-based init
system, including an @command{/sbin/init} binary, on a Linux kernel.

It is meant to automate creation of scripts revolving around the use of other
skarnet.org tools, especially s6, in order to provide a complete booting
environment with integrated supervision and logging without having to hand-craft
all the details.")))

(define-public s6-linux-utils
  (package
   (name "s6-linux-utils")
   (version "2.5.1.3")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://skarnet.org/software/s6-linux-utils/s6-linux-utils-"
           version ".tar.gz"))
     (sha256
      (base32 "0wbv02zxaami88xbj2zg63kspz05bbplswg0c6ncb5g9khf52wa4"))))
    (build-system gnu-build-system)
    (inputs `(("skalibs" ,skalibs)))
    (arguments
     '(#:configure-flags (list
                          (string-append "--with-lib="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs")
                          (string-append "--with-sysdeps="
                                         (assoc-ref %build-inputs "skalibs")
                                         "/lib/skalibs/sysdeps"))
       #:tests? #f))                    ; no tests exist
    (home-page "https://skarnet.org/software/s6-linux-utils")
    (license isc)
    (synopsis "Set of minimalistic Linux-specific system utilities")
    (description
     "s6-linux-utils is a set of minimalistic Linux-specific system utilities,
such as @command{mount}, @command{umount}, and @command{chroot} commands,
Linux uevent listeners, a @command{devd} device hotplug daemon, and more.")))
