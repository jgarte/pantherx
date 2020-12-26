;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2014 John Darrington <jmd@gnu.org>
;;; Copyright © 2015 Taylan Ulrich Bayırlı/Kammer <taylanbayirli@gmail.com>
;;; Copyright © 2015 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2016 Federico Beffa <beffa@fbengineering.ch>
;;; Copyright © 2016, 2017 Nikita <nikita@n0.is>
;;; Copyright © 2016, 2017 Andy Patterson <ajpatter@uwaterloo.ca>
;;; Copyright © 2017, 2019, 2020 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2017, 2018, 2019, 2020 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2017, 2019 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Benjamin Slade <slade@jnanam.net>
;;; Copyright © 2018 Alex Vong <alexvong1995@gmail.com>
;;; Copyright © 2018, 2020 Pierre Neidhardt <mail@ambrevar.xyz>
;;; Copyright © 2018, 2019 Pierre Langlois <pierre.langlois@gmx.com>
;;; Copyright © 2019, 2020 Katherine Cox-Buday <cox.katherine.e@gmail.com>
;;; Copyright © 2019 Jesse Gildersleve <jessejohngildersleve@protonmail.com>
;;; Copyright © 2019, 2020 Guillaume Le Vaillant <glv@posteo.net>
;;; Copyright © 2019 Brett Gilio <brettg@gnu.org>
;;; Copyright © 2020 Konrad Hinsen <konrad.hinsen@fastmail.net>
;;; Copyright © 2020 Dimakis Dimakakos <me@bendersteed.tech>
;;; Copyright © 2020 Oleg Pykhalov <go.wigust@gmail.com>
;;; Copyright © 2020 Adam Kandur <rndd@tuta.io>
;;; Copyright © 2020 Sharlatan Hellseher <sharlatanus@gmail.com>
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

;;; This file only contains Common Lisp libraries.
;;; Common Lisp compilers and tooling go to lisp.scm.
;;; Common Lisp applications should go to the most appropriate file,
;;; e.g. StumpWM is in wm.scm.

(define-module (gnu packages lisp-xyz)
  #:use-module (gnu packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix hg-download)
  #:use-module (guix utils)
  #:use-module (guix build-system asdf)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages c)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages enchant)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages lisp)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages tcl)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages web)
  #:use-module (gnu packages webkit)
  #:use-module (gnu packages xdisorg)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-19))

(define-public sbcl-alexandria
  (package
   (name "sbcl-alexandria")
   (version "1.2")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://gitlab.common-lisp.net/alexandria/alexandria.git")
           (commit (string-append "v" version))))
     (sha256
      (base32
       "0bcqs0z9xlqgjz43qzgq9i07vdlnjllpm1wwa37wpkg0w975r712"))
     (file-name (git-file-name name version))))
   (build-system asdf-build-system/sbcl)
   (native-inputs
    `(("rt" ,sbcl-rt)))
   (synopsis "Collection of portable utilities for Common Lisp")
   (description
    "Alexandria is a collection of portable utilities.  It does not contain
conceptual extensions to Common Lisp.  It is conservative in scope, and
portable between implementations.")
   (home-page "https://common-lisp.net/project/alexandria/")
   (license license:public-domain)))

(define-public cl-alexandria
  (sbcl-package->cl-source-package sbcl-alexandria))

(define-public ecl-alexandria
  (sbcl-package->ecl-package sbcl-alexandria))

(define-public sbcl-asdf-finalizers
  (let ((commit "7f537f6c598b662ae987c6acc268dd27c25977e0")
        (revision "1"))
    (package
      (name "sbcl-asdf-finalizers")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://gitlab.common-lisp.net/asdf/asdf-finalizers")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1w56c9yjjydjshsgqxz57qlp2v3r4ilbisnsgiqphvxnhvd41y0v"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fare-utils" ,sbcl-fare-utils)
         ("hu.dwim.stefil" ,sbcl-hu.dwim.stefil)))
      (arguments
       `(#:asd-files '("asdf-finalizers.asd"
                       "list-of.asd"
                       "asdf-finalizers-test.asd")
         #:asd-systems '("asdf-finalizers"
                         "list-of")))
      (home-page "https://gitlab.common-lisp.net/asdf/asdf-finalizers")
      (synopsis "Enforced calling of finalizers for Lisp code")
      (description "This library allows you to implement and enforce proper
finalization of compile-time constructs while building Lisp source files.

It produces two systems: asdf-finalizers and list-of.")
      (license license:expat))))

(define-public ecl-asdf-finalizers
  (sbcl-package->ecl-package sbcl-asdf-finalizers))

(define-public cl-asdf-finalizers
  (sbcl-package->cl-source-package sbcl-asdf-finalizers))

(define-public sbcl-net.didierverna.asdf-flv
  (package
    (name "sbcl-net.didierverna.asdf-flv")
    (version "2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/didierverna/asdf-flv")
             (commit (string-append "version-" version))))
       (file-name (git-file-name "asdf-flv" version))
       (sha256
        (base32 "1fi2y4baxan103jbg4idjddzihy03kwnj2mzbwrknw4d4x7xlgwj"))))
    (build-system asdf-build-system/sbcl)
    (synopsis "Common Lisp ASDF extension to provide support for file-local variables")
    (description "ASDF-FLV provides support for file-local variables through
ASDF.  A file-local variable behaves like @code{*PACKAGE*} and
@code{*READTABLE*} with respect to @code{LOAD} and @code{COMPILE-FILE}: a new
dynamic binding is created before processing the file, so that any
modification to the variable becomes essentially file-local.

In order to make one or several variables file-local, use the macros
@code{SET-FILE-LOCAL-VARIABLE(S)}.")
    (home-page "https://www.lrde.epita.fr/~didier/software/lisp/misc.php#asdf-flv")
    (license (license:non-copyleft
              "https://www.gnu.org/prep/maintain/html_node/License-Notices-for-Other-Files.html"
              "GNU All-Permissive License"))))

(define-public cl-net.didierverna.asdf-flv
  (sbcl-package->cl-source-package sbcl-net.didierverna.asdf-flv))

(define-public ecl-net.didierverna.asdf-flv
  (sbcl-package->ecl-package sbcl-net.didierverna.asdf-flv))

(define-public sbcl-command-line-arguments
  (let ((commit "fbac862fb01c0e368141204f3f639920462c23fe")
        (revision "1"))
    (package
      (name "sbcl-command-line-arguments")
      (version (git-version "2.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fare/command-line-arguments")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "054m1ikndzqf72mb9ajaa64136cwr3bgag4yfbi1574a9vq75mjq"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/fare/command-line-arguments")
      (synopsis "Trivial command-line argument parsing library for Common Lisp")
      (description "This is a library to abstract away the parsing of
Unix-style command-line arguments.  Use it in conjunction with asdf:program-op
or cl-launch for portable processing of command-line arguments.")
      (license license:expat))))

(define-public ecl-command-line-arguments
  (sbcl-package->ecl-package sbcl-command-line-arguments))

(define-public cl-command-line-arguments
  (sbcl-package->cl-source-package sbcl-command-line-arguments))

(define-public sbcl-fiveam
  (package
    (name "sbcl-fiveam")
    (version "1.4.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/sionescu/fiveam")
             (commit (string-append "v" version))))
       (file-name (git-file-name "fiveam" version))
       (sha256
        (base32 "1q3d38pwafnwnw42clq0f8g5xw7pbzr287jl9jsqmb1vb0n1vrli"))))
    (inputs
     `(("alexandria" ,sbcl-alexandria)
       ("net.didierverna.asdf-flv" ,sbcl-net.didierverna.asdf-flv)
       ("trivial-backtrace" ,sbcl-trivial-backtrace)))
    (build-system asdf-build-system/sbcl)
    (synopsis "Common Lisp testing framework")
    (description "FiveAM is a simple (as far as writing and running tests
goes) regression testing framework.  It has been designed with Common Lisp's
interactive development model in mind.")
    (home-page "https://common-lisp.net/project/fiveam/")
    (license license:bsd-3)))

(define-public cl-fiveam
  (sbcl-package->cl-source-package sbcl-fiveam))

(define-public ecl-fiveam
  (sbcl-package->ecl-package sbcl-fiveam))

(define-public sbcl-bordeaux-threads
  (package
    (name "sbcl-bordeaux-threads")
    (version "0.8.8")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/sionescu/bordeaux-threads")
                    (commit (string-append "v" version))))
              (sha256
               (base32 "19i443fz3488v1pbbr9x24y8h8vlyhny9vj6c9jk5prm702awrp6"))
              (file-name
               (git-file-name "bordeaux-threads" version))))
    (inputs `(("alexandria" ,sbcl-alexandria)))
    (native-inputs `(("fiveam" ,sbcl-fiveam)))
    (build-system asdf-build-system/sbcl)
    (synopsis "Portable shared-state concurrency library for Common Lisp")
    (description "BORDEAUX-THREADS is a proposed standard for a minimal
MP/Threading interface.  It is similar to the CLIM-SYS threading and lock
support.")
    (home-page "https://common-lisp.net/project/bordeaux-threads/")
    (license license:x11)))

(define-public cl-bordeaux-threads
  (sbcl-package->cl-source-package sbcl-bordeaux-threads))

(define-public ecl-bordeaux-threads
  (sbcl-package->ecl-package sbcl-bordeaux-threads))

(define-public sbcl-trivial-gray-streams
  (let ((revision "1")
        (commit "ebd59b1afed03b9dc8544320f8f432fdf92ab010"))
    (package
      (name "sbcl-trivial-gray-streams")
      (version (string-append "0.0.0-" revision "." (string-take commit 7)))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/trivial-gray-streams/trivial-gray-streams")
           (commit commit)))
         (sha256
          (base32 "0b1pxlccmnagk9cbh4cy8s5k66g3x0gwib5shjwr24xvrji6lp94"))
         (file-name
          (string-append "trivial-gray-streams-" version "-checkout"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Compatibility layer for Gray streams implementations")
      (description "Gray streams is an interface proposed for inclusion with
ANSI CL by David N. Gray.  The proposal did not make it into ANSI CL, but most
popular CL implementations implement it.  This package provides an extremely
thin compatibility layer for gray streams.")
      (home-page "https://www.cliki.net/trivial-gray-streams")
      (license license:x11))))

(define-public cl-trivial-gray-streams
  (sbcl-package->cl-source-package sbcl-trivial-gray-streams))

(define-public ecl-trivial-gray-streams
  (sbcl-package->ecl-package sbcl-trivial-gray-streams))

(define-public sbcl-fiasco
  (let ((commit "d62f7558b21addc89f87e306f65d7f760632655f")
        (revision "1"))
    (package
      (name "sbcl-fiasco")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/joaotavora/fiasco")
               (commit commit)))
         (file-name (git-file-name "fiasco" version))
         (sha256
          (base32
           "1zwxs3d6iswayavcmb49z2892xhym7n556d8dnmvalc32pm9bkjh"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("trivial-gray-streams" ,sbcl-trivial-gray-streams)))
      (synopsis "Simple and powerful test framework for Common Lisp")
      (description "A Common Lisp test framework that treasures your failures,
logical continuation of Stefil.  It focuses on interactive debugging.")
      (home-page "https://github.com/joaotavora/fiasco")
      ;; LICENCE specifies this is public-domain unless the legislation
      ;; doesn't allow or recognize it.  In that case it falls back to a
      ;; permissive licence.
      (license (list license:public-domain
                     (license:x11-style "file://LICENCE"))))))

(define-public cl-fiasco
  (sbcl-package->cl-source-package sbcl-fiasco))

(define-public ecl-fiasco
  (sbcl-package->ecl-package sbcl-fiasco))

(define-public sbcl-flexi-streams
  (package
    (name "sbcl-flexi-streams")
    (version "1.0.18")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/edicl/flexi-streams")
             (commit (string-append "v" version))))
       (file-name (git-file-name "flexi-streams" version))
       (sha256
        (base32 "0bjv7fd2acknidc5dyi3h85pn10krxv5jyxs1xg8jya2rlfv7f1j"))))
    (build-system asdf-build-system/sbcl)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'make-git-checkout-writable
           (lambda _
             (for-each make-file-writable (find-files "."))
             #t)))))
    (inputs `(("trivial-gray-streams" ,sbcl-trivial-gray-streams)))
    (synopsis "Implementation of virtual bivalent streams for Common Lisp")
    (description "Flexi-streams is an implementation of \"virtual\" bivalent
streams that can be layered atop real binary or bivalent streams and that can
be used to read and write character data in various single- or multi-octet
encodings which can be changed on the fly.  It also supplies in-memory binary
streams which are similar to string streams.")
    (home-page "http://weitz.de/flexi-streams/")
    (license license:bsd-3)))

(define-public cl-flexi-streams
  (sbcl-package->cl-source-package sbcl-flexi-streams))

(define-public ecl-flexi-streams
  (sbcl-package->ecl-package sbcl-flexi-streams))

(define-public sbcl-cl-abnf
  ;; There are no releases
  (let ((commit "ba1fbb104dedbdaddb1ef93d2e4da711bd96cd70")
        (revision "1"))
    (package
     (name "sbcl-cl-abnf")
     (version (git-version "0.0.0" revision commit))
     (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/dimitri/cl-abnf")
              (commit commit)))
        (file-name (git-file-name "cl-abnf" version))
        (sha256
         (base32 "0f09nsndxa90acm71zd4qdnp40v705a4sqm04mnv9x76h6dlggmz"))))
     (build-system asdf-build-system/sbcl)
     (inputs
      `(("cl-ppcre" ,sbcl-cl-ppcre)
        ("esrap" ,sbcl-esrap)))
     (arguments
      `(#:asd-systems '("abnf")))
     (home-page "https://github.com/dimitri/cl-abnf")
     (synopsis "ABNF parser generator for Common Lisp")
     (description "This Common Lisp library implements a parser generator for
the ABNF grammar format as described in RFC2234.  The generated parser is a
regular expression scanner provided by the cl-ppcre lib, which means that we
can't parse recursive grammar definition.  One such definition is the ABNF
definition as given by the RFC.  Fortunately, as you have this lib, you most
probably don't need to generate another parser to handle that particular ABNF
grammar.")
     (license license:expat))))

(define-public cl-abnf
  (sbcl-package->cl-source-package sbcl-cl-abnf))

(define-public ecl-cl-abnf
  (sbcl-package->ecl-package sbcl-cl-abnf))

(define-public sbcl-cl-ppcre
  (package
    (name "sbcl-cl-ppcre")
    (version "2.1.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/edicl/cl-ppcre")
             (commit (string-append "v" version))))
       (file-name (git-file-name "cl-ppcre" version))
       (sha256
        (base32 "0dwvr29diqzcg5n6jvbk2rnd90i05l7n828hhw99khmqd0kz7xsi"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("flexi-streams" ,sbcl-flexi-streams)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'disable-ppcre-unicode
           ;; cl-ppcre and cl-ppcre-unicode are put in different packages
           ;; to work around the circular dependency between edicl/cl-ppcre
           ;; and edicl/cl-unicode.
           (lambda _
             (delete-file "cl-ppcre-unicode.asd")
             #t)))))
    (synopsis "Portable regular expression library for Common Lisp")
    (description "CL-PPCRE is a portable regular expression library for Common
Lisp, which is compatible with perl.  It is pretty fast, thread-safe, and
compatible with ANSI-compliant Common Lisp implementations.")
    (home-page "http://weitz.de/cl-ppcre/")
    (license license:bsd-2)))

(define-public cl-ppcre
  (sbcl-package->cl-source-package sbcl-cl-ppcre))

(define-public ecl-cl-ppcre
  (sbcl-package->ecl-package sbcl-cl-ppcre))

(define-public sbcl-cl-unicode
  (package
    (name "sbcl-cl-unicode")
    (version "0.1.6")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/edicl/cl-unicode")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0ykx2s9lqfl74p1px0ik3l2izd1fc9jd1b4ra68s5x34rvjy0hza"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("flexi-streams" ,sbcl-flexi-streams)))
    (inputs
     `(("cl-ppcre" ,sbcl-cl-ppcre)))
    (home-page "http://weitz.de/cl-unicode/")
    (synopsis "Portable Unicode library for Common Lisp")
    (description "CL-UNICODE is a portable Unicode library Common Lisp, which
is compatible with perl.  It is pretty fast, thread-safe, and compatible with
ANSI-compliant Common Lisp implementations.")
    (license license:bsd-2)))

(define-public ecl-cl-unicode
  (sbcl-package->ecl-package sbcl-cl-unicode))

(define-public cl-unicode
  (sbcl-package->cl-source-package sbcl-cl-unicode))

(define-public sbcl-cl-ppcre-unicode
  (package (inherit sbcl-cl-ppcre)
    (name "sbcl-cl-ppcre-unicode")
    (inputs
     `(("sbcl-cl-ppcre" ,sbcl-cl-ppcre)
       ("sbcl-cl-unicode" ,sbcl-cl-unicode)))
    (arguments
     `(#:tests? #f ; tests fail with "Component :CL-PPCRE-TEST not found"
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'disable-ppcre
           ;; cl-ppcre and cl-ppcre-unicode are put in different packages
           ;; to work around the circular dependency between edicl/cl-ppcre
           ;; and edicl/cl-unicode.
           (lambda _
             (delete-file "cl-ppcre.asd")
             #t)))))))

(define-public cl-ppcre-unicode
  (sbcl-package->cl-source-package sbcl-cl-ppcre-unicode))

(define-public ecl-cl-ppcre-unicode
  (sbcl-package->ecl-package sbcl-cl-ppcre-unicode))

(define-public sbcl-zpb-ttf
  (package
    (name "sbcl-zpb-ttf")
    (version "1.0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/xach/zpb-ttf")
             (commit (string-append "release-" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1wh66vjijzqlydnrihynpwp6796917xwrh0i9li93c17kyxa74ih"))))
    (build-system asdf-build-system/sbcl)
    (home-page "https://github.com/xach/zpb-ttf")
    (synopsis "TrueType font file access for Common Lisp")
    (description
     "ZPB-TTF is a TrueType font file parser that provides an interface for
reading typographic metrics, glyph outlines, and other information from the
file.")
    (license license:bsd-2)))

(define-public ecl-zpb-ttf
  (sbcl-package->ecl-package sbcl-zpb-ttf))

(define-public cl-zpb-ttf
  (sbcl-package->cl-source-package sbcl-zpb-ttf))

(define-public sbcl-cl-vectors
  (package
    (name "sbcl-cl-vectors")
    (version "0.1.5")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://projects.tuxee.net/cl-vectors/"
                           "files/cl-vectors-" version ".tar.gz"))
       (sha256
        (base32
         "04lhwi0kq8pkwhgd885pk80m1cp9sfvjjn5zj70s1dnckibhdmqh"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("zpb-ttf" ,sbcl-zpb-ttf)))
    (arguments
     '(#:asd-systems '("cl-vectors"
                       "cl-paths-ttf")))
    (home-page "http://projects.tuxee.net/cl-vectors/")
    (synopsis "Create, transform and render anti-aliased vectorial paths")
    (description
     "This is a pure Common Lisp library to create, transform and render
anti-aliased vectorial paths.")
    (license license:expat)))

(define-public ecl-cl-vectors
  (sbcl-package->ecl-package sbcl-cl-vectors))

(define-public cl-vectors
  (sbcl-package->cl-source-package sbcl-cl-vectors))

(define-public sbcl-spatial-trees
  ;; There have been no releases.
  (let ((commit "81fdad0a0bf109c80a53cc96eca2e093823400ba")
        (revision "1"))
    (package
      (name "sbcl-spatial-trees")
      (version (git-version "0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/rpav/spatial-trees")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "11rhc6h501dwcik2igkszz7b9n515cr99m5pjh4r2qfwgiri6ysa"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       '(#:tests? #f           ; spatial-trees.test requires spatial-trees.nns
         #:test-asd-file "spatial-trees.test.asd"))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (home-page "https://github.com/rpav/spatial-trees")
      (synopsis "Dynamic index data structures for spatially-extended data")
      (description
       "Spatial-trees is a set of dynamic index data structures for
spatially-extended data.")
      (license license:bsd-3))))

(define-public ecl-spatial-trees
  (sbcl-package->ecl-package sbcl-spatial-trees))

(define-public cl-spatial-trees
  (sbcl-package->cl-source-package sbcl-spatial-trees))

(define-public sbcl-flexichain
  ;; There are no releases.
  (let ((commit "13d2a6c505ed0abfcd4c4ec7d7145059b06855d6")
        (revision "1"))
    (package
      (name "sbcl-flexichain")
      (version "1.5.1")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/robert-strandh/Flexichain")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0pfyvhsfbjd2sjb30grfs52r51a428xglv7bwydvpg2lc117qimg"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/robert-strandh/Flexichain.git")
      (synopsis "Dynamically add elements to or remove them from sequences")
      (description
       "This package provides an implementation of the flexichain protocol,
allowing client code to dynamically add elements to, and delete elements from
a sequence (or chain) of such elements.")
      (license license:lgpl2.1+))))

(define-public ecl-flexichain
  (sbcl-package->ecl-package sbcl-flexichain))

(define-public cl-flexichain
  (sbcl-package->cl-source-package sbcl-flexichain))

(define-public sbcl-cl-pdf
  ;; There are no releases
  (let ((commit "752e337e6d6fc206f09d091a982e7f8e5c404e4e")
        (revision "1"))
    (package
      (name "sbcl-cl-pdf")
      (version (git-version "0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/mbattyani/cl-pdf")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1cg3k3m3r11ipb8j008y8ipynj97l3xjlpi2knqc9ndmx4r3kb1r"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("iterate" ,sbcl-iterate)
         ("zpb-ttf" ,sbcl-zpb-ttf)))
      (home-page "https://github.com/mbattyani/cl-pdf")
      (synopsis "Common Lisp library for generating PDF files")
      (description
       "CL-PDF is a cross-platform Common Lisp library for generating PDF
files.")
      (license license:bsd-2))))

(define-public ecl-cl-pdf
  (sbcl-package->ecl-package sbcl-cl-pdf))

(define-public cl-pdf
  (sbcl-package->cl-source-package sbcl-cl-pdf))

(define-public sbcl-clx
  (package
    (name "sbcl-clx")
    (version "0.7.5")
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "https://github.com/sharplispers/clx")
         (commit version)))
       (sha256
        (base32
         "1vi67z9hpj5rr4xcmfbfwzmlcc0ah7hzhrmfid6lqdkva238v2wf"))
       (file-name (string-append "clx-" version))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("fiasco" ,sbcl-fiasco)))
    (home-page "https://www.cliki.net/portable-clx")
    (synopsis "X11 client library for Common Lisp")
    (description "CLX is an X11 client library for Common Lisp.  The code was
originally taken from a CMUCL distribution, was modified somewhat in order to
make it compile and run under SBCL, then a selection of patches were added
from other CLXes around the net.")
    (license license:x11)))

(define-public cl-clx
  (sbcl-package->cl-source-package sbcl-clx))

(define-public ecl-clx
  (sbcl-package->ecl-package sbcl-clx))

(define-public sbcl-clx-truetype
  (let ((commit "c6e10a918d46632324d5863a8ed067a83fc26de8")
        (revision "1"))
    (package
      (name "sbcl-clx-truetype")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/l04m33/clx-truetype")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "079hyp92cjkdfn6bhkxsrwnibiqbz4y4af6nl31lzw6nm91j5j37"))
         (modules '((guix build utils)))
         (snippet
          '(begin
             (substitute* "package.lisp"
               ((":export") ":export\n   :+font-cache-filename+"))
             #t))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("clx" ,sbcl-clx)
         ("zpb-ttf" ,sbcl-zpb-ttf)
         ("cl-vectors" ,sbcl-cl-vectors)
         ("cl-fad" ,sbcl-cl-fad)
         ("cl-store" ,sbcl-cl-store)
         ("trivial-features" ,sbcl-trivial-features)))
      (home-page "https://github.com/l04m33/clx-truetype")
      (synopsis "Antialiased TrueType font rendering using CLX and XRender")
      (description "CLX-TrueType is pure common lisp solution for
antialiased TrueType font rendering using CLX and XRender extension.")
      (license license:expat))))

(define-public cl-clx-truetype
  (sbcl-package->cl-source-package sbcl-clx-truetype))

(define-public ecl-clx-truetype
  (sbcl-package->ecl-package sbcl-clx-truetype))

(define-public sbcl-slynk
  (let ((revision "4")
        ;; Update together with emacs-sly.
        (commit "68561f1b7b66fa0240766ece836bb04da31ea17d"))
    (package
      (name "sbcl-slynk")
      (version (git-version "1.0.0-beta" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/joaotavora/sly")
           (commit commit)))
         (sha256
          (base32 "1xwx537dhgclngi6b0faf320i8pnac9309wvmk6z2g6dm3v652ds"))
         (file-name (git-file-name "slynk" version))
         (modules '((guix build utils)
                    (ice-9 ftw)))
         (snippet
          '(begin
             ;; Move the contribs into the main source directory for easier
             ;; access
             (substitute* "slynk/slynk.asd"
               (("\\.\\./contrib")
                "contrib"))
             (rename-file "contrib" "slynk/contrib")
             ;; Move slynk's contents into the base directory for easier
             ;; access
             (for-each (lambda (file)
                         (unless (string-prefix? "." file)
                           (rename-file (string-append "slynk/" file)
                                        (string-append "./" (basename file)))))
                       (scandir "slynk"))
             #t))))
      (build-system asdf-build-system/sbcl)
      (outputs '("out" "image"))
      (arguments
       `(#:tests? #f ; No test suite
         #:asd-systems '("slynk"
                         "slynk/arglists"
                         "slynk/fancy-inspector"
                         "slynk/package-fu"
                         "slynk/mrepl"
                         "slynk/trace-dialog"
                         "slynk/profiler"
                         "slynk/stickers"
                         "slynk/indentation"
                         "slynk/retro")
         #:phases
         (modify-phases %standard-phases
           (add-after 'create-asdf-configuration 'build-image
             (lambda* (#:key outputs #:allow-other-keys)
               (build-image (string-append
                             (assoc-ref %outputs "image")
                             "/bin/slynk")
                            %outputs
                            #:dependencies '("slynk"
                                             "slynk/arglists"
                                             "slynk/fancy-inspector"
                                             "slynk/package-fu"
                                             "slynk/mrepl"
                                             "slynk/trace-dialog"
                                             "slynk/profiler"
                                             "slynk/stickers"
                                             "slynk/indentation"
                                             "slynk/retro"))
               #t)))))
      (synopsis "Common Lisp IDE for Emacs")
      (description "SLY is a fork of SLIME, an IDE backend for Common Lisp.
It also features a completely redesigned REPL based on Emacs's own
full-featured @code{comint-mode}, live code annotations, and a consistent interactive
button interface.  Everything can be copied to the REPL.  One can create
multiple inspectors with independent history.")
      (home-page "https://github.com/joaotavora/sly")
      (license license:public-domain)
      (properties `((cl-source-variant . ,(delay cl-slynk)))))))

(define-public cl-slynk
  (sbcl-package->cl-source-package sbcl-slynk))

(define-public ecl-slynk
  (let ((pkg (sbcl-package->ecl-package sbcl-slynk)))
    (package
      (inherit pkg)
      (outputs '("out"))
      (arguments
       (substitute-keyword-arguments (package-arguments pkg)
         ((#:phases phases)
          `(modify-phases ,phases
             (delete 'build-image))))))))

(define-public sbcl-parse-js
  (let ((commit "fbadc6029bec7039602abfc06c73bb52970998f6")
        (revision "1"))
    (package
      (name "sbcl-parse-js")
      (version (string-append "0.0.0-" revision "." (string-take commit 9)))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "http://marijn.haverbeke.nl/git/parse-js")
               (commit commit)))
         (file-name (string-append name "-" commit "-checkout"))
         (sha256
          (base32
           "1wddrnr5kiya5s3gp4cdq6crbfy9fqcz7fr44p81502sj3bvdv39"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://marijnhaverbeke.nl/parse-js/")
      (synopsis "Parse JavaScript")
      (description "Parse-js is a Common Lisp package for parsing
JavaScript (ECMAScript 3).  It has basic support for ECMAScript 5.")
      (license license:zlib))))

(define-public cl-parse-js
  (sbcl-package->cl-source-package sbcl-parse-js))

(define-public ecl-parse-js
  (sbcl-package->ecl-package sbcl-parse-js))

(define-public sbcl-parse-number
  (package
    (name "sbcl-parse-number")
    (version "1.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/sharplispers/parse-number/")
              (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0sk06ib1bhqv9y39vwnnw44vmbc4b0kvqm37xxmkxd4dwchq82d7"))))
    (build-system asdf-build-system/sbcl)
    (home-page "https://www.cliki.net/PARSE-NUMBER")
    (synopsis "Parse numbers")
    (description "@code{parse-number} is a library of functions for parsing
strings into one of the standard Common Lisp number types without using the
reader.  @code{parse-number} accepts an arbitrary string and attempts to parse
the string into one of the standard Common Lisp number types, if possible, or
else @code{parse-number} signals an error of type @code{invalid-number}.")
    (license license:bsd-3)))

(define-public cl-parse-number
  (sbcl-package->cl-source-package sbcl-parse-number))

(define-public ecl-parse-number
  (sbcl-package->ecl-package sbcl-parse-number))

(define-public sbcl-iterate
  (package
    (name "sbcl-iterate")
    (version "1.5")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://common-lisp.net/project/iterate/releases/"
                           "iterate-" version ".tar.gz"))
       (sha256
        (base32
         "1lqsbhrkfl0yif46aymvb7l3nb9wdcmj4jyw485blj32jb4famzn"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("rt" ,sbcl-rt)))
    (home-page "https://common-lisp.net/project/iterate/")
    (synopsis "Iteration construct for Common Lisp")
    (description "@code{iterate} is an iteration construct for Common Lisp.
It is similar to the @code{CL:LOOP} macro, with these distinguishing marks:

@itemize
@item it is extensible,
@item it helps editors like Emacs indent iterate forms by having a more
  lisp-like syntax, and
@item it isn't part of the ANSI standard for Common Lisp.
@end itemize\n")
    (license license:expat)))

(define-public cl-iterate
  (sbcl-package->cl-source-package sbcl-iterate))

(define-public ecl-iterate
  (sbcl-package->ecl-package sbcl-iterate))

(define-public sbcl-cl-uglify-js
  ;; There have been many bug fixes since the 2010 release.
  (let ((commit "429c5e1d844e2f96b44db8fccc92d6e8e28afdd5")
        (revision "1"))
    (package
      (name "sbcl-cl-uglify-js")
      (version (string-append "0.1-" revision "." (string-take commit 9)))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/mishoo/cl-uglify-js")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0k39y3c93jgxpr7gwz7w0d8yknn1fdnxrjhd03057lvk5w8js27a"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("sbcl-parse-js" ,sbcl-parse-js)
         ("sbcl-cl-ppcre" ,sbcl-cl-ppcre)
         ("sbcl-cl-ppcre-unicode" ,sbcl-cl-ppcre-unicode)
         ("sbcl-parse-number" ,sbcl-parse-number)
         ("sbcl-iterate" ,sbcl-iterate)))
      (home-page "https://github.com/mishoo/cl-uglify-js")
      (synopsis "JavaScript compressor library for Common Lisp")
      (description "This is a Common Lisp version of UglifyJS, a JavaScript
compressor.  It works on data produced by @code{parse-js} to generate a
@dfn{minified} version of the code.  Currently it can:

@itemize
@item reduce variable names (usually to single letters)
@item join consecutive @code{var} statements
@item resolve simple binary expressions
@item group most consecutive statements using the @code{sequence} operator (comma)
@item remove unnecessary blocks
@item convert @code{IF} expressions in various ways that result in smaller code
@item remove some unreachable code
@end itemize\n")
      (license license:zlib))))

(define-public cl-uglify-js
  (sbcl-package->cl-source-package sbcl-cl-uglify-js))

(define-public ecl-cl-uglify-js
  (sbcl-package->ecl-package sbcl-cl-uglify-js))

(define-public uglify-js
  (package
    (inherit sbcl-cl-uglify-js)
    (name "uglify-js")
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (let* ((bin    (string-append (assoc-ref %outputs "out") "/bin/"))
              (script (string-append bin "uglify-js")))
         (use-modules (guix build utils))
         (mkdir-p bin)
         (with-output-to-file script
           (lambda _
             (format #t "#!~a/bin/sbcl --script

 (require :asdf)
 (asdf:initialize-source-registry
  #p\"~a/etc/common-lisp/source-registry.conf.d/\")
 (asdf:initialize-output-translations
  #p\"~a/etc/common-lisp/asdf-output-translations.conf.d/\")"
                     (assoc-ref %build-inputs "sbcl")
                     (assoc-ref %build-inputs "sbcl-cl-uglify-js")
                     (assoc-ref %build-inputs "sbcl-cl-uglify-js"))
             ;; FIXME: cannot use progn here because otherwise it fails to
             ;; find cl-uglify-js.
             (for-each
              write
              '(;; Quiet, please!
                (let ((*standard-output* (make-broadcast-stream))
                      (*error-output* (make-broadcast-stream)))
                  (asdf:load-system :cl-uglify-js))
                (let ((file (cadr *posix-argv*)))
                  (if file
                      (format t "~a"
                              (cl-uglify-js:ast-gen-code
                               (cl-uglify-js:ast-mangle
                                (cl-uglify-js:ast-squeeze
                                 (with-open-file (in file)
                                                 (parse-js:parse-js in))))
                               :beautify nil))
                      (progn
                       (format *error-output*
                               "Please provide a JavaScript file.~%")
                       (sb-ext:exit :code 1))))))))
         (chmod script #o755)
         #t)))
    (inputs
     `(("sbcl" ,sbcl)
       ("sbcl-cl-uglify-js" ,sbcl-cl-uglify-js)))
    (synopsis "JavaScript compressor")))

(define-public sbcl-cl-strings
  (let ((revision "1")
        (commit "c5c5cbafbf3e6181d03c354d66e41a4f063f00ae"))
    (package
      (name "sbcl-cl-strings")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/diogoalexandrefranco/cl-strings")
               (commit commit)))
         (sha256
          (base32
           "00754mfaqallj480lwd346nkfb6ra8pa8xcxcylf4baqn604zlmv"))
         (file-name (string-append "cl-strings-" version "-checkout"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Portable, dependency-free set of utilities to manipulate strings in Common Lisp")
      (description
       "@command{cl-strings} is a small, portable, dependency-free set of
utilities that make it even easier to manipulate text in Common Lisp.  It has
100% test coverage and works at least on sbcl, ecl, ccl, abcl and clisp.")
      (home-page "https://github.com/diogoalexandrefranco/cl-strings")
      (license license:expat))))

(define-public cl-strings
  (sbcl-package->cl-source-package sbcl-cl-strings))

(define-public ecl-cl-strings
  (sbcl-package->ecl-package sbcl-cl-strings))

(define-public sbcl-trivial-features
  ;; No release since 2014.
  (let ((commit "870d03de0ed44067963350936856e17ee725153e"))
    (package
      (name "sbcl-trivial-features")
      (version (git-version "0.8" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/trivial-features/trivial-features")
               (commit commit)))
         (file-name (git-file-name "trivial-features" version))
         (sha256
          (base32 "14pcahr8r2j3idhyy216zyw8jnj1dnrx0qbkkbdqkvwzign1ah4j"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       '(#:asd-files '("trivial-features.asd")
         #:tests? #f))
      (home-page "https://cliki.net/trivial-features")
      (synopsis "Ensures consistency of @code{*FEATURES*} in Common Lisp")
      (description "Trivial-features ensures that @code{*FEATURES*} is
consistent across multiple Common Lisp implementations.")
      (license license:expat))))

(define-public cl-trivial-features
  (sbcl-package->cl-source-package sbcl-trivial-features))

(define-public ecl-trivial-features
  (sbcl-package->ecl-package sbcl-trivial-features))

(define-public sbcl-hu.dwim.asdf
  (package
    (name "sbcl-hu.dwim.asdf")
    (version "20190521")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://beta.quicklisp.org/archive/hu.dwim.asdf/"
                           "2019-05-21/hu.dwim.asdf-" version "-darcs.tgz"))
       (sha256
        (base32
         "0rsbv71vyszy8w35yjwb5h6zcmknjq223hkzir79y72qdsc6sabn"))))
    (build-system asdf-build-system/sbcl)
    (home-page "https://hub.darcs.net/hu.dwim/hu.dwim.asdf")
    (synopsis "Extensions to ASDF")
    (description "Various ASDF extensions such as attached test and
documentation system, explicit development support, etc.")
    (license license:public-domain)))

(define-public cl-hu.dwim.asdf
  (sbcl-package->cl-source-package sbcl-hu.dwim.asdf))

(define-public ecl-hu.dwim.asdf
  (sbcl-package->ecl-package sbcl-hu.dwim.asdf))

(define-public sbcl-hu.dwim.stefil
  (let ((commit "ab6d1aa8995878a1b66d745dfd0ba021090bbcf9"))
    (package
      (name "sbcl-hu.dwim.stefil")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://gitlab.common-lisp.net/xcvb/hu.dwim.stefil.git")
           (commit commit)))
         (sha256
          (base32 "1d8yccw65zj3zh46cbi3x6nmn1dwdb76s9d0av035077mvyirqqp"))
         (file-name (git-file-name "hu.dwim.stefil" version))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("asdf:cl-hu.dwim.asdf" ,sbcl-hu.dwim.asdf)))
      (inputs
       `(("sbcl-alexandria" ,sbcl-alexandria)))
      (home-page "https://hub.darcs.net/hu.dwim/hu.dwim.stefil")
      (synopsis "Simple test framework")
      (description "Stefil is a simple test framework for Common Lisp,
with a focus on interactive development.")
      (license license:public-domain))))

(define-public cl-hu.dwim.stefil
  (sbcl-package->cl-source-package sbcl-hu.dwim.stefil))

(define-public ecl-hu.dwim.stefil
  (sbcl-package->ecl-package sbcl-hu.dwim.stefil))

(define-public sbcl-babel
  ;; No release since 2014.
  (let ((commit "aeed2d1b76358db48e6b70a64399c05678a6b9ea"))
    (package
      (name "sbcl-babel")
      (version (git-version "0.5.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/cl-babel/babel")
               (commit commit)))
         (file-name (git-file-name "babel" version))
         (sha256
          (base32 "0lkvv4xdpv4cv1y2bqillmabx8sdb2y4l6pbinq6mjh33w2brpvb"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("tests:cl-hu.dwim.stefil" ,sbcl-hu.dwim.stefil)))
      (inputs
       `(("sbcl-alexandria" ,sbcl-alexandria)
         ("sbcl-trivial-features" ,sbcl-trivial-features)))
      (home-page "https://common-lisp.net/project/babel/")
      (synopsis "Charset encoding and decoding library")
      (description "Babel is a charset encoding and decoding library, not unlike
GNU libiconv, but completely written in Common Lisp.")
      (license license:expat))))

(define-public cl-babel
  (sbcl-package->cl-source-package sbcl-babel))

(define-public ecl-babel
  (sbcl-package->ecl-package sbcl-babel))

(define-public sbcl-cl-yacc
  (package
    (name "sbcl-cl-yacc")
    (version "0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jech/cl-yacc")
             (commit (string-append "cl-yacc-" version))))
       (sha256
        (base32
         "16946pzf8vvadnyfayvj8rbh4zjzw90h0azz2qk1mxrvhh5wklib"))
       (file-name (string-append "cl-yacc-" version "-checkout"))))
    (build-system asdf-build-system/sbcl)
    (arguments
     `(#:asd-systems '("yacc")))
    (synopsis "LALR(1) parser generator for Common Lisp, similar in spirit to Yacc")
    (description
     "CL-Yacc is a LALR(1) parser generator for Common Lisp, similar in spirit
to AT&T Yacc, Berkeley Yacc, GNU Bison, Zebu, lalr.cl or lalr.scm.

CL-Yacc uses the algorithm due to Aho and Ullman, which is the one also used
by AT&T Yacc, Berkeley Yacc and Zebu.  It does not use the faster algorithm due
to DeRemer and Pennello, which is used by Bison and lalr.scm (not lalr.cl).")
    (home-page "https://www.irif.fr/~jch//software/cl-yacc/")
    (license license:expat)))

(define-public cl-yacc
  (sbcl-package->cl-source-package sbcl-cl-yacc))

(define-public ecl-cl-yacc
  (sbcl-package->ecl-package sbcl-cl-yacc))

(define-public sbcl-eager-future2
  (let ((commit "54df8effd9d9eccac917509590286b5ac5f9cb30"))
    (package
      (name "sbcl-eager-future2")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://gitlab.common-lisp.net/vsedach/eager-future2.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1qs1bv3m0ki8l5czhsflxcryh22r9d9g9a3a3b0cr0pl954q5rld"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("trivial-garbage" ,sbcl-trivial-garbage)))
      (synopsis "Futures promises synchronization mechanism for Common Lisp")
      (description
       "Eager Future2 is a Common Lisp library that provides composable
concurrency primitives that unify parallel and lazy evaluation, are integrated
with the Common Lisp condition system, and have automatic resource
management.")
      (home-page "https://gitlab.common-lisp.net/vsedach/eager-future2")
      (license license:lgpl3+))))

(define-public cl-eager-future2
  (sbcl-package->cl-source-package sbcl-eager-future2))

(define-public ecl-eager-future2
  (sbcl-package->ecl-package sbcl-eager-future2))

(define-public sbcl-jpl-util
  (let ((commit "0311ed374e19a49d43318064d729fe3abd9a3b62"))
    (package
      (name "sbcl-jpl-util")
      (version "20151005")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               ;; Quicklisp uses this fork.
               (url "https://github.com/hawkir/cl-jpl-util")
               (commit commit)))
         (file-name
          (git-file-name "jpl-util" version))
         (sha256
          (base32
           "0nc0rk9n8grkg3045xsw34whmcmddn2sfrxki4268g7kpgz0d2yz"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Collection of Common Lisp utility functions and macros")
      (description
       "@command{cl-jpl-util} is a collection of Common Lisp utility functions
and macros, primarily for software projects written in CL by the author.")
      (home-page "https://www.thoughtcrime.us/software/cl-jpl-util/")
      (license license:isc))))

(define-public cl-jpl-util
  (sbcl-package->cl-source-package sbcl-jpl-util))

(define-public ecl-jpl-util
  (sbcl-package->ecl-package sbcl-jpl-util))

(define-public sbcl-jpl-queues
  (package
    (name "sbcl-jpl-queues")
    (version "0.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "http://www.thoughtcrime.us/software/jpl-queues/jpl-queues-"
             version
             ".tar.gz"))
       (sha256
        (base32
         "1wvvv7j117h9a42qaj1g4fh4mji28xqs7s60rn6d11gk9jl76h96"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("jpl-util" ,sbcl-jpl-util)
       ("bordeaux-threads" ,sbcl-bordeaux-threads)))
    (arguments
     ;; Tests seem to be broken.
     `(#:tests? #f))
    (synopsis "Common Lisp library implementing a few different kinds of queues")
    (description
     "A Common Lisp library implementing a few different kinds of queues:

@itemize
@item Bounded and unbounded FIFO queues.
@item Lossy bounded FIFO queues that drop elements when full.
@item Unbounded random-order queues that use less memory than unbounded FIFO queues.
@end itemize

Additionally, a synchronization wrapper is provided to make any queue
conforming to the @command{jpl-queues} API thread-safe for lightweight
multithreading applications.  (See Calispel for a more sophisticated CL
multithreaded message-passing library with timeouts and alternation among
several blockable channels.)")
    (home-page "https://www.thoughtcrime.us/software/jpl-queues/")
    (license license:isc)))

(define-public cl-jpl-queues
  (sbcl-package->cl-source-package sbcl-jpl-queues))

(define-public ecl-jpl-queues
  (sbcl-package->ecl-package sbcl-jpl-queues))

(define-public sbcl-calispel
  (let ((commit "e9f2f9c1af97f4d7bb4c8ac25fb2a8f3e8fada7a"))
    (package
      (name "sbcl-calispel")
      (version (git-version "0.1" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               ;; This fork replaces the dependency on the obsolete
               ;; eager-future with eager-future2.
               (url "https://github.com/hawkir/calispel")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "08bmf3pi7n5hadpmqqkg65cxcj6kbvm997wcs1f53ml1nb79d9z8"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("jpl-queues" ,sbcl-jpl-queues)
         ("bordeaux-threads" ,sbcl-bordeaux-threads)))
      (native-inputs
       `(("eager-future2" ,sbcl-eager-future2)))
      (synopsis "Thread-safe message-passing channels in Common Lisp")
      (description
       "Calispel is a Common Lisp library for thread-safe message-passing
channels, in the style of the occam programming language, also known as
communicating sequential processes (CSP).  See
@url{https://en.wikipedia.org/wiki/Communicating_sequential_processes}.

Calispel channels let one thread communicate with another, facilitating
unidirectional communication of any Lisp object.  Channels may be unbuffered,
where a sender waits for a receiver (or vice versa) before either operation can
continue, or channels may be buffered with flexible policy options.

Because sending and receiving on a channel may block, either operation can time
out after a specified amount of time.

A syntax for alternation is provided (like @code{ALT} in occam, or Unix
@code{select()}): given a sequence of operations, any or all of which may
block, alternation selects the first operation that doesn't block and executes
associated code.  Alternation can also time out, executing an \"otherwise\"
clause if no operation becomes available within a set amount of time.

Calispel is a message-passing library, and as such leaves the role of
threading abstractions and utilities left to be filled by complementary
libraries such as Bordeaux-Threads and Eager Future.")
      (home-page "https://www.thoughtcrime.us/software/jpl-queues/")
      (license license:isc))))

(define-public cl-calispel
  (sbcl-package->cl-source-package sbcl-calispel))

(define-public ecl-calispel
  (sbcl-package->ecl-package sbcl-calispel))

(define-public sbcl-eos
  (let ((commit "b4413bccc4d142cbe1bf49516c3a0a22c9d99243")
        (revision "2"))
    (package
      (name "sbcl-eos")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/adlai/Eos")
               (commit commit)))
         (sha256
          (base32 "1afllvmlnx97yzz404gycl3pa3kwx427k3hrbf37rpmjlv47knhk"))
         (file-name (git-file-name "eos" version))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Unit Testing for Common Lisp")
      (description
       "Eos was a unit testing library for Common Lisp.
It began as a fork of FiveAM; however, FiveAM development has continued, while
that of Eos has not.  Thus, Eos is now deprecated in favor of FiveAM.")
      (home-page "https://github.com/adlai/Eos")
      (license license:expat))))

(define-public cl-eos
  (sbcl-package->cl-source-package sbcl-eos))

(define-public ecl-eos
  (sbcl-package->ecl-package sbcl-eos))

(define-public sbcl-esrap
  (let ((commit "133be8b05c2aae48696fe5b739eea2fa573fa48d"))
    (package
      (name "sbcl-esrap")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/nikodemus/esrap")
               (commit commit)))
         (sha256
          (base32
           "02d5clihsdryhf7pix8c5di2571fdsffh75d40fkzhws90r5mksl"))
         (file-name (git-file-name "esrap" version))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("eos" ,sbcl-eos)))            ;For testing only.
      (inputs
       `(("alexandria" ,sbcl-alexandria)))
      (synopsis "Common Lisp packrat parser")
      (description
       "A packrat parser for Common Lisp.
In addition to regular Packrat / Parsing Grammar / TDPL features ESRAP supports:

@itemize
@item dynamic redefinition of nonterminals
@item inline grammars
@item semantic predicates
@item introspective facilities (describing grammars, tracing, setting breaks)
@end itemize\n")
      (home-page "https://nikodemus.github.io/esrap/")
      (license license:expat))))

(define-public cl-esrap
  (sbcl-package->cl-source-package sbcl-esrap))

(define-public ecl-esrap
  (sbcl-package->ecl-package sbcl-esrap))

(define-public sbcl-split-sequence
  (package
    (name "sbcl-split-sequence")
    (version "2.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/sharplispers/split-sequence")
             (commit (string-append "v" version))))
       (sha256
        (base32
         "0jcpnx21hkfwqj5fvp7kc6pn1qcz9hk7g2s5x8h0349x1j2irln0"))
       (file-name (git-file-name "split-sequence" version))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("fiveam" ,sbcl-fiveam)))
    (synopsis "Member of the Common Lisp Utilities family of programs")
    (description
     "Splits sequence into a list of subsequences delimited by objects
satisfying the test.")
    (home-page "https://cliki.net/split-sequence")
    (license license:expat)))

(define-public cl-split-sequence
  (sbcl-package->cl-source-package sbcl-split-sequence))

(define-public ecl-split-sequence
  (sbcl-package->ecl-package sbcl-split-sequence))

(define-public sbcl-html-encode
  (package
    (name "sbcl-html-encode")
    (version "1.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "http://beta.quicklisp.org/archive/html-encode/2010-10-06/html-encode-"
             version ".tgz"))
       (sha256
        (base32
         "06mf8wn95yf5swhmzk4vp0xr4ylfl33dgfknkabbkd8n6jns8gcf"))
       (file-name (string-append "colorize" version "-checkout"))))
    (build-system asdf-build-system/sbcl)
    (synopsis "Common Lisp library for encoding text in various web-savvy encodings")
    (description
     "A library for encoding text in various web-savvy encodings.")
    (home-page "http://quickdocs.org/html-encode/")
    (license license:expat)))

(define-public cl-html-encode
  (sbcl-package->cl-source-package sbcl-html-encode))

(define-public ecl-html-encode
  (sbcl-package->ecl-package sbcl-html-encode))

(define-public sbcl-colorize
  (let ((commit "ea676b584e0899cec82f21a9e6871172fe3c0eb5"))
    (package
      (name "sbcl-colorize")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/kingcons/colorize")
               (commit commit)))
         (sha256
          (base32
           "1pdg4kiaczmr3ivffhirp7m3lbr1q27rn7dhaay0vwghmi31zcw9"))
         (file-name (git-file-name "colorize" version))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("split-sequence" ,sbcl-split-sequence)
         ("html-encode" ,sbcl-html-encode)))
      (synopsis "Common Lisp for syntax highlighting")
      (description
       "@command{colorize} is a Lisp library for syntax highlighting
supporting the following languages: Common Lisp, Emacs Lisp, Scheme, Clojure,
C, C++, Java, Python, Erlang, Haskell, Objective-C, Diff, Webkit.")
      (home-page "https://github.com/kingcons/colorize")
      ;; TODO: Missing license?
      (license license:expat))))

(define-public cl-colorize
  (sbcl-package->cl-source-package sbcl-colorize))

(define-public ecl-colorize
  (sbcl-package->ecl-package sbcl-colorize))

(define-public sbcl-3bmd
  (let ((commit "192ea13435b605a96ef607df51317056914cabbd"))
    (package
      (name "sbcl-3bmd")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/3b/3bmd")
               (commit commit)))
         (sha256
          (base32
           "1rgv3gi7wf963ikmmpk132wgn0icddf226gq3bmcnk1fr3v9gf2f"))
         (file-name (git-file-name "3bmd" version))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; FIXME: We need to specify the name because the build-system thinks
       ;; "3" is a version marker.
       `(#:asd-systems '("3bmd"
                         "3bmd-ext-code-blocks")))
      (inputs
       `(("colorize" ,sbcl-colorize)
         ("esrap" ,sbcl-esrap)
         ("split-sequence" ,sbcl-split-sequence)))
      (synopsis "Markdown processor in Command Lisp using esrap parser")
      (description
       "Common Lisp Markdown -> HTML converter, using @command{esrap} for
parsing, and grammar based on @command{peg-markdown}.")
      (home-page "https://github.com/3b/3bmd")
      (license license:expat))))

(define-public cl-3bmd
  (sbcl-package->cl-source-package sbcl-3bmd))

(define-public ecl-3bmd
  (sbcl-package->ecl-package sbcl-3bmd))

(define-public sbcl-cl-fad
  (package
    (name "sbcl-cl-fad")
    (version "0.7.6")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/edicl/cl-fad/")
             (commit (string-append "v" version))))
       (sha256
        (base32
         "1gc8i82v6gks7g0lnm54r4prk2mklidv2flm5fvbr0a7rsys0vpa"))
       (file-name (string-append "cl-fad" version "-checkout"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("bordeaux-threads" ,sbcl-bordeaux-threads)))
    (synopsis "Portable pathname library for Common Lisp")
    (description
     "CL-FAD (for \"Files and Directories\") is a thin layer atop Common
Lisp's standard pathname functions.  It is intended to provide some
unification between current CL implementations on Windows, OS X, Linux, and
Unix.  Most of the code was written by Peter Seibel for his book Practical
Common Lisp.")
    (home-page "https://edicl.github.io/cl-fad/")
    (license license:bsd-2)))

(define-public cl-fad
  (sbcl-package->cl-source-package sbcl-cl-fad))

(define-public ecl-cl-fad
  (sbcl-package->ecl-package sbcl-cl-fad))

(define-public sbcl-rt
  (let ((commit "a6a7503a0b47953bc7579c90f02a6dba1f6e4c5a")
        (revision "1"))
    (package
      (name "sbcl-rt")
      (version (git-version "1990.12.19" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "http://git.kpe.io/rt.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "13si2rrxaagbr0bkvg6sqicxxpyshabx6ad6byc9n2ik5ysna69b"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "MIT Regression Tester")
      (description
       "RT provides a framework for writing regression test suites.")
      (home-page "https://www.cliki.net/rt")
      (license license:expat))))

(define-public cl-rt
  (sbcl-package->cl-source-package sbcl-rt))

(define-public ecl-rt
  (sbcl-package->ecl-package sbcl-rt))

(define-public sbcl-nibbles
  ;; No tagged release since 2018.
  (let ((commit "8e6b9b42d9f69000f55e5c45ad974d9e376ffdbd")
        (revision "1"))
    (package
      (name "sbcl-nibbles")
      (version (git-version "0.14" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/sharplispers/nibbles/")
               (commit commit)))
         (sha256
          (base32 "15qlsm82h36pjgvfnbzdg60l21qxbaii4d049jc5y0dn56y93amb"))
         (file-name (git-file-name "nibbles" version))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       ;; Tests only.
       `(("rt" ,sbcl-rt)))
      (synopsis
       "Common Lisp library for accessing octet-addressed blocks of data")
      (description
       "When dealing with network protocols and file formats, it's common to
have to read or write 16-, 32-, or 64-bit datatypes in signed or unsigned
flavors.  Common Lisp sort of supports this by specifying :element-type for
streams, but that facility is underspecified and there's nothing similar for
read/write from octet vectors.  What most people wind up doing is rolling their
own small facility for their particular needs and calling it a day.

This library attempts to be comprehensive and centralize such
facilities.  Functions to read 16-, 32-, and 64-bit quantities from octet
vectors in signed or unsigned flavors are provided; these functions are also
SETFable.  Since it's sometimes desirable to read/write directly from streams,
functions for doing so are also provided.  On some implementations,
reading/writing IEEE singles/doubles (i.e. single-float and double-float) will
also be supported.")
      (home-page "https://github.com/sharplispers/nibbles")
      (license license:bsd-3))))

(define-public cl-nibbles
  (sbcl-package->cl-source-package sbcl-nibbles))

(define-public ecl-nibbles
  (sbcl-package->ecl-package sbcl-nibbles))

(define-public sbcl-ironclad
  (package
    (name "sbcl-ironclad")
    (version "0.53")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/sharplispers/ironclad/")
             (commit (string-append "v" version))))
       (sha256
        (base32 "01qdfa0jggqbwlsb3aw1iigvs5xhnddk6kn3abhan59956dsbp02"))
       (file-name (git-file-name name version))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     ;; Tests only.
     `(("rt" ,sbcl-rt)))
    (inputs
     `(("bordeaux-threads" ,sbcl-bordeaux-threads)
       ("flexi-streams" ,sbcl-flexi-streams)))
    (synopsis "Cryptographic toolkit written in Common Lisp")
    (description
     "Ironclad is a cryptography library written entirely in Common Lisp.
It includes support for several popular ciphers, digests, MACs and public key
cryptography algorithms.  For several implementations that support Gray
streams, support is included for convenient stream wrappers.")
    (home-page "https://github.com/sharplispers/ironclad")
    (license license:bsd-3)))

(define-public cl-ironclad
  (sbcl-package->cl-source-package sbcl-ironclad))

(define-public ecl-ironclad
  (sbcl-package->ecl-package sbcl-ironclad))

(define-public sbcl-named-readtables
  (let ((commit "64bd53f37a1694cfde48fc38b8f03901f6f0c05b")
        (revision "2"))
    (package
      (name "sbcl-named-readtables")
      (version (git-version "0.9" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/melisgl/named-readtables")
               (commit commit)))
         (sha256
          (base32 "01l4831m7k84qvhzyx0qgdl50isr4zmp40qf6dfq2iqcaj8y4h3n"))
         (file-name (git-file-name "named-readtables" version))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; Tests seem to be broken.
       `(#:tests? #f))
      (home-page "https://github.com/melisgl/named-readtables/")
      (synopsis "Library that creates a namespace for named readtables")
      (description "Named readtables is a library that creates a namespace for
named readtables, which is akin to package namespacing in Common Lisp.")
      (license license:bsd-3))))

(define-public cl-named-readtables
  (sbcl-package->cl-source-package sbcl-named-readtables))

(define-public ecl-named-readtables
  (sbcl-package->ecl-package sbcl-named-readtables))

(define-public sbcl-pythonic-string-reader
  (let ((commit "47a70ba1e32362e03dad6ef8e6f36180b560f86a"))
    (package
      (name "sbcl-pythonic-string-reader")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/smithzvk/pythonic-string-reader/")
               (commit commit)))
         (sha256
          (base32 "1b5iryqw8xsh36swckmz8rrngmc39k92si33fgy5pml3n9l5rq3j"))
         (file-name (git-file-name "pythonic-string-reader" version))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("named-readtables" ,sbcl-named-readtables)))
      (home-page "https://github.com/smithzvk/pythonic-string-reader")
      (synopsis "Read table modification inspired by Python's three quote strings")
      (description "This piece of code sets up some reader macros that make it
simpler to input string literals which contain backslashes and double quotes
This is very useful for writing complicated docstrings and, as it turns out,
writing code that contains string literals that contain code themselves.")
      (license license:bsd-3))))

(define-public cl-pythonic-string-reader
  (sbcl-package->cl-source-package sbcl-pythonic-string-reader))

(define-public ecl-pythonic-string-reader
  (sbcl-package->ecl-package sbcl-pythonic-string-reader))

(define-public sbcl-slime-swank
  (package
    (name "sbcl-slime-swank")
    (version "2.26")
    (source
     (origin
       (file-name (git-file-name "slime-swank" version))
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/slime/slime/")
             (commit (string-append "v" version))))
       (sha256
        (base32
         "0mxb1wnw19v0s72w2wkz5afdlzvpy5nn7pr4vav403qybac0sw5c"))))
    (build-system asdf-build-system/sbcl)
    (arguments
     '(#:asd-systems '("swank")))
    (home-page "https://github.com/slime/slime")
    (synopsis "Common Lisp Swank server")
    (description
     "This is only useful if you want to start a Swank server in a Lisp
processes that doesn't run under Emacs.  Lisp processes created by
@command{M-x slime} automatically start the server.")
    (license (list license:gpl2+ license:public-domain))))

(define-public cl-slime-swank
  (sbcl-package->cl-source-package sbcl-slime-swank))

(define-public ecl-slime-swank
  (sbcl-package->ecl-package sbcl-slime-swank))

(define-public sbcl-mgl-pax
  (let ((commit "818448418d6b9de74620f606f5b23033c6082769"))
    (package
      (name "sbcl-mgl-pax")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/melisgl/mgl-pax")
               (commit commit)))
         (sha256
          (base32
           "1p97zfkh130bdxqqxwaw2j9psv58751wakx7czbfpq410lg7dd7i"))
         (file-name (git-file-name "mgl-pax" version))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("3bmd" ,sbcl-3bmd)
         ("babel" ,sbcl-babel)
         ("cl-fad" ,sbcl-cl-fad)
         ("ironclad" ,sbcl-ironclad)
         ("named-readtables" ,sbcl-named-readtables)
         ("pythonic-string-reader" ,sbcl-pythonic-string-reader)
         ("swank" ,sbcl-slime-swank)))
      (synopsis "Exploratory programming environment and documentation generator")
      (description
       "PAX provides an extremely poor man's Explorable Programming
environment.  Narrative primarily lives in so called sections that mix markdown
docstrings with references to functions, variables, etc, all of which should
probably have their own docstrings.

The primary focus is on making code easily explorable by using SLIME's
@command{M-.} (@command{slime-edit-definition}).  See how to enable some
fanciness in Emacs Integration.  Generating documentation from sections and all
the referenced items in Markdown or HTML format is also implemented.

With the simplistic tools provided, one may accomplish similar effects as with
Literate Programming, but documentation is generated from code, not vice versa
and there is no support for chunking yet.  Code is first, code must look
pretty, documentation is code.")
      (home-page "http://quotenil.com/")
      (license license:expat))))

(define-public cl-mgl-pax
  (sbcl-package->cl-source-package sbcl-mgl-pax))

(define-public ecl-mgl-pax
  (let ((pkg (sbcl-package->ecl-package sbcl-mgl-pax)))
    (package
      (inherit pkg)
      (arguments
       (substitute-keyword-arguments (package-arguments pkg)
         ;; TODO: Find why the tests fail on ECL.
         ((#:tests? _ #f) #f))))))

(define-public sbcl-lisp-unit
  (let ((commit "89653a232626b67400bf9a941f9b367da38d3815"))
    (package
      (name "sbcl-lisp-unit")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/OdonataResearchLLC/lisp-unit")
               (commit commit)))
         (sha256
          (base32
           "0p6gdmgr7p383nvd66c9y9fp2bjk4jx1lpa5p09g43hr9y9pp9ry"))
         (file-name (git-file-name "lisp-unit" version))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Common Lisp Test framework inspired by JUnit to be simple of use")
      (description
       "@command{lisp-unit} is a Common Lisp library that supports unit
testing.  It is an extension of the library written by Chris Riesbeck.")
      (home-page "https://github.com/OdonataResearchLLC/lisp-unit")
      (license license:expat))))

(define-public cl-lisp-unit
  (sbcl-package->cl-source-package sbcl-lisp-unit))

(define-public ecl-lisp-unit
  (sbcl-package->ecl-package sbcl-lisp-unit))

(define-public sbcl-anaphora
  (package
    (name "sbcl-anaphora")
    (version "0.9.6")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tokenrove/anaphora")
             (commit version)))
       (sha256
        (base32
         "19wfrk3asimznkli0x2rfy637hwpdgqyvwj3vhq9x7vjvyf5vv6x"))
       (file-name (git-file-name "anaphora" version))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("rt" ,sbcl-rt)))
    (synopsis "The anaphoric macro collection from Hell")
    (description
     "Anaphora is the anaphoric macro collection from Hell: it includes many
new fiends in addition to old friends like @command{aif} and
@command{awhen}.")
    (home-page "https://github.com/tokenrove/anaphora")
    (license license:public-domain)))

(define-public cl-anaphora
  (sbcl-package->cl-source-package sbcl-anaphora))

(define-public ecl-anaphora
  (sbcl-package->ecl-package sbcl-anaphora))

(define-public sbcl-lift
  (let ((commit "7d49a66c62759535624037826891152223d4206c"))
    (package
      (name "sbcl-lift")
      (version (git-version "1.7.1" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/gwkkwg/lift")
               (commit commit)))
         (sha256
          (base32
           "127v5avpz1i4m0lkaxqrq8hrl69rdazqaxf6s8awf0nd7wj2g4dp"))
         (file-name (git-file-name "lift" version))
         (modules '((guix build utils)))
         (snippet
          ;; Don't keep the bundled website
          `(begin
             (delete-file-recursively "website")
             #t))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; The tests require a debugger, but we run with the debugger disabled.
       '(#:tests? #f))
      (synopsis "LIsp Framework for Testing")
      (description
       "The LIsp Framework for Testing (LIFT) is a unit and system test tool for LISP.
Though inspired by SUnit and JUnit, it's built with Lisp in mind.  In LIFT,
testcases are organized into hierarchical testsuites each of which can have
its own fixture.  When run, a testcase can succeed, fail, or error.  LIFT
supports randomized testing, benchmarking, profiling, and reporting.")
      (home-page "https://github.com/gwkkwg/lift")
      (license license:expat))))

(define-public cl-lift
  (sbcl-package->cl-source-package sbcl-lift))

(define-public ecl-lift
  (sbcl-package->ecl-package sbcl-lift))

(define-public sbcl-let-plus
  (let ((commit "5f14af61d501ecead02ec6b5a5c810efc0c9fdbb"))
    (package
      (name "sbcl-let-plus")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/sharplispers/let-plus")
               (commit commit)))
         (sha256
          (base32
           "0i050ca2iys9f5mb7dgqgqdxfnc3b0rnjdwv95sqd490vkiwrsaj"))
         (file-name (git-file-name "let-plus" version))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("anaphora" ,sbcl-anaphora)))
      (native-inputs
       `(("lift" ,sbcl-lift)))
      (synopsis "Destructuring extension of let*")
      (description
       "This library implements the let+ macro, which is a dectructuring
extension of let*.  It features:

@itemize
@item Clean, consistent syntax and small implementation (less than 300 LOC,
not counting tests)
@item Placeholder macros allow editor hints and syntax highlighting
@item @command{&ign} for ignored values (in forms where that makes sense)
@item Very easy to extend
@end itemize\n")
      (home-page "https://github.com/sharplispers/let-plus")
      (license license:boost1.0))))

(define-public cl-let-plus
  (sbcl-package->cl-source-package sbcl-let-plus))

(define-public ecl-let-plus
  (sbcl-package->ecl-package sbcl-let-plus))

(define-public sbcl-cl-colors
  (let ((commit "827410584553f5c717eec6182343b7605f707f75"))
    (package
      (name "sbcl-cl-colors")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/tpapp/cl-colors")
               (commit commit)))
         (sha256
          (base32
           "0l446lday4hybsm9bq3jli97fvv8jb1d33abg79vbylpwjmf3y9a"))
         (file-name (git-file-name "cl-colors" version))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("let-plus" ,sbcl-let-plus)))
      (synopsis "Simple color library for Common Lisp")
      (description
       "This is a very simple color library for Common Lisp, providing

@itemize
@item Types for representing colors in HSV and RGB spaces.
@item Simple conversion functions between the above types (and also
hexadecimal representation for RGB).
@item Some predefined colors (currently X11 color names – of course the
library does not depend on X11).Because color in your terminal is nice.
@end itemize

This library is no longer supported by its author.")
      (home-page "https://github.com/tpapp/cl-colors")
      (license license:boost1.0))))

(define-public cl-colors
  (sbcl-package->cl-source-package sbcl-cl-colors))

(define-public ecl-cl-colors
  (sbcl-package->ecl-package sbcl-cl-colors))

(define-public sbcl-cl-ansi-text
  (let ((commit "53badf7878f27f22f2d4a2a43e6df458e43acbe9"))
    (package
      (name "sbcl-cl-ansi-text")
      (version (git-version "1.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/pnathan/cl-ansi-text")
               (commit commit)))
         (sha256
          (base32
           "11i27n0dbz5lmygiw65zzr8lx0rac6b6yysqranphn31wls6ja3v"))
         (file-name (git-file-name "cl-ansi-text" version))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-colors" ,sbcl-cl-colors)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (synopsis "ANSI terminal color implementation for Common Lisp")
      (description
       "@command{cl-ansi-text} provides utilities which enable printing to an
ANSI terminal with colored text.  It provides the macro @command{with-color}
which causes everything printed in the body to be displayed with the provided
color.  It further provides functions which will print the argument with the
named color.")
      (home-page "https://github.com/pnathan/cl-ansi-text")
      (license license:llgpl))))

(define-public cl-ansi-text
  (sbcl-package->cl-source-package sbcl-cl-ansi-text))

(define-public ecl-cl-ansi-text
  (sbcl-package->ecl-package sbcl-cl-ansi-text))

(define-public sbcl-prove
  (let ((commit "4f9122bd393e63c5c70c1fba23070622317cfaa0"))
    (package
      (name "sbcl-prove")
      (version (git-version "1.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/prove")
               (commit commit)))
         (sha256
          (base32
           "07sbfw459z8bbjvx1qlmfa8qk2mvbjnnzi2mi0x72blaj8bkl4vc"))
         (file-name (git-file-name "prove" version))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("cl-ansi-text" ,sbcl-cl-ansi-text)))
      (synopsis "Yet another unit testing framework for Common Lisp")
      (description
       "This project was originally called @command{cl-test-more}.
@command{prove} is yet another unit testing framework for Common Lisp.  The
advantages of @command{prove} are:

@itemize
@item Various simple functions for testing and informative error messages
@item ASDF integration
@item Extensible test reporters
@item Colorizes the report if it's available (note for SLIME)
@item Reports test durations
@end itemize\n")
      (home-page "https://github.com/fukamachi/prove")
      (license license:expat))))

(define-public cl-prove
  (sbcl-package->cl-source-package sbcl-prove))

(define-public ecl-prove
  (sbcl-package->ecl-package sbcl-prove))

(define-public sbcl-proc-parse
  (let ((commit "ac3636834d561bdc2686c956dbd82494537285fd"))
    (package
      (name "sbcl-proc-parse")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/proc-parse")
               (commit commit)))
         (sha256
          (base32
           "06rnl0h4cx6xv2wj3jczmmcxqn2703inmmvg1s4npbghmijsybfh"))
         (file-name (git-file-name "proc-parse" version))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("babel" ,sbcl-babel)))
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (arguments
       ;; TODO: Tests don't find "proc-parse-test", why?
       `(#:tests? #f))
      (synopsis "Procedural vector parser")
      (description
       "This is a string/octets parser library for Common Lisp with speed and
readability in mind.  Unlike other libraries, the code is not a
pattern-matching-like, but a char-by-char procedural parser.")
      (home-page "https://github.com/fukamachi/proc-parse")
      (license license:bsd-2))))

(define-public cl-proc-parse
  (sbcl-package->cl-source-package sbcl-proc-parse))

(define-public ecl-proc-parse
  (sbcl-package->ecl-package sbcl-proc-parse))

(define-public sbcl-parse-float
  (let ((commit "2aae569f2a4b2eb3bfb5401a959425dcf151b09c"))
    (package
      (name "sbcl-parse-float")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/soemraws/parse-float")
               (commit commit)))
         (sha256
          (base32
           "08xw8cchhmqcc0byng69m3f5a2izc9y2290jzz2k0qrbibp1fdk7"))
         (file-name (git-file-name "proc-parse" version))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("babel" ,sbcl-babel)))
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (arguments
       ;; TODO: Tests don't find "proc-parse-test", why?
       `(#:tests? #f))
      (synopsis "Parse a floating point value from a string in Common Lisp")
      (description
       "This package exports the following function to parse floating-point
values from a string in Common Lisp.")
      (home-page "https://github.com/soemraws/parse-float")
      (license license:public-domain))))

(define-public cl-parse-float
  (sbcl-package->cl-source-package sbcl-parse-float))

(define-public ecl-parse-float
  (sbcl-package->ecl-package sbcl-parse-float))

(define-public sbcl-cl-string-match
  (let ((revision "1")
        (changeset "5048480a61243e6f1b02884012c8f25cdbee6d97"))
    (package
      (name "sbcl-cl-string-match")
      (version (git-version "0" revision changeset))
      (source
       (origin
         (method hg-fetch)
         (uri (hg-reference
               (url "https://bitbucket.org/vityok/cl-string-match/")
               (changeset changeset)))
         (sha256
          (base32
           "01wn5qx562w43ssy92xlfgv79w7p0nv0wbl76mpmba131n9ziq2y"))
         (file-name (git-file-name "cl-string-match" version))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("babel" ,sbcl-babel)
         ("iterate" ,sbcl-iterate)
         ("jpl-queues" ,sbcl-jpl-queues)
         ("jpl-util" ,sbcl-jpl-util)
         ("mgl-pax" ,sbcl-mgl-pax)
         ("parse-float" ,sbcl-parse-float)
         ("proc-parse" ,sbcl-proc-parse)
         ("yacc" ,sbcl-cl-yacc)))
      ;; TODO: Tests are not evaluated properly.
      (native-inputs
       ;; For testing:
       `(("lisp-unit" ,sbcl-lisp-unit)))
      (arguments
       `(#:tests? #f))
      (synopsis "Set of utilities to manipulate strings in Common Lisp")
      (description
       "@command{cl-strings} is a small, portable, dependency-free set of
utilities that make it even easier to manipulate text in Common Lisp.  It has
100% test coverage and works at least on sbcl, ecl, ccl, abcl and clisp.")
      (home-page "https://bitbucket.org/vityok/cl-string-match/")
      (license license:bsd-3))))

(define-public cl-string-match
  (sbcl-package->cl-source-package sbcl-cl-string-match))

(define-public ecl-cl-string-match
  (sbcl-package->ecl-package sbcl-cl-string-match))

(define-public sbcl-ptester
  (let ((commit "fe69fde54f4bce00ce577feb918796c293fc7253")
        (revision "1"))
    (package
      (name "sbcl-ptester")
      (version (git-version "2.1.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "http://git.kpe.io/ptester.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1l0lfl7cdnr2qf4zh38hi4llxg22c49zkm639bdkmvlkzwj3ndwf"))))
      (build-system asdf-build-system/sbcl)
      (home-page "http://quickdocs.org/ptester/")
      (synopsis "Portable test harness package")
      (description
       "@command{ptester} is a portable testing framework based on Franz's
tester module.")
      (license license:llgpl))))

(define-public cl-ptester
  (sbcl-package->cl-source-package sbcl-ptester))

(define-public ecl-ptester
  (sbcl-package->ecl-package sbcl-ptester))

(define-public sbcl-puri
  (let ((commit "ef5afb9e5286c8e952d4344f019c1a636a717b97")
        (revision "1"))
    (package
      (name "sbcl-puri")
      (version (git-version "1.5.7" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "http://git.kpe.io/puri.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1vm25pdl92laj72p5vyd538kf3cjy2655z6bdc99h20ana2p231s"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("ptester" ,sbcl-ptester)))
      (home-page "http://quickdocs.org/puri/")
      (synopsis "Portable URI Library")
      (description
       "This is a portable Universal Resource Identifier library for Common
Lisp programs.  It parses URI according to the RFC 2396 specification.")
      (license license:llgpl))))

(define-public cl-puri
  (sbcl-package->cl-source-package sbcl-puri))

(define-public ecl-puri
  (sbcl-package->ecl-package sbcl-puri))

(define-public sbcl-qmynd
  (let ((commit "7e56daf73f0ed5f49a931c01af75fb874bcf3445")
        (revision "1"))
    (package
      (name "sbcl-qmynd")
      (version (git-version "1.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/qitab/qmynd")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "06gw5wxcpdclb6a5i5k9lbmdlyqsp182czrm9bm1cpklzbj0ihrl"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("asdf-finalizers" ,sbcl-asdf-finalizers)
         ("babel" ,sbcl-babel)
         ("chipz" ,sbcl-chipz)
         ("cl+ssl" ,sbcl-cl+ssl)
         ("flexi-streams" ,sbcl-flexi-streams)
         ("ironclad" ,sbcl-ironclad)
         ("salza2" ,sbcl-salza2)
         ("trivial-gray-streams" ,sbcl-trivial-gray-streams)
         ("usocket" ,sbcl-usocket)))
      (home-page "https://github.com/qitab/qmynd")
      (synopsis "QITAB MySQL Native Driver for Common Lisp")
      (description "QMyND, the QITAB MySQL Native Driver, is a MySQL client
library that directly talks to a MySQL server in its native network protocol.

It's a part of QITAB umbrella project.")
      (license license:expat))))

(define-public ecl-qmynd
  (sbcl-package->ecl-package sbcl-qmynd))

(define-public cl-qmynd
  (sbcl-package->cl-source-package sbcl-qmynd))

(define-public sbcl-queues
  (let ((commit "47d4da65e9ea20953b74aeeab7e89a831b66bc94"))
    (package
      (name "sbcl-queues")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/oconnore/queues")
               (commit commit)))
         (file-name (git-file-name "queues" version))
         (sha256
          (base32
           "0wdhfnzi4v6d97pggzj2aw55si94w4327br94jrmyvwf351wqjvv"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("bordeaux-threads" ,sbcl-bordeaux-threads)))
      (arguments
       '(#:asd-systems '("queues"
                         "queues.simple-queue"
                         "queues.simple-cqueue"
                         "queues.priority-queue"
                         "queues.priority-cqueue")))
      (home-page "https://github.com/oconnore/queues")
      (synopsis "Common Lisp queue library")
      (description
       "This is a simple queue library for Common Lisp with features such as
non-consing thread safe queues and fibonacci priority queues.")
      (license license:expat))))

(define-public cl-queues
  (sbcl-package->cl-source-package sbcl-queues))

(define-public ecl-queues
  (sbcl-package->ecl-package sbcl-queues))

(define-public sbcl-cffi
  (package
    (name "sbcl-cffi")
    (version "0.21.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/cffi/cffi")
             (commit (string-append "v" version))))
       (file-name (git-file-name "cffi-bootstrap" version))
       (sha256
        (base32 "1qalargz9bhp850qv60ffwpdqi4xirzar4l3g6qcg8yc6xqf2cjk"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("alexandria" ,sbcl-alexandria)
       ("babel" ,sbcl-babel)
       ("libffi" ,libffi)
       ("trivial-features" ,sbcl-trivial-features)))
    (native-inputs
     `(("bordeaux-threads" ,sbcl-bordeaux-threads)
       ("pkg-config" ,pkg-config)
       ("rt" ,sbcl-rt)))
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-arm-support
           (lambda _
             ;; This is apparently deprecated since libffi-3.3.
             (substitute* "libffi/libffi-types.lisp"
               (("\\\(\\\(:unix64.*") ")\n"))
             #t))
         (add-after 'unpack 'fix-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "libffi/libffi.lisp"
               (("libffi.so.7" all) (string-append
                                     (assoc-ref inputs "libffi")
                                     "/lib/" all)))
             (substitute* "toolchain/c-toolchain.lisp"
               (("\"cc\"") (format #f "~S" (which "gcc"))))))
         (add-after 'build 'install-headers
           (lambda* (#:key outputs #:allow-other-keys)
             (install-file "grovel/common.h"
                           (string-append
                            (assoc-ref outputs "out")
                            "/include/grovel")))))
       #:asd-files '("cffi.asd"
                     "cffi-toolchain.asd"
                     "cffi-grovel.asd"
                     "cffi-libffi.asd"
                     "cffi-uffi-compat.asd")
       #:asd-systems '("cffi"
                       "cffi-libffi"
                       "cffi-uffi-compat")))
    (home-page "https://common-lisp.net/project/cffi/")
    (synopsis "Common Foreign Function Interface for Common Lisp")
    (description "The Common Foreign Function Interface (CFFI)
purports to be a portable foreign function interface for Common Lisp.
The CFFI library is composed of a Lisp-implementation-specific backend
in the CFFI-SYS package, and a portable frontend in the CFFI
package.")
    (license license:expat)))

(define-public cl-cffi
  (sbcl-package->cl-source-package sbcl-cffi))

(define-public ecl-cffi
  (sbcl-package->ecl-package sbcl-cffi))

(define-public sbcl-cl-sqlite
  (package
    (name "sbcl-cl-sqlite")
    (version "0.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/dmitryvk/cl-sqlite")
             (commit version)))
       (file-name (git-file-name "cl-sqlite" version))
       (sha256
        (base32
         "08iv7b4m0hh7qx2cvq4f510nrgdld0vicnvmqsh9w0fgrcgmyg4k"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("iterate" ,sbcl-iterate)
       ("cffi" ,sbcl-cffi)
       ("sqlite" ,sqlite)))
    (native-inputs
     `(("fiveam" ,sbcl-fiveam)
       ("bordeaux-threads" ,sbcl-bordeaux-threads)))
    (arguments
     `(#:asd-systems '("sqlite")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "sqlite-ffi.lisp"
               (("libsqlite3" all) (string-append
                                    (assoc-ref inputs "sqlite")"/lib/" all))))))))
    (home-page "https://common-lisp.net/project/cl-sqlite/")
    (synopsis "Common Lisp binding for SQLite")
    (description
     "The @command{cl-sqlite} package is an interface to the SQLite embedded
relational database engine.")
    (license license:public-domain)))

(define-public cl-sqlite
  (sbcl-package->cl-source-package sbcl-cl-sqlite))

(define-public ecl-cl-sqlite
  (sbcl-package->ecl-package sbcl-cl-sqlite))

(define-public sbcl-parenscript
  ;; Source archives are overwritten on every release, we use the Git repo instead.
  (let ((commit "7a1ac46353cecd144fc91915ba9f122aafcf4766"))
    (package
      (name "sbcl-parenscript")
      (version (git-version "2.7.1" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://gitlab.common-lisp.net/parenscript/parenscript")
               (commit commit)))
         (file-name (git-file-name "parenscript" version))
         (sha256
          (base32
           "0c22lqarrpbq82dg1sb3y6mp6w2faczp34ymzhnmff88yfq1xzsf"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cl-ppcre" ,sbcl-cl-ppcre)
         ("anaphora" ,sbcl-anaphora)
         ("named-readtables" ,sbcl-named-readtables)))
      (home-page "https://common-lisp.net/project/parenscript/")
      (synopsis "Translator from a subset of Common Lisp to JavaScript")
      (description
       "Parenscript is a translator from an extended subset of Common Lisp to
JavaScript.  Parenscript code can run almost identically on both the
browser (as JavaScript) and server (as Common Lisp).

Parenscript code is treated the same way as Common Lisp code, making the full
power of Lisp macros available for JavaScript.  This provides a web
development environment that is unmatched in its ability to reduce code
duplication and provide advanced meta-programming facilities to web
developers.

At the same time, Parenscript is different from almost all other \"language
X\" to JavaScript translators in that it imposes almost no overhead:

@itemize
@item No run-time dependencies: Any piece of Parenscript code is runnable
as-is.  There are no JavaScript files to include.
@item Native types: Parenscript works entirely with native JavaScript data
types.  There are no new types introduced, and object prototypes are not
touched.
@item Native calling convention: Any JavaScript code can be called without the
need for bindings.  Likewise, Parenscript can be used to make efficient,
self-contained JavaScript libraries.
@item Readable code: Parenscript generates concise, formatted, idiomatic
JavaScript code.  Identifier names are preserved.  This enables seamless
debugging in tools like Firebug.
@item Efficiency: Parenscript introduces minimal overhead for advanced Common
Lisp features.  The generated code is almost as fast as hand-written
JavaScript.
@end itemize\n")
      (license license:bsd-3))))

(define-public cl-parenscript
  (sbcl-package->cl-source-package sbcl-parenscript))

(define-public ecl-parenscript
  (sbcl-package->ecl-package sbcl-parenscript))

(define-public sbcl-cl-json
  (let ((commit "6dfebb9540bfc3cc33582d0c03c9ec27cb913e79"))
    (package
      (name "sbcl-cl-json")
      (version (git-version "0.5" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/hankhero/cl-json")
               (commit commit)))
         (file-name (git-file-name "cl-json" version))
         (sha256
          (base32
           "0fx3m3x3s5ji950yzpazz4s0img3l6b3d6l3jrfjv0lr702496lh"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (home-page "https://github.com/hankhero/cl-json")
      (synopsis "JSON encoder and decoder for Common-Lisp")
      (description
       "@command{cl-json} provides an encoder of Lisp objects to JSON format
and a corresponding decoder of JSON data to Lisp objects.  Both the encoder
and the decoder are highly customizable; at the same time, the default
settings ensure a very simple mode of operation, similar to that provided by
@command{yason} or @command{st-json}.")
      (license license:expat))))

(define-public cl-json
  (sbcl-package->cl-source-package sbcl-cl-json))

(define-public ecl-cl-json
  (sbcl-package->ecl-package sbcl-cl-json))

(define-public sbcl-unix-opts
  (package
    (name "sbcl-unix-opts")
    (version "0.1.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/libre-man/unix-opts")
             (commit version)))
       (file-name (git-file-name "unix-opts" version))
       (sha256
        (base32
         "08djdi1ard09fijb7w9bdmhmwd98b1hzmcnjw9fqjiqa0g3b44rr"))))
    (build-system asdf-build-system/sbcl)
    (home-page "https://github.com/hankhero/cl-json")
    (synopsis "Unix-style command line options parser")
    (description
     "This is a minimalistic parser of command line options.  The main
advantage of the library is the ability to concisely define command line
options once and then use this definition for parsing and extraction of
command line arguments, as well as printing description of command line
options (you get --help for free).  This way you don't need to repeat
yourself.  Also, @command{unix-opts} doesn't depend on anything and
precisely controls the behavior of the parser via Common Lisp restarts.")
    (license license:expat)))

(define-public cl-unix-opts
  (sbcl-package->cl-source-package sbcl-unix-opts))

(define-public ecl-unix-opts
  (sbcl-package->ecl-package sbcl-unix-opts))

(define-public sbcl-trivial-garbage
  (package
    (name "sbcl-trivial-garbage")
    (version "0.21")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/trivial-garbage/trivial-garbage")
             (commit (string-append "v" version))))
       (file-name (git-file-name "trivial-garbage" version))
       (sha256
        (base32 "0122jicfg7pca1wxw8zak1n92h5friqy60988ns0ysksj3fphw9n"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("rt" ,sbcl-rt)))
    (home-page "https://common-lisp.net/project/trivial-garbage/")
    (synopsis "Portable GC-related APIs for Common Lisp")
    (description "@command{trivial-garbage} provides a portable API to
finalizers, weak hash-tables and weak pointers on all major implementations of
the Common Lisp programming language.")
    (license license:public-domain)))

(define-public cl-trivial-garbage
  (sbcl-package->cl-source-package sbcl-trivial-garbage))

(define-public ecl-trivial-garbage
  (sbcl-package->ecl-package sbcl-trivial-garbage))

(define-public sbcl-closer-mop
  (let ((commit "19c9d33f576e10715fd79cc1d4f688dab0f241d6"))
    (package
      (name "sbcl-closer-mop")
      (version (git-version  "1.0.0" "2" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/pcostanza/closer-mop")
               (commit commit)))
         (sha256
          (base32 "1w3x087wvlwkd6swfdgbvjfs6kazf0la8ax4pjfzikwjch4snn2c"))
         (file-name (git-file-name "closer-mop" version ))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/pcostanza/closer-mop")
      (synopsis "Rectifies absent or incorrect CLOS MOP features")
      (description "Closer to MOP is a compatibility layer that rectifies many
of the absent or incorrect CLOS MOP features across a broad range of Common
Lisp implementations.")
      (license license:expat))))

(define-public cl-closer-mop
  (sbcl-package->cl-source-package sbcl-closer-mop))

(define-public ecl-closer-mop
  (sbcl-package->ecl-package sbcl-closer-mop))

(define-public sbcl-cl-cffi-gtk
  (let ((commit "e9a46df65995d9a16e6c8dbdc1e09b775eb4a966"))
    (package
      (name "sbcl-cl-cffi-gtk")
      (version (git-version "0.11.2" "2" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Ferada/cl-cffi-gtk/")
               (commit commit)))
         (file-name (git-file-name "cl-cffi-gtk" version))
         (sha256
          (base32
           "04vix0gmqsj91lm975sx7jhlnz5gq1xf9jp873mp7c8frc5dk1jj"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("cairo" ,cairo)
         ("cffi" ,sbcl-cffi)
         ("closer-mop" ,sbcl-closer-mop)
         ("gdk-pixbuf" ,gdk-pixbuf)
         ("glib" ,glib)
         ("gtk" ,gtk+)
         ("iterate" ,sbcl-iterate)
         ("pango" ,pango)
         ("trivial-features" ,sbcl-trivial-features)
         ("trivial-garbage" ,sbcl-trivial-garbage)))
      (arguments
       `(#:asd-files '("gtk/cl-cffi-gtk.asd"
                       "glib/cl-cffi-gtk-glib.asd"
                       "gobject/cl-cffi-gtk-gobject.asd"
                       "gio/cl-cffi-gtk-gio.asd"
                       "cairo/cl-cffi-gtk-cairo.asd"
                       "pango/cl-cffi-gtk-pango.asd"
                       "gdk-pixbuf/cl-cffi-gtk-gdk-pixbuf.asd"
                       "gdk/cl-cffi-gtk-gdk.asd")
         #:test-asd-file "test/cl-cffi-gtk-test.asd"
         ;; TODO: Tests fail with memory fault.
         ;; See https://github.com/Ferada/cl-cffi-gtk/issues/24.
         #:tests? #f
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "glib/glib.init.lisp"
                 (("libglib|libgthread" all)
                  (string-append (assoc-ref inputs "glib") "/lib/" all)))
               (substitute* "gobject/gobject.init.lisp"
                 (("libgobject" all)
                  (string-append (assoc-ref inputs "glib") "/lib/" all)))
               (substitute* "gio/gio.init.lisp"
                 (("libgio" all)
                  (string-append (assoc-ref inputs "glib") "/lib/" all)))
               (substitute* "cairo/cairo.init.lisp"
                 (("libcairo" all)
                  (string-append (assoc-ref inputs "cairo") "/lib/" all)))
               (substitute* "pango/pango.init.lisp"
                 (("libpango" all)
                  (string-append (assoc-ref inputs "pango") "/lib/" all)))
               (substitute* "gdk-pixbuf/gdk-pixbuf.init.lisp"
                 (("libgdk_pixbuf" all)
                  (string-append (assoc-ref inputs "gdk-pixbuf") "/lib/" all)))
               (substitute* "gdk/gdk.init.lisp"
                 (("libgdk" all)
                  (string-append (assoc-ref inputs "gtk") "/lib/" all)))
               (substitute* "gdk/gdk.package.lisp"
                 (("libgtk" all)
                  (string-append (assoc-ref inputs "gtk") "/lib/" all))))))))
      (home-page "https://github.com/Ferada/cl-cffi-gtk/")
      (synopsis "Common Lisp binding for GTK+3")
      (description
       "@command{cl-cffi-gtk} is a Lisp binding to GTK+ 3 (GIMP Toolkit) which
is a library for creating graphical user interfaces.")
      (license license:lgpl3))))

(define-public cl-cffi-gtk
  (sbcl-package->cl-source-package sbcl-cl-cffi-gtk))

(define-public ecl-cl-cffi-gtk
  (sbcl-package->ecl-package sbcl-cl-cffi-gtk))

(define-public sbcl-cl-webkit
  (let ((commit "5ce3ea1fbf2b21e7ccb98402a818508ca9b79395"))
    (package
      (name "sbcl-cl-webkit")
      (version (git-version "2.4" "10" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/joachifm/cl-webkit")
               (commit commit)))
         (file-name (git-file-name "cl-webkit" version))
         (sha256
          (base32
           "0zgd8hp2nalh0v4xgjvqxd6rf95f7mci181xbg3gmqxxwxd4mkpk"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cffi" ,sbcl-cffi)
         ("cl-cffi-gtk" ,sbcl-cl-cffi-gtk)
         ("webkitgtk" ,webkitgtk)))
      (arguments
       `(#:asd-systems '("cl-webkit2")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "webkit2/webkit2.init.lisp"
                 (("libwebkit2gtk" all)
                  (string-append
                   (assoc-ref inputs "webkitgtk") "/lib/" all))))))))
      (home-page "https://github.com/joachifm/cl-webkit")
      (synopsis "Binding to WebKitGTK+ for Common Lisp")
      (description
       "@command{cl-webkit} is a binding to WebKitGTK+ for Common Lisp,
currently targeting WebKit version 2.  The WebKitGTK+ library adds web
browsing capabilities to an application, leveraging the full power of the
WebKit browsing engine.")
      (license license:expat))))

(define-public cl-webkit
  (sbcl-package->cl-source-package sbcl-cl-webkit))

(define-public ecl-cl-webkit
  (sbcl-package->ecl-package sbcl-cl-webkit))

(define-public sbcl-lparallel
  (package
    (name "sbcl-lparallel")
    (version "2.8.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/lmj/lparallel/")
             (commit (string-append "lparallel-" version))))
       (file-name (git-file-name "lparallel" version))
       (sha256
        (base32
         "0g0aylrbbrqsz0ahmwhvnk4cmc2931fllbpcfgzsprwnqqd7vwq9"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("alexandria" ,sbcl-alexandria)
       ("bordeaux-threads" ,sbcl-bordeaux-threads)
       ("trivial-garbage" ,sbcl-trivial-garbage)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-dependency
           ;; lparallel loads a SBCL specific system in its asd file. This is
           ;; not carried over into the fasl which is generated. In order for
           ;; it to be carried over, it needs to be listed as a dependency.
           (lambda _
             (substitute* "lparallel.asd"
               ((":depends-on \\(:alexandria" all)
                (string-append all " #+sbcl :sb-cltl2"))))))))
    (home-page "https://lparallel.org/")
    (synopsis "Parallelism for Common Lisp")
    (description
     "@command{lparallel} is a library for parallel programming in Common
Lisp, featuring:

@itemize
@item a simple model of task submission with receiving queue,
@item constructs for expressing fine-grained parallelism,
@item asynchronous condition handling across thread boundaries,
@item parallel versions of map, reduce, sort, remove, and many others,
@item promises, futures, and delayed evaluation constructs,
@item computation trees for parallelizing interconnected tasks,
@item bounded and unbounded FIFO queues,
@item high and low priority tasks,
@item task killing by category,
@item integrated timeouts.
@end itemize\n")
    (license license:expat)))

(define-public cl-lparallel
  (sbcl-package->cl-source-package sbcl-lparallel))

(define-public ecl-lparallel
  (package
    (inherit (sbcl-package->ecl-package sbcl-lparallel))
    (arguments
     ;; TODO: Find why the tests get stuck forever; disable them for now.
     `(#:tests? #f))))

(define-public sbcl-cl-markup
  (let ((commit "e0eb7debf4bdff98d1f49d0f811321a6a637b390"))
    (package
      (name "sbcl-cl-markup")
      (version (git-version "0.1" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/arielnetworks/cl-markup/")
               (commit commit)))
         (file-name (git-file-name "cl-markup" version))
         (sha256
          (base32
           "10l6k45971dl13fkdmva7zc6i453lmq9j4xax2ci6pjzlc6xjhp7"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/arielnetworks/cl-markup/")
      (synopsis "Markup generation library for Common Lisp")
      (description
       "A modern markup generation library for Common Lisp that features:

@itemize
@item Fast (even faster through compiling the code)
@item Safety
@item Support for multiple document types (markup, xml, html, html5, xhtml)
@item Output with doctype
@item Direct output to stream
@end itemize\n")
      (license license:lgpl3+))))

(define-public cl-markup
  (sbcl-package->cl-source-package sbcl-cl-markup))

(define-public ecl-cl-markup
  (sbcl-package->ecl-package sbcl-cl-markup))

(define-public sbcl-cl-mustache
  (package
    (name "sbcl-cl-mustache")
    (version "0.12.1")
    (source
     (origin
      (method git-fetch)
      (uri (git-reference
            (url "https://github.com/kanru/cl-mustache")
            (commit (string-append "v" version))))
      (file-name (git-file-name "cl-mustache" version))
      (sha256
       (base32 "149xbb6wxq1napliwm9cv729hwcgfnjli6y8hingfixz7f10lhks"))))
    (build-system asdf-build-system/sbcl)
    (home-page "https://github.com/kanru/cl-mustache")
    (synopsis "Common Lisp Mustache template renderer")
    (description "This is a Common Lisp implementation for the Mustache
template system.  More details on the standard are available at
@url{https://mustache.github.io}.")
    (license license:expat)))

(define-public cl-mustache
  (sbcl-package->cl-source-package sbcl-cl-mustache))

(define-public ecl-cl-mustache
  (sbcl-package->ecl-package sbcl-cl-mustache))

(define-public sbcl-cl-css
  (let ((commit "8fe654c8f0cf95b300718101cce4feb517f78e2f"))
    (package
      (name "sbcl-cl-css")
      (version (git-version "0.1" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/inaimathi/cl-css/")
               (commit commit)))
         (file-name (git-file-name "cl-css" version))
         (sha256
          (base32
           "1lc42zi2sw11fl2589sc19nr5sd2p0wy7wgvgwaggxa5f3ajhsmd"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/inaimathi/cl-css/")
      (synopsis "Non-validating, inline CSS generator for Common Lisp")
      (description
       "This is a dead-simple, non validating, inline CSS generator for Common
Lisp.  Its goals are axiomatic syntax, simple implementation to support
portability, and boilerplate reduction in CSS.")
      (license license:expat))))

(define-public cl-css
  (sbcl-package->cl-source-package sbcl-cl-css))

(define-public ecl-cl-css
  (sbcl-package->ecl-package sbcl-cl-css))

(define-public sbcl-portable-threads
  (let ((commit "aa26bf38338a6b068bf8bfb3375d8d8c3b0a28df"))
    (package
      (name "sbcl-portable-threads")
      (version (git-version "2.3" "2" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/binghe/portable-threads/")
               (commit commit)))
         (file-name (git-file-name "portable-threads" version))
         (sha256
          (base32 "058ksi07vfdmhrf5mdlc833s82m1rcqfja2266520m3r8bzs8bvs"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       `(;; Tests seem broken.
         #:tests? #f))
      (home-page "https://github.com/binghe/portable-threads")
      (synopsis "Portable threads API for Common Lisp")
      (description
       "Portable Threads (and Scheduled and Periodic Functions) API for Common
Lisp (from GBBopen project).")
      (license license:asl2.0))))

(define-public cl-portable-threads
  (sbcl-package->cl-source-package sbcl-portable-threads))

(define-public ecl-portable-threads
  (sbcl-package->ecl-package sbcl-portable-threads))

(define-public sbcl-usocket
  (package
    (name "sbcl-usocket")
    (version "0.8.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/usocket/usocket/")
             (commit (string-append "v" version))))
       (file-name (git-file-name "usocket" version))
       (sha256
        (base32
         "0x746wr2324l6bn7skqzgkzcbj5kd0zp2ck0c8rldrw0rzabg826"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("rt" ,sbcl-rt)))
    (inputs
     `(("bordeaux-threads" ,sbcl-bordeaux-threads)
       ("split-sequence" ,sbcl-split-sequence)))
    (arguments
     `(#:tests? #f ; FIXME: Tests need network access?
       #:asd-systems '("usocket"
                       "usocket-server")))
    (home-page "https://common-lisp.net/project/usocket/")
    (synopsis "Universal socket library for Common Lisp")
    (description
     "This library strives to provide a portable TCP/IP and UDP/IP socket
interface for as many Common Lisp implementations as possible, while keeping
the abstraction and portability layer as thin as possible.")
    (license license:expat)))

(define-public cl-usocket
  (sbcl-package->cl-source-package sbcl-usocket))

(define-public ecl-usocket
  (sbcl-package->ecl-package sbcl-usocket))

(define-public sbcl-s-xml
  (package
    (name "sbcl-s-xml")
    (version "3")
    (source
     (origin
       (method url-fetch)
       (uri "https://common-lisp.net/project/s-xml/s-xml.tgz")
       (sha256
        (base32
         "061qcr0dzshsa38s5ma4ay924cwak2nq9gy59dw6v9p0qb58nzjf"))))
    (build-system asdf-build-system/sbcl)
    (home-page "https://common-lisp.net/project/s-xml/")
    (synopsis "Simple XML parser implemented in Common Lisp")
    (description
     "S-XML is a simple XML parser implemented in Common Lisp.  This XML
parser implementation has the following features:

@itemize
@item It works (handling many common XML usages).
@item It is very small (the core is about 700 lines of code, including
comments and whitespace).
@item It has a core API that is simple, efficient and pure functional, much
like that from SSAX (see also http://ssax.sourceforge.net).
@item It supports different DOM models: an XSML-based one, an LXML-based one
and a classic xml-element struct based one.
@item It is reasonably time and space efficient (internally avoiding garbage
generatation as much as possible).
@item It does support CDATA.
@item It should support the same character sets as your Common Lisp
implementation.
@item It does support XML name spaces.
@end itemize

This XML parser implementation has the following limitations:

@itemize
@item It does not support any special tags (like processing instructions).
@item It is not validating, even skips DTD's all together.
@end itemize\n")
    (license license:lgpl3+)))

(define-public cl-s-xml
  (sbcl-package->cl-source-package sbcl-s-xml))

(define-public ecl-s-xml
  (sbcl-package->ecl-package sbcl-s-xml))

(define-public sbcl-s-xml-rpc
  (package
    (name "sbcl-s-xml-rpc")
    (version "7")
    (source
     (origin
       (method url-fetch)
       (uri "https://common-lisp.net/project/s-xml-rpc/s-xml-rpc.tgz")
       (sha256
        (base32
         "02z7k163d51v0pzk8mn1xb6h5s6x64gjqkslhwm3a5x26k2gfs11"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("s-xml" ,sbcl-s-xml)))
    (home-page "https://common-lisp.net/project/s-xml-rpc/")
    (synopsis "Implementation of XML-RPC in Common Lisp for both client and server")
    (description
     "S-XML-RPC is an implementation of XML-RPC in Common Lisp for both
client and server.")
    (license license:lgpl3+)))

(define-public cl-s-xml-rpc
  (sbcl-package->cl-source-package sbcl-s-xml-rpc))

(define-public ecl-s-xml-rpc
  (sbcl-package->ecl-package sbcl-s-xml-rpc))

(define-public sbcl-trivial-clipboard
  (let ((commit "afcd3743b842f5a81fc86dba60f9db59970f49c5"))
    (package
      (name "sbcl-trivial-clipboard")
      (version (git-version "0.0.0.0" "3" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/snmsts/trivial-clipboard")
               (commit commit)))
         (file-name (git-file-name "trivial-clipboard" version))
         (sha256
          (base32
           "1qfbvkzmvkbqpc5s3sx31c5653sy6qlcixafgzd10qpykb843prr"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("xclip" ,xclip)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "src/text.lisp"
                 (("\\(executable-find \"xclip\"\\)")
                  (string-append "(executable-find \""
                                 (assoc-ref inputs "xclip")
                                 "/bin/xclip\")"))))))))
      (home-page "https://github.com/snmsts/trivial-clipboard")
      (synopsis "Access system clipboard in Common Lisp")
      (description
       "@command{trivial-clipboard} gives access to the system clipboard.")
      (license license:expat))))

(define-public cl-trivial-clipboard
  (sbcl-package->cl-source-package sbcl-trivial-clipboard))

(define-public ecl-trivial-clipboard
  (sbcl-package->ecl-package sbcl-trivial-clipboard))

(define-public sbcl-trivial-backtrace
  (let ((commit "ca81c011b86424a381a7563cea3b924f24e6fbeb")
        (revision "1"))
    (package
     (name "sbcl-trivial-backtrace")
     (version (git-version "0.0.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gwkkwg/trivial-backtrace")
             (commit commit)))
       (file-name (git-file-name "trivial-backtrace" version))
       (sha256
        (base32 "10p41p43skj6cimdg8skjy7372s8v2xpkg8djjy0l8rm45i654k1"))))
     (build-system asdf-build-system/sbcl)
     (inputs
      `(("sbcl-lift" ,sbcl-lift)))
     (arguments
      `(#:phases
        (modify-phases %standard-phases
          (add-after 'check 'delete-test-results
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((test-results (string-append (assoc-ref outputs "out")
                                                 "/share/common-lisp/"
                                                 (%lisp-type)
                                                 "/trivial-backtrace"
                                                 "/test-results")))
                (when (file-exists? test-results)
                  (delete-file-recursively test-results)))
              #t)))))
     (home-page "https://common-lisp.net/project/trivial-backtrace/")
     (synopsis "Portable simple API to work with backtraces in Common Lisp")
     (description
      "One of the many things that didn't quite get into the Common Lisp
standard was how to get a Lisp to output its call stack when something has
gone wrong.  As such, each Lisp has developed its own notion of what to
display, how to display it, and what sort of arguments can be used to
customize it.  @code{trivial-backtrace} is a simple solution to generating a
backtrace portably.")
     (license license:expat))))

(define-public cl-trivial-backtrace
  (sbcl-package->cl-source-package sbcl-trivial-backtrace))

(define-public ecl-trivial-backtrace
  (sbcl-package->ecl-package sbcl-trivial-backtrace))

(define-public sbcl-rfc2388
  (let ((commit "591bcf7e77f2c222c43953a80f8c297751dc0c4e")
        (revision "1"))
    (package
     (name "sbcl-rfc2388")
     (version (git-version "0.0.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jdz/rfc2388")
             (commit commit)))
       (file-name (git-file-name "rfc2388" version))
       (sha256
        (base32 "0phh5n3clhl9ji8jaxrajidn22d3f0aq87mlbfkkxlnx2pnw694k"))))
     (build-system asdf-build-system/sbcl)
     (home-page "https://github.com/jdz/rfc2388/")
     (synopsis "An implementation of RFC 2388 in Common Lisp")
     (description
      "This package contains an implementation of RFC 2388, which is used to
process form data posted with HTTP POST method using enctype
\"multipart/form-data\".")
     (license license:bsd-2))))

(define-public cl-rfc2388
  (sbcl-package->cl-source-package sbcl-rfc2388))

(define-public ecl-rfc2388
  (sbcl-package->ecl-package sbcl-rfc2388))

(define-public sbcl-md5
  (package
    (name "sbcl-md5")
    (version "2.0.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/pmai/md5")
              (commit (string-append "release-" version))))
       (file-name (git-file-name "md5" version))
       (sha256
        (base32 "1waqxzm7vlc22n92hv8r27anlvvjkkh9slhrky1ww7mdx4mmxwb8"))))
    (build-system asdf-build-system/sbcl)
    (home-page "https://github.com/pmai/md5")
    (synopsis
     "Common Lisp implementation of the MD5 Message-Digest Algorithm (RFC 1321)")
    (description
     "This package implements The MD5 Message-Digest Algorithm, as defined in
RFC 1321 by R. Rivest, published April 1992.")
    (license license:public-domain)))

(define-public cl-md5
  (sbcl-package->cl-source-package sbcl-md5))

(define-public ecl-md5
  (package
    (inherit (sbcl-package->ecl-package sbcl-md5))
    (inputs
     `(("flexi-streams" ,ecl-flexi-streams)))))

(define-public sbcl-cl+ssl
  (let ((commit "701e645081e6533a3f0f0b3ac86389d6f506c4b5")
        (revision "1"))
    (package
      (name "sbcl-cl+ssl")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/cl-plus-ssl/cl-plus-ssl")
               (commit commit)))
         (file-name (git-file-name "cl+ssl" version))
         (sha256
          (base32 "0nfl275nwhff3m25872y388cydz14kqb6zbwywa6nj85r9k8bgs0"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "src/reload.lisp"
                 (("libssl.so" all)
                  (string-append
                   (assoc-ref inputs "openssl") "/lib/" all))))))))
      (inputs
       `(("openssl" ,openssl)
         ("sbcl-cffi" ,sbcl-cffi)
         ("sbcl-trivial-gray-streams" ,sbcl-trivial-gray-streams)
         ("sbcl-flexi-streams" ,sbcl-flexi-streams)
         ("sbcl-bordeaux-threads" ,sbcl-bordeaux-threads)
         ("sbcl-trivial-garbage" ,sbcl-trivial-garbage)
         ("sbcl-alexandria" ,sbcl-alexandria)
         ("sbcl-trivial-features" ,sbcl-trivial-features)))
      (home-page "https://common-lisp.net/project/cl-plus-ssl/")
      (synopsis "Common Lisp bindings to OpenSSL")
      (description
       "This library is a fork of SSL-CMUCL.  The original SSL-CMUCL source
code was written by Eric Marsden and includes contributions by Jochen Schmidt.
Development into CL+SSL was done by David Lichteblau.")
      (license license:expat))))

(define-public cl-cl+ssl
  (sbcl-package->cl-source-package sbcl-cl+ssl))

(define-public ecl-cl+ssl
  (sbcl-package->ecl-package sbcl-cl+ssl))

(define-public sbcl-kmrcl
  (let ((version "1.111")
        (commit "4a27407aad9deb607ffb8847630cde3d041ea25a")
        (revision "1"))
    (package
      (name "sbcl-kmrcl")
      (version (git-version version revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "http://git.kpe.io/kmrcl.git/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "06gx04mah5nc8w78s0j8628divbf1s5w7af8w7pvzb2d5mgvrbd2"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("sbcl-rt" ,sbcl-rt)))
      (home-page "http://files.kpe.io/kmrcl/")
      (synopsis "General utilities for Common Lisp programs")
      (description
       "KMRCL is a collection of utilities used by a number of Kevin
Rosenberg's Common Lisp packages.")
      (license license:llgpl))))

(define-public cl-kmrcl
  (sbcl-package->cl-source-package sbcl-kmrcl))

(define-public ecl-kmrcl
  (sbcl-package->ecl-package sbcl-kmrcl))

(define-public sbcl-cl-base64
  ;; 3.3.4 tests are broken, upstream fixes them.
  (let ((commit "577683b18fd880b82274d99fc96a18a710e3987a"))
    (package
      (name "sbcl-cl-base64")
      (version (git-version "3.3.4" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "http://git.kpe.io/cl-base64.git/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "12jj54h0fs6n237cvnp8v6hn0imfksammq22ys6pi0gwz2w47rbj"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs                    ; For tests.
       `(("sbcl-ptester" ,sbcl-ptester)
         ("sbcl-kmrcl" ,sbcl-kmrcl)))
      (home-page "http://files.kpe.io/cl-base64/")
      (synopsis
       "Common Lisp package to encode and decode base64 with URI support")
      (description
       "This package provides highly optimized base64 encoding and decoding.
Besides conversion to and from strings, integer conversions are supported.
Encoding with Uniform Resource Identifiers is supported by using a modified
encoding table that uses only URI-compatible characters.")
      (license license:bsd-3))))

(define-public cl-base64
  (sbcl-package->cl-source-package sbcl-cl-base64))

(define-public ecl-cl-base64
  (sbcl-package->ecl-package sbcl-cl-base64))

(define-public sbcl-chunga
  (package
    (name "sbcl-chunga")
    (version "1.1.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/edicl/chunga")
              (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0jzn3nyb3f22gm983rfk99smqs3mhb9ivjmasvhq9qla5cl9pyhd"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("sbcl-trivial-gray-streams" ,sbcl-trivial-gray-streams)))
    (home-page "https://edicl.github.io/chunga/")
    (synopsis "Portable chunked streams for Common Lisp")
    (description
     "Chunga implements streams capable of chunked encoding on demand as
defined in RFC 2616.")
    (license license:bsd-2)))

(define-public cl-chunga
  (sbcl-package->cl-source-package sbcl-chunga))

(define-public ecl-chunga
  (sbcl-package->ecl-package sbcl-chunga))

(define-public sbcl-cl-who
  (let ((version "1.1.4")
        (commit "2c08caa4bafba720409af9171feeba3f32e86d32")
        (revision "1"))
    (package
      (name "sbcl-cl-who")
      (version (git-version version revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/edicl/cl-who")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0yjb6sr3yazm288m318kqvj9xk8rm9n1lpimgf65ymqv0i5agxsb"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("sbcl-flexi-streams" ,sbcl-flexi-streams)))
      (home-page "https://edicl.github.io/cl-who/")
      (synopsis "Yet another Lisp markup language")
      (description
       "There are plenty of Lisp Markup Languages out there - every Lisp
programmer seems to write at least one during his career - and CL-WHO (where
WHO means \"with-html-output\" for want of a better acronym) is probably just
as good or bad as the next one.")
      (license license:bsd-2))))

(define-public cl-who
  (sbcl-package->cl-source-package sbcl-cl-who))

(define-public ecl-cl-who
  (sbcl-package->ecl-package sbcl-cl-who))

(define-public sbcl-chipz
  (let ((version "0.8")
        (commit "75dfbc660a5a28161c57f115adf74c8a926bfc4d")
        (revision "1"))
    (package
      (name "sbcl-chipz")
      (version (git-version version revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/froydnj/chipz")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0plx4rs39zbs4gjk77h4a2q11zpy75fh9v8hnxrvsf8fnakajhwg"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("sbcl-flexi-streams" ,sbcl-flexi-streams)))
      (home-page "http://method-combination.net/lisp/chipz/")
      (synopsis
       "Common Lisp library for decompressing deflate, zlib, gzip, and bzip2
data")
      (description
       "DEFLATE data, defined in RFC1951, forms the core of popular
compression formats such as zlib (RFC 1950) and gzip (RFC 1952).  As such,
Chipz also provides for decompressing data in those formats as well.  BZIP2 is
the format used by the popular compression tool bzip2.")
      ;; The author describes it as "MIT-like"
      (license license:expat))))

(define-public cl-chipz
  (sbcl-package->cl-source-package sbcl-chipz))

(define-public ecl-chipz
  (sbcl-package->ecl-package sbcl-chipz))

(define-public sbcl-drakma
  (package
    (name "sbcl-drakma")
    (version "2.0.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/edicl/drakma")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1441idnyif9xzx3ln1p3fg36k2v9h4wasjqrzc8y52j61420qpci"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("sbcl-puri" ,sbcl-puri)
       ("sbcl-cl-base64" ,sbcl-cl-base64)
       ("sbcl-chunga" ,sbcl-chunga)
       ("sbcl-flexi-streams" ,sbcl-flexi-streams)
       ("sbcl-cl-ppcre" ,sbcl-cl-ppcre)
       ("sbcl-chipz" ,sbcl-chipz)
       ("sbcl-usocket" ,sbcl-usocket)
       ("sbcl-cl+ssl" ,sbcl-cl+ssl)))
    (native-inputs
     `(("sbcl-fiveam" ,sbcl-fiveam)))
    (home-page "https://edicl.github.io/drakma/")
    (synopsis "HTTP client written in Common Lisp")
    (description
     "Drakma is a full-featured HTTP client implemented in Common Lisp.  It
knows how to handle HTTP/1.1 chunking, persistent connections, re-usable
sockets, SSL, continuable uploads, file uploads, cookies, and more.")
    (license license:bsd-2)))

(define-public cl-drakma
  (sbcl-package->cl-source-package sbcl-drakma))

(define-public ecl-drakma
  (sbcl-package->ecl-package sbcl-drakma))

(define-public sbcl-hunchentoot
  (package
    (name "sbcl-hunchentoot")
    (version "1.2.38")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/edicl/hunchentoot")
             (commit (string-append "v" version))))
       (file-name (git-file-name "hunchentoot" version))
       (sha256
        (base32 "1anpcad7w045m4rsjs1f3xdhjwx5cppq1h0vlb3q7dz81fi3i6yq"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("sbcl-cl-who" ,sbcl-cl-who)
       ("sbcl-drakma" ,sbcl-drakma)))
    (inputs
     `(("sbcl-chunga" ,sbcl-chunga)
       ("sbcl-cl-base64" ,sbcl-cl-base64)
       ("sbcl-cl-fad" ,sbcl-cl-fad)
       ("sbcl-cl-ppcre" ,sbcl-cl-ppcre)
       ("sbcl-flexi-streams" ,sbcl-flexi-streams)
       ("sbcl-cl+ssl" ,sbcl-cl+ssl)
       ("sbcl-md5" ,sbcl-md5)
       ("sbcl-rfc2388" ,sbcl-rfc2388)
       ("sbcl-trivial-backtrace" ,sbcl-trivial-backtrace)
       ("sbcl-usocket" ,sbcl-usocket)))
    (home-page "https://edicl.github.io/hunchentoot/")
    (synopsis "Web server written in Common Lisp")
    (description
     "Hunchentoot is a web server written in Common Lisp and at the same
time a toolkit for building dynamic websites.  As a stand-alone web server,
Hunchentoot is capable of HTTP/1.1 chunking (both directions), persistent
connections (keep-alive), and SSL.")
    (license license:bsd-2)))

(define-public cl-hunchentoot
  (sbcl-package->cl-source-package sbcl-hunchentoot))

(define-public ecl-hunchentoot
  (package
    (inherit (sbcl-package->ecl-package sbcl-hunchentoot))
    (arguments
     ;; Tests fail on ECL with 'Socket error in "socket": EINVAL'.
     '(#:tests? #f))))

(define-public sbcl-trivial-types
  (package
    (name "sbcl-trivial-types")
    (version "0.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/m2ym/trivial-types")
             (commit "ee869f2b7504d8aa9a74403641a5b42b16f47d88")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1s4cp9bdlbn8447q7w7f1wkgwrbvfzp20mgs307l5pxvdslin341"))))
    (build-system asdf-build-system/sbcl)
    (home-page "https://github.com/m2ym/trivial-types")
    (synopsis "Trivial type definitions for Common Lisp")
    (description
     "TRIVIAL-TYPES provides missing but important type definitions such as
PROPER-LIST, ASSOCIATION-LIST, PROPERTY-LIST and TUPLE.")
    (license license:llgpl)))

(define-public cl-trivial-types
  (sbcl-package->cl-source-package sbcl-trivial-types))

(define-public ecl-trivial-types
  (sbcl-package->ecl-package sbcl-trivial-types))

(define-public sbcl-cl-annot
  (let ((commit "c99e69c15d935eabc671b483349a406e0da9518d")
        (revision "1"))
    (package
      (name "sbcl-cl-annot")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/m2ym/cl-annot")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1wq1gs9jjd5m6iwrv06c2d7i5dvqsfjcljgbspfbc93cg5xahk4n"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("sbcl-alexandria" ,sbcl-alexandria)))
      (home-page "https://github.com/m2ym/cl-annot")
      (synopsis "Python-like Annotation Syntax for Common Lisp.")
      (description
       "@code{cl-annot} is an general annotation library for Common Lisp.")
      (license license:llgpl))))

(define-public cl-annot
  (sbcl-package->cl-source-package sbcl-cl-annot))

(define-public ecl-cl-annot
  (sbcl-package->ecl-package sbcl-cl-annot))

(define-public sbcl-cl-syntax
  (package
    (name "sbcl-cl-syntax")
    (version "0.0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/m2ym/cl-syntax")
             (commit "03f0c329bbd55b8622c37161e6278366525e2ccc")))
       (file-name (git-file-name "cl-syntax" version))
       (sha256
        (base32 "17ran8xp77asagl31xv8w819wafh6whwfc9p6dgx22ca537gyl4y"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("cl-annot" ,sbcl-cl-annot)
       ("cl-interpol" ,sbcl-cl-interpol)
       ("named-readtables" ,sbcl-named-readtables)
       ("trivial-types" ,sbcl-trivial-types)))
    (arguments
     '(#:asd-systems '("cl-syntax"
                       "cl-syntax-annot"
                       "cl-syntax-interpol")))
    (home-page "https://github.com/m2ym/cl-syntax")
    (synopsis "Reader Syntax Coventions for Common Lisp and SLIME")
    (description
     "CL-SYNTAX provides Reader Syntax Coventions for Common Lisp and SLIME.")
    (license license:llgpl)))

(define-public cl-syntax
  (sbcl-package->cl-source-package sbcl-cl-syntax))

(define-public ecl-cl-syntax
  (sbcl-package->ecl-package sbcl-cl-syntax))

(define-public sbcl-cl-utilities
  (let ((commit "dce2d2f6387091ea90357a130fa6d13a6776884b")
        (revision "1"))
    (package
      (name "sbcl-cl-utilities")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method url-fetch)
         (uri
          (string-append
           "https://gitlab.common-lisp.net/cl-utilities/cl-utilities/-/"
           "archive/" commit "/cl-utilities-" commit ".tar.gz"))
         (sha256
          (base32 "1r46v730yf96nk2vb24qmagv9x96xvd08abqwhf02ghgydv1a7z2"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "rotate-byte.lisp"
                 (("in-package :cl-utilities)" all)
                  "in-package :cl-utilities)\n\n#+sbcl\n(require :sb-rotate-byte)")))))))
      (home-page "http://common-lisp.net/project/cl-utilities")
      (synopsis "A collection of semi-standard utilities")
      (description
       "On Cliki.net <http://www.cliki.net/Common%20Lisp%20Utilities>, there
is a collection of Common Lisp Utilities, things that everybody writes since
they're not part of the official standard.  There are some very useful things
there; the only problems are that they aren't implemented as well as you'd
like (some aren't implemented at all) and they aren't conveniently packaged
and maintained.  It takes quite a bit of work to carefully implement utilities
for common use, commented and documented, with error checking placed
everywhere some dumb user might make a mistake.")
      (license license:public-domain))))

(define-public cl-utilities
  (sbcl-package->cl-source-package sbcl-cl-utilities))

(define-public ecl-cl-utilities
  (sbcl-package->ecl-package sbcl-cl-utilities))

(define-public sbcl-map-set
  (let ((commit "7b4b545b68b8")
        (revision "1"))
    (package
      (name "sbcl-map-set")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method url-fetch)
         (uri (string-append
               "https://bitbucket.org/tarballs_are_good/map-set/get/"
               commit ".tar.gz"))
         (sha256
          (base32 "1sx5j5qdsy5fklspfammwb16kjrhkggdavm922a9q86jm5l0b239"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://bitbucket.org/tarballs_are_good/map-set")
      (synopsis "Set-like data structure")
      (description
       "Implementation of a set-like data structure with constant time
addition, removal, and random selection.")
      (license license:bsd-3))))

(define-public cl-map-set
  (sbcl-package->cl-source-package sbcl-map-set))

(define-public ecl-map-set
  (sbcl-package->ecl-package sbcl-map-set))

(define-public sbcl-quri
  (let ((commit "b53231c5f19446dd7c24b15a249fefa45ae94f9a")
        (revision "2"))
    (package
      (name "sbcl-quri")
      (version (git-version "0.1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/quri")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0cansr63m690ymvhway419178mq2sqnmxm4rdxclbsrnjwwbi36m"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; Tests fail with: Component QURI-ASD::QURI-TEST not found,
       ;; required by #<SYSTEM "quri">. Why?
       '(#:tests? #f))
      (native-inputs `(("sbcl-prove" ,sbcl-prove)))
      (inputs `(("sbcl-babel" ,sbcl-babel)
                ("sbcl-split-sequence" ,sbcl-split-sequence)
                ("sbcl-cl-utilities" ,sbcl-cl-utilities)
                ("sbcl-alexandria" ,sbcl-alexandria)))
      (home-page "https://github.com/fukamachi/quri")
      (synopsis "Yet another URI library for Common Lisp")
      (description
       "QURI (pronounced \"Q-ree\") is yet another URI library for Common
Lisp. It is intended to be a replacement of PURI.")
      (license license:bsd-3))))

(define-public cl-quri
  (sbcl-package->cl-source-package sbcl-quri))

(define-public ecl-quri
  (sbcl-package->ecl-package sbcl-quri))

(define-public sbcl-myway
  (let ((commit "286230082a11f879c18b93f17ca571c5f676bfb7")
        (revision "1"))
    (package
     (name "sbcl-myway")
     (version (git-version "0.1.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/fukamachi/myway")
             (commit commit)))
       (file-name (git-file-name "myway" version))
       (sha256
        (base32 "0briia9bk3lbr0frnx39d1qg6i38dm4j6z9w3yga3d40k6df4a90"))))
     (build-system asdf-build-system/sbcl)
     (arguments
      ;; Tests fail with: Component MYWAY-ASD::MYWAY-TEST not found, required
      ;; by #<SYSTEM "myway">. Why?
      '(#:tests? #f))
     (native-inputs
      `(("sbcl-prove" ,sbcl-prove)))
     (inputs
      `(("sbcl-cl-ppcre" ,sbcl-cl-ppcre)
        ("sbcl-quri" ,sbcl-quri)
        ("sbcl-map-set" ,sbcl-map-set)))
     (home-page "https://github.com/fukamachi/myway")
     (synopsis "Sinatra-compatible URL routing library for Common Lisp")
     (description "My Way is a Sinatra-compatible URL routing library.")
     (license license:llgpl))))

(define-public cl-myway
  (sbcl-package->cl-source-package sbcl-myway))

(define-public ecl-myway
  (sbcl-package->ecl-package sbcl-myway))

(define-public sbcl-xsubseq
  (let ((commit "5ce430b3da5cda3a73b9cf5cee4df2843034422b")
        (revision "1"))
    (package
     (name "sbcl-xsubseq")
     (version (git-version "0.0.1" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/fukamachi/xsubseq")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1xz79q0p2mclf3sqjiwf6izdpb6xrsr350bv4mlmdlm6rg5r99px"))))
     (build-system asdf-build-system/sbcl)
     (arguments
      ;; Tests fail with: Component XSUBSEQ-ASD::XSUBSEQ-TEST not found,
      ;; required by #<SYSTEM "xsubseq">. Why?
      '(#:tests? #f))
     (native-inputs
      `(("sbcl-prove" ,sbcl-prove)))
     (home-page "https://github.com/fukamachi/xsubseq")
     (synopsis "Efficient way to use \"subseq\"s in Common Lisp")
     (description
      "XSubseq provides functions to be able to handle \"subseq\"s more
effieiently.")
     (license license:bsd-2))))

(define-public cl-xsubseq
  (sbcl-package->cl-source-package sbcl-xsubseq))

(define-public ecl-xsubseq
  (sbcl-package->ecl-package sbcl-xsubseq))

(define-public sbcl-smart-buffer
  (let ((commit "09b9a9a0b3abaa37abe9a730f5aac2643dca4e62")
        (revision "1"))
    (package
      (name "sbcl-smart-buffer")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/smart-buffer")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0qz1zzxx0wm5ff7gpgsq550a59p0qj594zfmm2rglj97dahj54l7"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; Tests fail with: Component SMART-BUFFER-ASD::SMART-BUFFER-TEST not
       ;; found, required by #<SYSTEM "smart-buffer">. Why?
       `(#:tests? #f))
      (native-inputs
       `(("sbcl-prove" ,sbcl-prove)))
      (inputs
       `(("sbcl-xsubseq" ,sbcl-xsubseq)
         ("sbcl-flexi-streams" ,sbcl-flexi-streams)))
      (home-page "https://github.com/fukamachi/smart-buffer")
      (synopsis "Smart octets buffer")
      (description
       "Smart-buffer provides an output buffer which changes the destination
depending on content size.")
      (license license:bsd-3))))

(define-public cl-smart-buffer
  (sbcl-package->cl-source-package sbcl-smart-buffer))

(define-public ecl-smart-buffer
  (sbcl-package->ecl-package sbcl-smart-buffer))

(define-public sbcl-fast-http
  (let ((commit "502a37715dcb8544cc8528b78143a942de662c5a")
        (revision "2"))
    (package
      (name "sbcl-fast-http")
      (version (git-version "0.2.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/fast-http")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0al2g7g219jjljsf7b23pbilpgacxy5as5gs2nqf76b5qni396mi"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; Tests fail with: Component FAST-HTTP-ASD::FAST-HTTP-TEST not found,
       ;; required by #<SYSTEM "fast-http">. Why?
       `(#:tests? #f))
      (native-inputs
       `(("sbcl-prove" ,sbcl-prove)
         ("cl-syntax" ,sbcl-cl-syntax)))
      (inputs
       `(("sbcl-alexandria" ,sbcl-alexandria)
         ("sbcl-proc-parse" ,sbcl-proc-parse)
         ("sbcl-xsubseq" ,sbcl-xsubseq)
         ("sbcl-smart-buffer" ,sbcl-smart-buffer)
         ("sbcl-cl-utilities" ,sbcl-cl-utilities)))
      (home-page "https://github.com/fukamachi/fast-http")
      (synopsis "HTTP request/response parser for Common Lisp")
      (description
       "@code{fast-http} is a HTTP request/response protocol parser for Common
Lisp.")
      ;; Author specified the MIT license
      (license license:expat))))

(define-public cl-fast-http
  (sbcl-package->cl-source-package sbcl-fast-http))

(define-public ecl-fast-http
  (sbcl-package->ecl-package sbcl-fast-http))

(define-public sbcl-static-vectors
  (package
    (name "sbcl-static-vectors")
    (version "1.8.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/sionescu/static-vectors")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0qvf9z6bhwhm8n45fjwkm7j8dcb58szfvndky65cyn4lpdval7m1"))))
    (native-inputs
     `(("sbcl-fiveam" ,sbcl-fiveam)))
    (inputs
     `(("sbcl-cffi" ,sbcl-cffi)))
    (build-system asdf-build-system/sbcl)
    (home-page "https://github.com/sionescu/static-vectors")
    (synopsis "Allocate SIMPLE-ARRAYs in static memory")
    (description
     "With @code{static-vectors}, you can create vectors allocated in static
memory.")
    (license license:expat)))

(define-public cl-static-vectors
  (sbcl-package->cl-source-package sbcl-static-vectors))

(define-public ecl-static-vectors
  (sbcl-package->ecl-package sbcl-static-vectors))

(define-public sbcl-marshal
  (let ((commit "eff1b15f2b0af2f26f71ad6a4dd5c4beab9299ec")
        (revision "1"))
    (package
     (name "sbcl-marshal")
     (version (git-version "1.3.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/wlbr/cl-marshal")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "08qs6fhk38xpkkjkpcj92mxx0lgy4ygrbbzrmnivdx281syr0gwh"))))
     (build-system asdf-build-system/sbcl)
     (home-page "https://github.com/wlbr/cl-marshal")
     (synopsis "Simple (de)serialization of Lisp datastructures")
     (description
      "Simple and fast marshalling of Lisp datastructures.  Convert any object
into a string representation, put it on a stream an revive it from there.
Only minimal changes required to make your CLOS objects serializable.")
     (license license:expat))))

(define-public cl-marshal
  (sbcl-package->cl-source-package sbcl-marshal))

(define-public ecl-marshal
  (sbcl-package->ecl-package sbcl-marshal))

(define-public sbcl-checkl
  (let ((commit "80328800d047fef9b6e32dfe6bdc98396aee3cc9")
        (revision "1"))
    (package
      (name "sbcl-checkl")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/rpav/CheckL")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0bpisihx1gay44xmyr1dmhlwh00j0zzi04rp9fy35i95l2r4xdlx"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; Error while trying to load definition for system checkl-test from
       ;; pathname [...]/checkl-test.asd: The function CHECKL:DEFINE-TEST-OP
       ;; is undefined.
       '(#:asd-files '("checkl.asd")
         #:tests? #f))
      (native-inputs
       `(("sbcl-fiveam" ,sbcl-fiveam)))
      (inputs
       `(("sbcl-marshal" ,sbcl-marshal)))
      (home-page "https://github.com/rpav/CheckL/")
      (synopsis "Dynamic testing for Common Lisp")
      (description
       "CheckL lets you write tests dynamically, it checks resulting values
against the last run.")
      ;; The author specifies both LLGPL and "BSD", but the "BSD" license
      ;; isn't specified anywhere, so I don't know which kind.  LLGPL is the
      ;; stronger of the two and so I think only listing this should suffice.
      (license license:llgpl))))

(define-public cl-checkl
  (sbcl-package->cl-source-package sbcl-checkl))

(define-public ecl-checkl
  (sbcl-package->ecl-package sbcl-checkl))

(define-public sbcl-fast-io
  (let ((commit "603f4903dd74fb221859da7058ae6ca3853fe64b")
        (revision "2"))
    (package
     (name "sbcl-fast-io")
     (version (git-version "1.0.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rpav/fast-io")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "00agvc0xx4w715i6ach05p995zpcpghn04xc06zyci06q677vw3n"))))
     (build-system asdf-build-system/sbcl)
     (arguments
      ;; Error while trying to load definition for system fast-io-test from
      ;; pathname [...]/fast-io-test.asd: The function CHECKL:DEFINE-TEST-OP
      ;; is undefined.
      '(#:tests? #f
        #:asd-files '("fast-io.asd")))
     (native-inputs
      `(("sbcl-fiveam" ,sbcl-fiveam)
        ("sbcl-checkl" ,sbcl-checkl)))
     (inputs
      `(("sbcl-alexandria" ,sbcl-alexandria)
        ("sbcl-trivial-gray-streams" ,sbcl-trivial-gray-streams)
        ("sbcl-static-vectors" ,sbcl-static-vectors)))
     (home-page "https://github.com/rpav/fast-io")
     (synopsis "Fast octet-vector/stream I/O for Common Lisp")
     (description
      "Fast-io is about improving performance to octet-vectors and octet
streams (though primarily the former, while wrapping the latter).")
     ;; Author specifies this as NewBSD which is an alias
     (license license:bsd-3))))

(define-public cl-fast-io
  (sbcl-package->cl-source-package sbcl-fast-io))

(define-public ecl-fast-io
  (sbcl-package->ecl-package sbcl-fast-io))

(define-public sbcl-jonathan
  (let ((commit "1f448b4f7ac8265e56e1c02b32ce383e65316300")
        (revision "1"))
    (package
     (name "sbcl-jonathan")
     (version (git-version "0.1.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Rudolph-Miller/jonathan")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "14x4iwz3mbag5jzzzr4sb6ai0m9r4q4kyypbq32jmsk2dx1hi807"))))
     (build-system asdf-build-system/sbcl)
     (arguments
      ;; Tests fail with: Component JONATHAN-ASD::JONATHAN-TEST not found,
      ;; required by #<SYSTEM "jonathan">. Why?
      `(#:tests? #f))
     (native-inputs
      `(("sbcl-prove" ,sbcl-prove)))
     (inputs
      `(("sbcl-cl-syntax" ,sbcl-cl-syntax)
        ("sbcl-fast-io" ,sbcl-fast-io)
        ("sbcl-proc-parse" ,sbcl-proc-parse)
        ("sbcl-cl-ppcre" ,sbcl-cl-ppcre)))
     (home-page "https://rudolph-miller.github.io/jonathan/overview.html")
     (synopsis "JSON encoder and decoder")
     (description
      "High performance JSON encoder and decoder.  Currently support: SBCL,
CCL.")
     ;; Author specifies the MIT license
     (license license:expat))))

(define-public cl-jonathan
  (sbcl-package->cl-source-package sbcl-jonathan))

(define-public ecl-jonathan
  (sbcl-package->ecl-package sbcl-jonathan))

(define-public sbcl-http-body
  (let ((commit "dd01dc4f5842e3d29728552e5163acce8386eb73")
        (revision "1"))
    (package
     (name "sbcl-http-body")
     (version (git-version "0.1.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/fukamachi/http-body")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1jd06snjvxcprhapgfq8sx0y5lrldkvhf206ix6d5a23dd6zcmr0"))))
     (build-system asdf-build-system/sbcl)
     (arguments
      ;; Tests fail with: Component HTTP-BODY-ASD::HTTP-BODY-TEST not
      ;; found, required by #<SYSTEM "http-body">. Why?
      `(#:tests? #f))
     (native-inputs
      `(("sbcl-prove" ,sbcl-prove)))
     (inputs
      `(("sbcl-fast-http" ,sbcl-fast-http)
        ("sbcl-jonathan" ,sbcl-jonathan)
        ("sbcl-quri" ,sbcl-quri)))
     (home-page "https://github.com/fukamachi/http-body")
     (synopsis "HTTP POST data parser")
     (description
      "HTTP-Body parses HTTP POST data and returns POST parameters.  It
supports application/x-www-form-urlencoded, application/json, and
multipart/form-data.")
     (license license:bsd-2))))

(define-public cl-http-body
  (sbcl-package->cl-source-package sbcl-http-body))

(define-public ecl-http-body
  (sbcl-package->ecl-package sbcl-http-body))

(define-public sbcl-circular-streams
  (let ((commit "e770bade1919c5e8533dd2078c93c3d3bbeb38df")
        (revision "1"))
    (package
     (name "sbcl-circular-streams")
     (version (git-version "0.1.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/fukamachi/circular-streams")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wpw6d5cciyqcf92f7mvihak52pd5s47kk4qq6f0r2z2as68p5rs"))))
     (build-system asdf-build-system/sbcl)
     (arguments
      ;; The tests depend on cl-test-more which is now prove. Prove
      ;; tests aren't working for some reason.
      `(#:tests? #f))
     (inputs
      `(("sbcl-fast-io" ,sbcl-fast-io)
        ("sbcl-trivial-gray-streams" ,sbcl-trivial-gray-streams)))
     (home-page "https://github.com/fukamachi/circular-streams")
     (synopsis "Circularly readable streams for Common Lisp")
     (description
      "Circular-Streams allows you to read streams circularly by wrapping real
streams. Once you reach end-of-file of a stream, it's file position will be
reset to 0 and you're able to read it again.")
     (license license:llgpl))))

(define-public cl-circular-streams
  (sbcl-package->cl-source-package sbcl-circular-streams))

(define-public ecl-circular-streams
  (sbcl-package->ecl-package sbcl-circular-streams))

(define-public sbcl-lack
  (let ((commit "abff8efeb0c3a848e6bb0022f2b8b7fa3a1bc88b")
        (revision "1"))
    (package
      (name "sbcl-lack")
      (version (git-version "0.1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/lack")
               (commit commit)))
         (file-name (git-file-name "lack" version))
         (sha256
          (base32 "1avh4ygcj9xcx4m17nj0wnxxaisk26w4ljs2bibzxaln24x7pi85"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (inputs
       `(("circular-streams" ,sbcl-circular-streams)
         ("http-body" ,sbcl-http-body)
         ("ironclad" ,sbcl-ironclad)
         ("local-time" ,sbcl-local-time)
         ("quri" ,sbcl-quri)
         ("trivial-mimes" ,sbcl-trivial-mimes)))
      (arguments
       '(#:asd-systems '("lack"
                         "lack-request"
                         "lack-response"
                         "lack-component"
                         "lack-util"
                         "lack-middleware-backtrace"
                         "lack-middleware-static")
         #:test-asd-file "t-lack.asd"
         ;; XXX: Component :CLACK not found
         #:tests? #f))
      (home-page "https://github.com/fukamachi/lack")
      (synopsis "Lack, the core of Clack")
      (description
       "Lack is a Common Lisp library which allows web applications to be
constructed of modular components.  It was originally a part of Clack, however
it's going to be rewritten as an individual project since Clack v2 with
performance and simplicity in mind.")
      (license license:llgpl))))

(define-public cl-lack
  (sbcl-package->cl-source-package sbcl-lack))

(define-public ecl-lack
  (sbcl-package->ecl-package sbcl-lack))

(define-public sbcl-local-time
  (let ((commit "62792705245168d3fc2e04164b9a143477284142")
        (revision "1"))
    (package
     (name "sbcl-local-time")
     (version (git-version "1.0.6" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/dlowe-net/local-time")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1r5zq4l1lrgprdr2pw7wwry194yknnllyjf6lx7snypb3k4r3yir"))))
     (build-system asdf-build-system/sbcl)
     (arguments
      ;; TODO: Component :STEFIL not found, required by #<SYSTEM
      ;; "local-time/test">
      '(#:tests? #f))
     (native-inputs
      `(("stefil" ,sbcl-hu.dwim.stefil)))
     (inputs
      `(("sbcl-cl-fad" ,sbcl-cl-fad)))
     (home-page "https://common-lisp.net/project/local-time/")
     (synopsis "Time manipulation library for Common Lisp")
     (description
      "The LOCAL-TIME library is a Common Lisp library for the manipulation of
dates and times.  It is based almost entirely upon Erik Naggum's paper \"The
Long Painful History of Time\".")
     (license license:expat))))

(define-public cl-local-time
  (sbcl-package->cl-source-package sbcl-local-time))

(define-public ecl-local-time
  (sbcl-package->ecl-package sbcl-local-time))

(define-public sbcl-trivial-mimes
  (let ((commit "303f8ac0aa6ca0bc139aa3c34822e623c3723fab")
        (revision "1"))
    (package
      (name "sbcl-trivial-mimes")
      (version (git-version "1.1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Shinmera/trivial-mimes")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "17jxgl47r695bvsb7wi3n2ws5rp1zzgvw0zii8cy5ggw4b4ayv6m"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("stefil" ,sbcl-hu.dwim.stefil)))
      (inputs
       `(("sbcl-cl-fad" ,sbcl-cl-fad)))
      (home-page "https://shinmera.github.io/trivial-mimes/")
      (synopsis "Tiny Common Lisp library to detect mime types in files")
      (description
       "This is a teensy library that provides some functions to determine the
mime-type of a file.")
      (license license:artistic2.0))))

(define-public cl-trivial-mimes
  (sbcl-package->cl-source-package sbcl-trivial-mimes))

(define-public ecl-trivial-mimes
  (sbcl-package->ecl-package sbcl-trivial-mimes))

(define-public sbcl-ningle
  (let ((commit "50bd4f09b5a03a7249bd4d78265d6451563b25ad")
        (revision "1"))
    (package
      (name "sbcl-ningle")
      (version (git-version "0.3.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/ningle")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1bsl8cnxhacb8p92z9n89vhk1ikmij5zavk0m2zvmj7iqm79jzgw"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; TODO: pull in clack-test
       '(#:tests? #f
         #:phases
         (modify-phases %standard-phases
           (delete 'cleanup-files)
           (delete 'cleanup)
           (add-before 'cleanup 'combine-fasls
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (lib (string-append out "/lib/sbcl"))
                      (ningle-path (string-append lib "/ningle"))
                      (fasl-files (find-files out "\\.fasl$")))
                 (mkdir-p ningle-path)
                 (let ((fasl-path (lambda (name)
                                    (string-append ningle-path
                                                   "/"
                                                   (basename name)
                                                   "--system.fasl"))))
                   (for-each (lambda (file)
                               (rename-file file
                                            (fasl-path
                                             (basename file ".fasl"))))
                             fasl-files))
                 fasl-files)
               #t)))))
      (native-inputs
       `(("sbcl-prove" ,sbcl-prove)))
      (inputs
       `(("sbcl-cl-syntax" ,sbcl-cl-syntax)
         ("sbcl-myway" ,sbcl-myway)
         ("sbcl-lack" ,sbcl-lack)
         ("sbcl-alexandria" ,sbcl-alexandria)
         ("sbcl-babel" ,sbcl-babel)))
      (home-page "https://8arrow.org/ningle/")
      (synopsis "Super micro framework for Common Lisp")
      (description
       "Ningle is a lightweight web application framework for Common Lisp.")
      (license license:llgpl))))

(define-public cl-ningle
  (sbcl-package->cl-source-package sbcl-ningle))

(define-public ecl-ningle
  (sbcl-package->ecl-package sbcl-ningle))

(define-public sbcl-cl-fastcgi
  (let ((commit "d576d20eeb12f225201074b28934ba395b15781a")
        (revision "1"))
    (package
      (name "sbcl-cl-fastcgi")
      (version (git-version "0.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/KDr2/cl-fastcgi/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "02mvzzyn0k960s38rbxaqqmdkwcfmyhf8dx6ynz8xyxflmp0s5zv"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("usocket" ,sbcl-usocket)
         ("cffi" ,sbcl-cffi)
         ("fcgi" ,fcgi)))
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "cl-fastcgi.lisp"
                 (("\"libfcgi.so\"")
                  (string-append
                   "\""
                   (assoc-ref inputs "fcgi") "/lib/libfcgi.so\""))))))))
      (home-page "https://kdr2.com/project/cl-fastcgi.html")
      (synopsis "FastCGI wrapper for Common Lisp")
      (description
       "CL-FastCGI is a generic version of SB-FastCGI, targeting to run on
mostly Common Lisp implementation.")
      ;; TODO: Upstream on specifies "BSD license":
      ;; https://github.com/KDr2/cl-fastcgi/issues/4
      (license license:bsd-2))))

(define-public cl-fastcgi
  (sbcl-package->cl-source-package sbcl-cl-fastcgi))

(define-public ecl-cl-fastcgi
  (sbcl-package->ecl-package sbcl-cl-fastcgi))

(define-public sbcl-clack
  (let ((commit "e3e032843bb1220ab96263c411aa7f2feb4746e0")
        (revision "1"))
    (package
      (name "sbcl-clack")
      (version (git-version "2.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/clack")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1ymzs6qyrwhlj6cgqsnpyn6g5cbp7a3s1vgxwna20y2q7y4iacy0"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("cl-fastcgi" ,sbcl-cl-fastcgi)
         ("flexi-streams" ,sbcl-flexi-streams)
         ("hunchentoot" ,sbcl-hunchentoot)
         ("lack" ,sbcl-lack)
         ("split-sequence" ,sbcl-split-sequence)
         ("usocket" ,sbcl-usocket)
         ("quri" ,sbcl-quri)))
      (arguments
       '(#:asd-systems '("clack"
                         "clack-handler-fcgi"
                         "clack-socket"
                         "clack-handler-hunchentoot")))
      (home-page "https://github.com/fukamachi/clack")
      (synopsis "Web Application Environment for Common Lisp")
      (description
       "Clack is a web application environment for Common Lisp inspired by
Python's WSGI and Ruby's Rack.")
      (license license:llgpl))))

(define-public cl-clack
  (sbcl-package->cl-source-package sbcl-clack))

(define-public ecl-clack
  (sbcl-package->ecl-package sbcl-clack))

(define-public sbcl-cl-log
  (let ((commit "8f4b766d51e02245c310526cf1e4534ce634f837")
        (revision "1"))
    (package
     (name "sbcl-cl-log")
     (version "1.0.1")
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nicklevine/cl-log")
             (commit commit)))
       (sha256
        (base32 "1r3z9swy1b59swvaa5b97is9ysrfmjvjjhhw56p7p5hqg93b92ak"))
       (file-name (git-file-name "cl-log" version))))
     (build-system asdf-build-system/sbcl)
     (synopsis "Common Lisp general purpose logging utility")
     (description "CL-LOG is a general purpose logging utility, loosely modelled
in some respects after Gary King's Log5.  Its features include: logging to
several destinations at once, via \"messengers\", each messenger is tailored to
accept some log messages and reject others, and this tailoring can be changed
on-the-fly, very rapid processing of messages which are rejected by all
messengers, fully independent use of the utility by several different
sub-systems in an application, support for messengers which cl:format text to a
stream, support for messengers which do not invoke cl:format, timestamps in
theory accurate to internal-time-units-per-second.")
     (home-page "https://github.com/nicklevine/cl-log")
     (license license:expat))))

(define-public cl-log
  (sbcl-package->cl-source-package sbcl-cl-log))

(define-public ecl-cl-log
  (sbcl-package->ecl-package sbcl-cl-log))

(define-public sbcl-log4cl
  (let ((commit "611e094458504b938d49de904eab141285328c7c")
        (revision "1"))
    (package
      (name "sbcl-log4cl")
      (build-system asdf-build-system/sbcl)
      (version "1.1.2")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/sharplispers/log4cl")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "08jly0s0g26b56hhpfizxsb4j0yvbh946sd205gr42dkzv8l7dsc"))))
      ;; FIXME: tests require stefil, sbcl-hu.dwim.stefil wont work
      (arguments
       `(#:tests? #f))
      (inputs `(("bordeaux-threads" ,sbcl-bordeaux-threads)))
      (synopsis "Common Lisp logging framework, modeled after Log4J")
      (home-page "https://github.com/7max/log4cl")
      (description "This is a Common Lisp logging framework that can log at
various levels and mix text with expressions.")
      (license license:asl2.0))))

(define-public cl-log4cl
  (sbcl-package->cl-source-package sbcl-log4cl))

(define-public ecl-log4cl
  (sbcl-package->ecl-package sbcl-log4cl))

(define-public sbcl-find-port
  (let ((commit "00c96a25af93a0f8681d34ec548861f2d7485478")
        (revision "1"))
    (package
      (name "sbcl-find-port")
      (build-system asdf-build-system/sbcl)
      (version "0.1")
      (home-page "https://github.com/eudoxia0/find-port")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0d6dzbb45jh0rx90wgs6v020k2xa87mvzas3mvfzvivjvqqlpryq"))))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("sbcl-usocket" ,sbcl-usocket)))
      (synopsis "Find open ports programmatically in Common Lisp")
      (description "This is a small Common Lisp library that finds an open
port within a range.")
      (license license:expat))))

(define-public cl-find-port
  (sbcl-package->cl-source-package sbcl-find-port))

(define-public ecl-find-port
  (sbcl-package->ecl-package sbcl-find-port))

(define-public sbcl-clunit
  (let ((commit "6f6d72873f0e1207f037470105969384f8380628")
        (revision "1"))
    (package
      (name "sbcl-clunit")
      (version (git-version "0.2.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/tgutu/clunit")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1idf2xnqzlhi8rbrqmzpmb3i1l6pbdzhhajkmhwbp6qjkmxa4h85"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "CLUnit is a Common Lisp unit testing framework")
      (description
       "CLUnit is a Common Lisp unit testing framework.  It is designed
to be easy to use so that you can quickly start testing.  CLUnit
provides a rich set of features aimed at improving your unit testing
experience.")
      (home-page "https://tgutu.github.io/clunit/")
      ;; MIT License
      (license license:expat))))

(define-public cl-clunit
  (sbcl-package->cl-source-package sbcl-clunit))

(define-public ecl-clunit
  (sbcl-package->ecl-package sbcl-clunit))

(define-public sbcl-py4cl
  (let ((commit "4c8a2b0814fd311f978964f825ce012290f60136")
        (revision "1"))
    (package
      (name "sbcl-py4cl")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/bendudson/py4cl")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "15mk7qdqjkj56gdnbyrdyz6r7m1h26ldvn6ch96pmvg5vmr1m45r"))
         (modules '((guix build utils)))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("sbcl-clunit" ,sbcl-clunit)))
      (inputs
       `(("sbcl-trivial-garbage" ,sbcl-trivial-garbage)))
      (propagated-inputs
       ;; This package doesn't do anything without python available
       `(("python" ,python)
         ;; For multi-dimensional array support
         ("python-numpy" ,python-numpy)))
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'replace-*base-directory*-var
             (lambda* (#:key outputs #:allow-other-keys)
               ;; In the ASD, the author makes an attempt to
               ;; programatically determine the location of the
               ;; source-code so lisp can call into "py4cl.py". We can
               ;; hard-code this since we know where this file will
               ;; reside.
               (substitute* "src/callpython.lisp"
                 (("py4cl/config:\\*base-directory\\*")
                  (string-append
                   "\""
                   (assoc-ref outputs "out")
                   "/share/common-lisp/sbcl-source/py4cl/"
                   "\""))))))))
      (synopsis "Call python from Common Lisp")
      (description
       "Py4CL is a bridge between Common Lisp and Python, which enables Common
Lisp to interact with Python code.  It uses streams to communicate with a
separate python process, the approach taken by cl4py.  This is different to
the CFFI approach used by burgled-batteries, but has the same goal.")
      (home-page "https://github.com/bendudson/py4cl")
      ;; MIT License
      (license license:expat))))

(define-public cl-py4cl
  (sbcl-package->cl-source-package sbcl-py4cl))

(define-public ecl-py4cl
  (sbcl-package->ecl-package sbcl-py4cl))

(define-public sbcl-parse-declarations
  (let ((commit "549aebbfb9403a7fe948654126b9c814f443f4f2")
        (revision "1"))
    (package
      (name "sbcl-parse-declarations")
      (version (git-version "1.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url (string-append
                     "https://gitlab.common-lisp.net/parse-declarations/"
                     "parse-declarations.git"))
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "03g5qks4c59nmxa48pbslxkfh77h8hn8566jddp6m9pl15dzzpxd"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       `(#:asd-systems '("parse-declarations-1.0")))
      (home-page "https://common-lisp.net/project/parse-declarations/")
      (synopsis "Parse, filter, and build declarations")
      (description
       "Parse-Declarations is a Common Lisp library to help writing
macros which establish bindings.  To be semantically correct, such
macros must take user declarations into account, as these may affect
the bindings they establish.  Yet the ANSI standard of Common Lisp does
not provide any operators to work with declarations in a convenient,
high-level way.  This library provides such operators.")
      ;; MIT License
      (license license:expat))))

(define-public cl-parse-declarations
  (sbcl-package->cl-source-package sbcl-parse-declarations))

(define-public ecl-parse-declarations
  (sbcl-package->ecl-package sbcl-parse-declarations))

(define-public sbcl-cl-quickcheck
  (let ((commit "807b2792a30c883a2fbecea8e7db355b50ba662f")
        (revision "1"))
    (package
      (name "sbcl-cl-quickcheck")
      (version (git-version "0.0.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/mcandre/cl-quickcheck")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "165lhypq5xkcys6hvzb3jq7ywnmqvzaflda29qk2cbs3ggas4767"))))
      (build-system asdf-build-system/sbcl)
      (synopsis
       "Common Lisp port of the QuickCheck unit test framework")
      (description
       "Common Lisp port of the QuickCheck unit test framework")
      (home-page "https://github.com/mcandre/cl-quickcheck")
      ;; MIT
      (license license:expat))))

(define-public cl-quickcheck
  (sbcl-package->cl-source-package sbcl-cl-quickcheck))

(define-public ecl-cl-quickcheck
  (sbcl-package->ecl-package sbcl-cl-quickcheck))

(define-public sbcl-burgled-batteries3
  (let ((commit "f65f454d13bb6c40e17e9ec62e41eb5069e09760")
        (revision "2"))
    (package
      (name "sbcl-burgled-batteries3")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/snmsts/burgled-batteries3")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1nzn7jawrfajyzwfnzrg2cmn9xxadcqh4szbpg0jggkhdkdzz4wa"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       `(#:tests? #f
         #:modules (((guix build python-build-system) #:select (python-version))
                    ,@%asdf-build-system-modules)
         #:imported-modules ((guix build python-build-system)
                             ,@%asdf-build-system-modules)
         #:phases
         (modify-phases (@ (guix build asdf-build-system) %standard-phases)
           (add-after 'unpack 'set-*cpython-include-dir*-var
             (lambda* (#:key inputs #:allow-other-keys)
               (let ((python (assoc-ref inputs "python")))
                 (setenv "BB_PYTHON3_INCLUDE_DIR"
                         (string-append python "/include/python"
                                        (python-version python)))
                 (setenv "BB_PYTHON3_DYLIB"
                         (string-append python "/lib/libpython3.so"))
                 #t)))
           (add-after 'unpack 'adjust-for-python-3.8
             (lambda _
               ;; This method is no longer part of the public API.
               (substitute* "ffi-interface.lisp"
                 ((".*PyEval_ReInitThreads.*")
                  ""))
               #t)))))
      (native-inputs
       `(("sbcl-cl-fad" ,sbcl-cl-fad)
         ("sbcl-lift" ,sbcl-lift)
         ("sbcl-cl-quickcheck" ,sbcl-cl-quickcheck)))
      (inputs
       `(("python" ,python)
         ("sbcl-cffi" ,sbcl-cffi)
         ("sbcl-alexandria" , sbcl-alexandria)
         ("sbcl-parse-declarations-1.0" ,sbcl-parse-declarations)
         ("sbcl-trivial-garbage" ,sbcl-trivial-garbage)))
      (synopsis "Bridge between Python and Lisp (FFI bindings, etc.)")
      (description
       "This package provides a shim between Python3 (specifically, the
CPython implementation of Python) and Common Lisp.")
      (home-page "https://github.com/snmsts/burgled-batteries3")
      (license license:expat))))

(define-public cl-burgled-batteries3
  (sbcl-package->cl-source-package sbcl-burgled-batteries3))

(define-public ecl-burgled-batteries3
  (sbcl-package->ecl-package sbcl-burgled-batteries3))

(define-public sbcl-metabang-bind
  (let ((commit "c93b7f7e1c18c954c2283efd6a7fdab36746ab5e")
        (revision "1"))
    (package
      (name "sbcl-metabang-bind")
      (version (git-version "0.8.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/gwkkwg/metabang-bind")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0hd0kr91795v77akpbcyqiss9p0p7ypa9dznrllincnmgvsxlmf0"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("sbcl-lift" ,sbcl-lift)))
      (synopsis "Macro that generalizes @code{multiple-value-bind} etc.")
      (description
       "Bind extends the idea of of let and destructing to provide a uniform
syntax for all your accessor needs.  It combines @code{let},
@code{destructuring-bind}, @code{with-slots}, @code{with-accessors}, structure
editing, property or association-lists, and @code{multiple-value-bind} and a
whole lot more into a single form.")
      (home-page "https://common-lisp.net/project/metabang-bind/")
      ;; MIT License
      (license license:expat))))

(define-public cl-metabang-bind
  (sbcl-package->cl-source-package sbcl-metabang-bind))

(define-public ecl-metabang-bind
  (sbcl-package->ecl-package sbcl-metabang-bind))

(define-public sbcl-fare-utils
  (let ((commit "66e9c6f1499140bc00ccc22febf2aa528cbb5724")
        (revision "1"))
    (package
      (name "sbcl-fare-utils")
      (version (git-version "1.0.0.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url
            "https://gitlab.common-lisp.net/frideau/fare-utils.git")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "01wsr1aap3jdzhn4hrqjbhsjx6qci9dbd3gh4gayv1p49rbg8aqr"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       `(#:test-asd-file "test/fare-utils-test.asd"))
      (native-inputs
       `(("sbcl-hu.dwim.stefil" ,sbcl-hu.dwim.stefil)))
      (synopsis "Collection of utilities and data structures")
      (description
       "fare-utils is a small collection of utilities.  It contains a lot of
basic everyday functions and macros.")
      (home-page "https://gitlab.common-lisp.net/frideau/fare-utils")
      ;; MIT License
      (license license:expat))))

(define-public cl-fare-utils
  (sbcl-package->cl-source-package sbcl-fare-utils))

(define-public ecl-fare-utils
  (sbcl-package->ecl-package sbcl-fare-utils))

(define-public sbcl-trivial-utf-8
  (let ((commit "4d427cfbb1c452436a0efb71c3205c9da67f718f")
        (revision "1"))
    (package
      (name "sbcl-trivial-utf-8")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url (string-append "https://gitlab.common-lisp.net/"
                               "trivial-utf-8/trivial-utf-8.git"))
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1jz27gz8gvqdmvp3k9bxschs6d5b3qgk94qp2bj6nv1d0jc3m1l1"))))
      (arguments
       ;; Guix incorrectly assumes the "8" is part of the version
       ;; number and lobs it off.
       `(#:asd-systems '("trivial-utf-8")))
      (build-system asdf-build-system/sbcl)
      (synopsis "UTF-8 input/output library")
      (description
       "The Babel library solves a similar problem while understanding more
encodings.  Trivial UTF-8 was written before Babel existed, but for new
projects you might be better off going with Babel.  The one plus that Trivial
UTF-8 has is that it doesn't depend on any other libraries.")
      (home-page "https://common-lisp.net/project/trivial-utf-8/")
      (license license:bsd-3))))

(define-public cl-trivial-utf-8
  (sbcl-package->cl-source-package sbcl-trivial-utf-8))

(define-public ecl-trivial-utf-8
  (sbcl-package->ecl-package sbcl-trivial-utf-8))

(define-public sbcl-idna
  (package
    (name "sbcl-idna")
    (build-system asdf-build-system/sbcl)
    (version "0.2.2")
    (home-page "https://github.com/antifuchs/idna")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "00nbr3mffxhlq14gg9d16pa6691s4qh35inyw76v906s77khm5a2"))))
    (inputs
     `(("split-sequence" ,sbcl-split-sequence)))
    (synopsis "IDNA string encoding and decoding routines for Common Lisp")
    (description "This Common Lisp library provides string encoding and
decoding routines for IDNA, the International Domain Names in Applications.")
    (license license:expat)))

(define-public cl-idna
  (sbcl-package->cl-source-package sbcl-idna))

(define-public ecl-idna
  (sbcl-package->ecl-package sbcl-idna))

(define-public sbcl-swap-bytes
  (package
    (name "sbcl-swap-bytes")
    (build-system asdf-build-system/sbcl)
    (version "1.2")
    (home-page "https://github.com/sionescu/swap-bytes")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1hw1v1lw26rifyznpnj1csphha9jgzwpiic16ni3pvs6hcsni9rz"))))
    (inputs
     `(("trivial-features" ,sbcl-trivial-features)))
    (native-inputs
     `(("fiveam" ,sbcl-fiveam)))
    (synopsis "Efficient endianness conversion for Common Lisp")
    (description "This Common Lisp library provides optimized byte-swapping
primitives.  The library can change endianness of unsigned integers of length
1/2/4/8.  Very useful in implementing various network protocols and file
formats.")
    (license license:expat)))

(define-public cl-swap-bytes
  (sbcl-package->cl-source-package sbcl-swap-bytes))

(define-public ecl-swap-bytes
  (sbcl-package->ecl-package sbcl-swap-bytes))

(define-public sbcl-iolib
  ;; Latest release is from June 2017.
  (let ((commit "7f5ea3a8457a29d224b24653c2b3657fb1898021")
        (revision "2"))
    (package
      (name "sbcl-iolib")
      (version (git-version "0.8.3" revision commit))
      (home-page "https://github.com/sionescu/iolib")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1bg5w7lm61hqk4b0svmri8a590q36z76jfa0sdgzb39r98c04w12"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("cffi" ,sbcl-cffi)
         ("idna" ,sbcl-idna)
         ("libfixposix" ,libfixposix)
         ("split-sequence" ,sbcl-split-sequence)
         ("swap-bytes" ,sbcl-swap-bytes)))
      (arguments
       '(#:asd-files '("iolib.asdf.asd"
                       "iolib.conf.asd"
                       "iolib.common-lisp.asd"
                       "iolib.base.asd"
                       "iolib.asd")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "src/syscalls/ffi-functions-unix.lisp"
                 (("\\(:default \"libfixposix\"\\)")
                  (string-append
                   "(:default \""
                   (assoc-ref inputs "libfixposix") "/lib/libfixposix\")")))
               ;; Socket tests need Internet access, disable them.
               (substitute* "iolib.asd"
                 (("\\(:file \"sockets\" :depends-on \\(\"pkgdcl\" \"defsuites\"\\)\\)")
                  "")))))))
      (synopsis "Common Lisp I/O library")
      (description "IOlib is to be a better and more modern I/O library than
the standard Common Lisp library.  It contains a socket library, a DNS
resolver, an I/O multiplexer(which supports @code{select(2)}, @code{epoll(4)}
and @code{kqueue(2)}), a pathname library and file-system utilities.")
      (license license:expat))))

(define-public cl-iolib
  (let ((parent (sbcl-package->cl-source-package sbcl-iolib)))
    (package
      (inherit parent)
      (propagated-inputs
       ;; Need header to compile.
       `(("libfixposix" ,libfixposix)
         ,@(package-propagated-inputs parent))))))

(define-public ecl-iolib
  (sbcl-package->ecl-package sbcl-iolib))

(define-public sbcl-ieee-floats
  (let ((commit "566b51a005e81ff618554b9b2f0b795d3b29398d")
        (revision "1"))
    (package
      (name "sbcl-ieee-floats")
      (build-system asdf-build-system/sbcl)
      (version (git-version "20170924" revision commit))
      (home-page "https://github.com/marijnh/ieee-floats/")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1xyj49j9x3lc84cv3dhbf9ja34ywjk1c46dklx425fxw9mkwm83m"))))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (synopsis "IEEE 754 binary representation for floats in Common Lisp")
      (description "This is a Common Lisp library that converts
floating point values to IEEE 754 binary representation.")
      (license license:bsd-3))))

(define-public cl-ieee-floats
  (sbcl-package->cl-source-package sbcl-ieee-floats))

(define-public ecl-ieee-floats
  (sbcl-package->ecl-package sbcl-ieee-floats))

(define sbcl-closure-common
  (let ((commit "e3c5f5f454b72b01b89115e581c3c52a7e201e5c")
        (revision "1"))
    (package
      (name "sbcl-closure-common")
      (build-system asdf-build-system/sbcl)
      (version (git-version "20101006" revision commit))
      (home-page "https://common-lisp.net/project/cxml/")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/sharplispers/closure-common")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0k5r2qxn122pxi301ijir3nayi9sg4d7yiy276l36qmzwhp4mg5n"))))
      (inputs
       `(("trivial-gray-streams" ,sbcl-trivial-gray-streams)
         ("babel" ,sbcl-babel)))
      (synopsis "Support Common Lisp library for CXML")
      (description "Closure-common is an internal helper library.  The name
Closure is a reference to the web browser it was originally written for.")
      ;; TODO: License?
      (license #f))))

(define-public sbcl-cxml
  (let ((commit "00b22bf4c4cf11c993d5866fae284f95ab18e6bf")
        (revision "1"))
    (package
      (name "sbcl-cxml")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/sharplispers/cxml")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "13kif7rf3gqdycsk9zq0d7y0g9y81krkl0z87k0p2fkbjfgrph37"))))
      (build-system asdf-build-system/sbcl)
    (inputs
     `(("closure-common" ,sbcl-closure-common)
       ("puri" ,sbcl-puri)
       ("trivial-gray-streams" ,sbcl-trivial-gray-streams)))
    (synopsis "Common Lisp XML parser")
    (description "CXML implements a namespace-aware, validating XML 1.0
parser as well as the DOM Level 2 Core interfaces.  Two parser interfaces are
offered, one SAX-like, the other similar to StAX.")
    (home-page "https://common-lisp.net/project/cxml/")
    (license license:llgpl))))

(define-public cl-cxml
  (sbcl-package->cl-source-package sbcl-cxml))

(define-public ecl-cxml
  (sbcl-package->ecl-package sbcl-cxml))

(define-public sbcl-cl-reexport
  (let ((commit "312f3661bbe187b5f28536cd7ec2956e91366c3b")
        (revision "1"))
    (package
      (name "sbcl-cl-reexport")
      (build-system asdf-build-system/sbcl)
      (version (git-version "0.1" revision commit))
      (home-page "https://github.com/takagi/cl-reexport")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1cwpn1m3wrl0fl9plznn7p464db646gnfc8zkyk97dyxski2aq0x"))))
      (inputs
       `(("alexandria" ,sbcl-alexandria)))
      (arguments
       ;; TODO: Tests fail because cl-test-more is missing, but I can't find it online.
       `(#:tests? #f))
      (synopsis "HTTP cookie manager for Common Lisp")
      (description "cl-cookie is a Common Lisp library featuring parsing of
cookie headers, cookie creation, cookie jar creation and more.")
      (license license:llgpl))))

(define-public cl-reexport
  (sbcl-package->cl-source-package sbcl-cl-reexport))

(define-public ecl-cl-reexport
  (sbcl-package->ecl-package sbcl-cl-reexport))

(define-public sbcl-cl-cookie
  (let ((commit "cea55aed8b9ad25fafd13defbcb9fe8f41b29546")
        (revision "1"))
    (package
      (name "sbcl-cl-cookie")
      (build-system asdf-build-system/sbcl)
      (version (git-version "0.9.10" revision commit))
      (home-page "https://github.com/fukamachi/cl-cookie")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "090g7z75h98zvc1ldx0vh4jn4086dhjm2w30jcwkq553qmyxwl8h"))))
      (inputs
       `(("proc-parse" ,sbcl-proc-parse)
         ("alexandria" ,sbcl-alexandria)
         ("quri" ,sbcl-quri)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("local-time" ,sbcl-local-time)))
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (arguments
       ;; TODO: Tests fail because cl-cookie depends on cl-cookie-test.
       `(#:tests? #f))
      (synopsis "HTTP cookie manager for Common Lisp")
      (description "cl-cookie is a Common Lisp library featuring parsing of
cookie headers, cookie creation, cookie jar creation and more.")
      (license license:bsd-2))))

(define-public cl-cookie
  (sbcl-package->cl-source-package sbcl-cl-cookie))

(define-public ecl-cl-cookie
  (sbcl-package->ecl-package sbcl-cl-cookie))

(define-public sbcl-dexador
  (let ((commit "953090f04c4d1a9ee6632b90133cdc297b68badc")
        (revision "1"))
    (package
      (name "sbcl-dexador")
      (build-system asdf-build-system/sbcl)
      (version "0.9.14" )
      (home-page "https://github.com/fukamachi/dexador")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0w18fz3301rpmwc3kwb810czcd24mbf7r1z8vdyc0v5crjfpw3mn"))))
      (inputs
       `(("trivial-gray-streams" ,sbcl-trivial-gray-streams)
         ("babel" ,sbcl-babel)
         ("usocket" ,sbcl-usocket)
         ("fast-http" ,sbcl-fast-http)
         ("quri" ,sbcl-quri)
         ("fast-io" ,sbcl-fast-io)
         ("chunga" ,sbcl-chunga)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("cl-cookie" ,sbcl-cl-cookie)
         ("trivial-mimes" ,sbcl-trivial-mimes)
         ("chipz" ,sbcl-chipz)
         ("cl-base64" ,sbcl-cl-base64)
         ("cl-reexport" ,sbcl-cl-reexport)
         ("cl+ssl" ,sbcl-cl+ssl)
         ("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("alexandria" ,sbcl-alexandria)))
      (native-inputs
       `(("prove" ,sbcl-prove)
         ("lack" ,sbcl-lack)
         ("clack" ,sbcl-clack)
         ("babel" ,sbcl-babel)
         ("alexandria" ,sbcl-alexandria)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("local-time" ,sbcl-local-time)
         ("trivial-features" ,sbcl-trivial-features)))
      (arguments
       ;; TODO: Circular dependency: tests depend on clack-test which depends on dexador.
       `(#:tests? #f
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-permissions
             (lambda _ (make-file-writable "t/data/test.gz") #t)))))
      (synopsis "Yet another HTTP client for Common Lisp")
      (description "Dexador is yet another HTTP client for Common Lisp with
neat APIs and connection-pooling.  It is meant to supersede Drakma.")
      (license license:expat))))

(define-public cl-dexador
  (package
    (inherit (sbcl-package->cl-source-package sbcl-dexador))
    (arguments
     `(#:phases
       ;; asdf-build-system/source has its own phases and does not inherit
       ;; from asdf-build-system/sbcl phases.
       (modify-phases %standard-phases/source
         ;; Already done in SBCL package.
         (delete 'reset-gzip-timestamps))))))

(define-public ecl-dexador
  (sbcl-package->ecl-package sbcl-dexador))

(define-public sbcl-lisp-namespace
  (let ((commit "28107cafe34e4c1c67490fde60c7f92dc610b2e0")
        (revision "1"))
    (package
      (name "sbcl-lisp-namespace")
      (build-system asdf-build-system/sbcl)
      (version (git-version "0.1" revision commit))
      (home-page "https://github.com/guicho271828/lisp-namespace")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1jw2wykp06z2afb9nm1lgfzll5cjlj36pnknjx614057zkkxq4iy"))))
      (inputs
       `(("alexandria" ,sbcl-alexandria)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       `(#:test-asd-file "lisp-namespace.test.asd"
        ;; XXX: Component LISP-NAMESPACE-ASD::LISP-NAMESPACE.TEST not found
         #:tests? #f))
      (synopsis "LISP-N, or extensible namespaces in Common Lisp")
      (description "Common Lisp already has major 2 namespaces, function
namespace and value namespace (or variable namespace), but there are actually
more — e.g., class namespace.
This library offers macros to deal with symbols from any namespace.")
      (license license:llgpl))))

(define-public cl-lisp-namespace
  (sbcl-package->cl-source-package sbcl-lisp-namespace))

(define-public ecl-lisp-namespace
  (sbcl-package->ecl-package sbcl-lisp-namespace))

(define-public sbcl-trivial-cltl2
  (let ((commit "8a3bda30dc25d2f65fcf514d0eb6e6db75252c61")
        (revision "2"))
    (package
      (name "sbcl-trivial-cltl2")
      (build-system asdf-build-system/sbcl)
      (version (git-version "0.1.1" revision commit))
      (home-page "https://github.com/Zulu-Inuoe/trivial-cltl2")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "08cnzb9rnczn4pn2zpf0587ny4wjy1mjndy885fz9pw7xrlx37ip"))))
      (synopsis "Simple CLtL2 compatibility layer for Common Lisp")
      (description "This library is a portable compatibility layer around
\"Common Lisp the Language, 2nd
Edition\" (@url{https://www.cs.cmu.edu/Groups/AI/html/cltl/clm/node102.html})
and it exports symbols from implementation-specific packages.")
      (license license:llgpl))))

(define-public cl-trivial-cltl2
  (sbcl-package->cl-source-package sbcl-trivial-cltl2))

(define-public ecl-trivial-cltl2
  (sbcl-package->ecl-package sbcl-trivial-cltl2))

(define-public sbcl-introspect-environment
  (let ((commit "fff42f8f8fd0d99db5ad6c5812e53de7d660020b")
        (revision "1"))
    (package
      (name "sbcl-introspect-environment")
      (build-system asdf-build-system/sbcl)
      (version (git-version "0.1" revision commit))
      (home-page "https://github.com/Bike/introspect-environment")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1i305n0wfmpac63ni4i3vixnnkl8daw5ncxy0k3dv92krgx6qzhp"))))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (synopsis "Common Lisp environment introspection portability layer")
      (description "This library is a small interface to portable but
nonstandard introspection of Common Lisp environments.  It is intended to
allow a bit more compile-time introspection of environments in Common Lisp.

Quite a bit of information is available at the time a macro or compiler-macro
runs; inlining info, type declarations, that sort of thing.  This information
is all standard - any Common Lisp program can @code{(declare (integer x))} and
such.

This info ought to be accessible through the standard @code{&environment}
parameters, but it is not.  Several implementations keep the information for
their own purposes but do not make it available to user programs, because
there is no standard mechanism to do so.

This library uses implementation-specific hooks to make information available
to users.  This is currently supported on SBCL, CCL, and CMUCL.  Other
implementations have implementations of the functions that do as much as they
can and/or provide reasonable defaults.")
      (license license:wtfpl2))))

(define-public cl-introspect-environment
  (sbcl-package->cl-source-package sbcl-introspect-environment))

(define-public ecl-introspect-environment
  (sbcl-package->ecl-package sbcl-introspect-environment))

(define-public sbcl-type-i
  (let ((commit "d34440ab4ebf5a46a58deccb35950b15670e3667")
        (revision "2"))
    (package
      (name "sbcl-type-i")
      (build-system asdf-build-system/sbcl)
      (version (git-version "0.1" revision commit))
      (home-page "https://github.com/guicho271828/type-i")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "12wsga0pwjkkr176lnjwkmmlm3ccp0n310sjj9h20lk53iyd0z69"))))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("introspect-environment" ,sbcl-introspect-environment)
         ("trivia.trivial" ,sbcl-trivia.trivial)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       `(#:test-asd-file "type-i.test.asd"))
      (synopsis "Type inference utility on unary predicates for Common Lisp")
      (description "This library tries to provide a way to detect what kind of
type the given predicate is trying to check.  This is different from inferring
the return type of a function.")
      (license license:llgpl))))

(define-public cl-type-i
  (sbcl-package->cl-source-package sbcl-type-i))

(define-public ecl-type-i
  (package
    (inherit (sbcl-package->ecl-package sbcl-type-i))
    (arguments
     ;; The tests get stuck indefinitly
     '(#:tests? #f))))

(define-public sbcl-optima
  (let ((commit "373b245b928c1a5cce91a6cb5bfe5dd77eb36195")
        (revision "1"))
    (package
      (name "sbcl-optima")
      (build-system asdf-build-system/sbcl)
      (version (git-version "1.0" revision commit))
      (home-page "https://github.com/m2ym/optima")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1yw4ymq7ms89342kkvb3aqxgv0w38m9kd8ikdqxxzyybnkjhndal"))))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("closer-mop" ,sbcl-closer-mop)))
      (native-inputs
       `(("eos" ,sbcl-eos)))
      (arguments
       ;; XXX: Circular dependencies: tests depend on optima.ppcre which depends on optima.
       `(#:tests? #f
         #:test-asd-file "optima.test.asd"))
      (synopsis "Optimized pattern matching library for Common Lisp")
      (description "Optima is a fast pattern matching library which uses
optimizing techniques widely used in the functional programming world.")
      (license license:expat))))

(define-public cl-optima
  (sbcl-package->cl-source-package sbcl-optima))

(define-public ecl-optima
  (sbcl-package->ecl-package sbcl-optima))

(define-public sbcl-fare-quasiquote
  (let ((commit "640d39a0451094071b3e093c97667b3947f43639")
        (revision "1"))
    (package
      (name "sbcl-fare-quasiquote")
      (build-system asdf-build-system/sbcl)
      (version (git-version "1.0.1" revision commit))
      (home-page "https://gitlab.common-lisp.net/frideau/fare-quasiquote")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url (string-append "https://gitlab.common-lisp.net/frideau/"
                                   "fare-quasiquote.git"))
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1g6q11l50kgija9f55lzqpcwvaq0ljiw8v1j265hnyg6nahjwjvg"))))
      (inputs
       `(("fare-utils" ,sbcl-fare-utils)
         ("named-readtables" ,sbcl-named-readtables)
         ("optima" ,sbcl-optima)))
      (arguments
       ;; XXX: Circular dependencies: Tests depend on subsystems,
       ;; which depend on the main systems.
       `(#:tests? #f
         #:asd-systems '("fare-quasiquote"
                         "fare-quasiquote-extras")
         #:phases
         (modify-phases %standard-phases
           ;; XXX: Require 1.0.0 version of fare-utils, and we package some
           ;; commits after 1.0.0.5, but ASDF fails to read the
           ;; "-REVISION-COMMIT" part generated by Guix.
           (add-after 'unpack 'patch-requirement
             (lambda _
               (substitute* "fare-quasiquote.asd"
                 (("\\(:version \"fare-utils\" \"1.0.0\"\\)")
                  "\"fare-utils\""))
               (substitute* "fare-quasiquote-optima.asd"
                 (("\\(:version \"optima\" \"1\\.0\"\\)")
                  "\"optima\""))
               #t)))))
      (synopsis "Pattern-matching friendly implementation of quasiquote")
      (description "The main purpose of this n+2nd reimplementation of
quasiquote is enable matching of quasiquoted patterns, using Optima or
Trivia.")
      (license license:expat))))

(define-public cl-fare-quasiquote
  (sbcl-package->cl-source-package sbcl-fare-quasiquote))

(define-public ecl-fare-quasiquote
  (sbcl-package->ecl-package sbcl-fare-quasiquote))

;;; Split the trivia package in two to work around the circular dependency
;;; between guicho271828/trivia and guicho271828/type-i.
(define-public sbcl-trivia.trivial
  (let ((commit "37698b47a14c2007630468de7a993694ef7bd475")
        (revision "2"))
    (package
      (name "sbcl-trivia.trivial")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/guicho271828/trivia")
               (commit commit)))
         (file-name (git-file-name "trivia" version))
         (sha256
          (base32
           "0rsbwbw3ipxxgr6zzhci12nilq8zky475kmhz1rcxy4q8a85vn72"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("closer-mop" ,sbcl-closer-mop)
         ("lisp-namespace" ,sbcl-lisp-namespace)
         ("trivial-cltl2" ,sbcl-trivial-cltl2)))
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-build
             (lambda _
               (for-each delete-file
                         '("trivia.balland2006.asd"
                           "trivia.ppcre.asd"
                           "trivia.quasiquote.asd"
                           "trivia.cffi.asd"
                           "trivia.asd"
                           "trivia.test.asd"))
               #t)))))
      (synopsis "Pattern matching in Common Lisp")
      (description "Trivia is a pattern matching compiler that is compatible
with Optima, another pattern matching library for Common Lisp.  It is meant to
be faster and more extensible than Optima.")
      (home-page "https://github.com/guicho271828/trivia")
      (license license:llgpl))))

(define-public cl-trivia.trivial
  (sbcl-package->cl-source-package sbcl-trivia.trivial))

(define-public ecl-trivia.trivial
  (sbcl-package->ecl-package sbcl-trivia.trivial))

(define-public sbcl-trivia
  (package
    (inherit sbcl-trivia.trivial)
    (name "sbcl-trivia")
    (native-inputs
     `(("fiveam" ,sbcl-fiveam)
       ("optima" ,sbcl-optima)))
    (inputs
     `(("alexandria" ,sbcl-alexandria)
       ("cffi" ,sbcl-cffi)
       ("cl-ppcre" ,sbcl-cl-ppcre)
       ("fare-quasiquote" ,sbcl-fare-quasiquote)
       ("iterate" ,sbcl-iterate)
       ("trivia.trivial" ,sbcl-trivia.trivial)
       ("type-i" ,sbcl-type-i)))
    (arguments
     '(#:asd-systems '("trivia"
                       "trivia.ppcre"
                       "trivia.quasiquote"
                       "trivia.cffi")
       #:test-asd-file "trivia.test.asd"
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-build
           (lambda _
             (for-each delete-file
                       '("trivia.level0.asd"
                         "trivia.level1.asd"
                         "trivia.level2.asd"
                         "trivia.trivial.asd"))
             #t)))))))

(define-public cl-trivia
  (sbcl-package->cl-source-package sbcl-trivia))

(define-public ecl-trivia
  (sbcl-package->ecl-package sbcl-trivia))

(define-public sbcl-mk-string-metrics
  (package
    (name "sbcl-mk-string-metrics")
    (version "0.1.2")
    (home-page "https://github.com/cbaggers/mk-string-metrics/")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url home-page)
                    (commit version)))
              (sha256
               (base32 "0bg0bv2mfd4k0g3x72x563hvmrx18xavaffr6xk5rh4if5j7kcf6"))
              (file-name (git-file-name name version))))
    (build-system asdf-build-system/sbcl)
    (synopsis "Calculate various string metrics efficiently in Common Lisp")
    (description "This library implements efficient algorithms that calculate
various string metrics in Common Lisp:

@itemize
@item Damerau-Levenshtein distance
@item Hamming distance
@item Jaccard similarity coefficient
@item Jaro distance
@item Jaro-Winkler distance
@item Levenshtein distance
@item Normalized Damerau-Levenshtein distance
@item Normalized Levenshtein distance
@item Overlap coefficient
@end itemize\n")
    (license license:x11)))

(define-public cl-mk-string-metrics
  (sbcl-package->cl-source-package sbcl-mk-string-metrics))

(define-public ecl-mk-string-metrics
  (sbcl-package->ecl-package sbcl-mk-string-metrics))

(define-public sbcl-cl-str
  (package
    (name "sbcl-cl-str")
    (version "0.19")
    (home-page "https://github.com/vindarel/cl-str")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url home-page)
                    (commit version)))
              (sha256
               (base32 "1jyza2jhn7w6fl4w87pv0m87z5ia48m6dqw12k0mdh7l3mgjq839"))
              (file-name (git-file-name name version))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("cl-ppcre" ,sbcl-cl-ppcre)
       ("cl-ppcre-unicode" ,sbcl-cl-ppcre-unicode)
       ("cl-change-case" ,sbcl-cl-change-case)))
    (native-inputs
     `(("prove" ,sbcl-prove)))
    (arguments
     `(#:asd-systems '("str")
       #:test-asd-file "str.test.asd"))
    (synopsis "Modern, consistent and terse Common Lisp string manipulation library")
    (description "A modern and consistent Common Lisp string manipulation
library that focuses on modernity, simplicity and discoverability:
@code{(str:trim s)} instead of @code{(string-trim '(#\\Space ...) s)}), or
@code{str:concat strings} instead of an unusual format construct; one
discoverable library instead of many; consistency and composability, where
@code{s} is always the last argument, which makes it easier to feed pipes and
arrows.")
    (license license:expat)))

(define-public cl-str
  (sbcl-package->cl-source-package sbcl-cl-str))

(define-public ecl-cl-str
  (sbcl-package->ecl-package sbcl-cl-str))

(define-public sbcl-cl-xmlspam
  (let ((commit "ea06abcca2a73a9779bcfb09081e56665f94e22a"))
    (package
      (name "sbcl-cl-xmlspam")
      (build-system asdf-build-system/sbcl)
      (version (git-version "0.0.0" "1" commit))
      (home-page "https://github.com/rogpeppe/cl-xmlspam")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (string-append name "-" version))
         (sha256
          (base32
           "0w4rqvrgdgk3fwfq3kx4r7wwdr2bv3b6n3bdqwsiriw9psqzpz2s"))))
      (inputs
       `(("cxml" ,sbcl-cxml)
         ("cl-ppcre" ,sbcl-cl-ppcre)))
      (synopsis "Concise, regexp-like pattern matching on streaming XML for Common Lisp")
      (description "CXML does an excellent job at parsing XML elements, but what
do you do when you have a XML file that's larger than you want to fit in
memory, and you want to extract some information from it?  Writing code to deal
with SAX events, or even using Klacks, quickly becomes tedious.
@code{cl-xmlspam} (for XML Stream PAttern Matcher) is designed to make it easy
to write code that mirrors the structure of the XML that it's parsing.  It
also makes it easy to shift paradigms when necessary - the usual Lisp control
constructs can be used interchangeably with pattern matching, and the full
power of CXML is available when necessary.")
      (license license:bsd-3))))

(define-public cl-xmlspam
  (sbcl-package->cl-source-package sbcl-cl-xmlspam))

(define-public ecl-cl-xmlspam
  (sbcl-package->ecl-package sbcl-cl-xmlspam))

(define-public sbcl-dbus
  (let ((commit "24b452df3a45ca5dc95015500f34baad175c981a")
        (revision "1"))
    (package
      (name "sbcl-dbus")
      (version (git-version "20190408" revision commit))
      (home-page "https://github.com/death/dbus")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0fw2q866yddbf23nk9pxphm9gsasx35vjyss82xzvndnjmzlqfl5"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("trivial-garbage" ,sbcl-trivial-garbage)
         ("babel" ,sbcl-babel)
         ("iolib" ,sbcl-iolib)
         ("ieee-floats" ,sbcl-ieee-floats)
         ("flexi-streams" ,sbcl-flexi-streams)
         ("cl-xmlspam" ,sbcl-cl-xmlspam)
         ("ironclad" ,sbcl-ironclad)))
      (synopsis "D-Bus client library for Common Lisp")
      (description "This is a Common Lisp library that publishes D-Bus
objects as well as send and notify other objects connected to a bus.")
      (license license:bsd-2))))

(define-public cl-dbus
  (sbcl-package->cl-source-package sbcl-dbus))

(define-public ecl-dbus
  (sbcl-package->ecl-package sbcl-dbus))

(define-public sbcl-cl-hooks
  (let ((commit "5b638083f3b4f1221a52631d9c8a0a265565cac7")
        (revision "1"))
    (package
      (name "sbcl-cl-hooks")
      (build-system asdf-build-system/sbcl)
      (version (git-version "0.2.1" revision commit))
      (home-page "https://github.com/scymtym/architecture.hooks")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0bg3l0a28lw5gqqjp6p6b5nhwqk46sgkb7184w5qbfngw1hk8x9y"))))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("let-plus" ,sbcl-let-plus)
         ("trivial-garbage" ,sbcl-trivial-garbage)
         ("closer-mop" ,sbcl-closer-mop)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (synopsis "Hooks extension point mechanism (as in Emacs) for Common Lisp")
      (description "A hook, in the present context, is a certain kind of
extension point in a program that allows interleaving the execution of
arbitrary code with the execution of a the program without introducing any
coupling between the two.  Hooks are used extensively in the extensible editor
Emacs.

In the Common LISP Object System (CLOS), a similar kind of extensibility is
possible using the flexible multi-method dispatch mechanism.  It may even seem
that the concept of hooks does not provide any benefits over the possibilities
of CLOS.  However, there are some differences:

@itemize

@item There can be only one method for each combination of specializers and
qualifiers.  As a result this kind of extension point cannot be used by
multiple extensions independently.
@item Removing code previously attached via a @code{:before}, @code{:after} or
@code{:around} method can be cumbersome.
@item There could be other or even multiple extension points besides @code{:before}
and @code{:after} in a single method.
@item Attaching codes to individual objects using eql specializers can be
cumbersome.
@item Introspection of code attached a particular extension point is
cumbersome since this requires enumerating and inspecting the methods of a
generic function.
@end itemize

This library tries to complement some of these weaknesses of method-based
extension-points via the concept of hooks.")
      (license license:llgpl))))

(define-public cl-hooks
  (sbcl-package->cl-source-package sbcl-cl-hooks))

(define-public ecl-cl-hooks
  (sbcl-package->ecl-package sbcl-cl-hooks))

(define-public sbcl-cl-autowrap
  (let ((revision "1")
        (commit "ae846d6968fc0d000de0c541638929a157f3009e"))
    ;; no taged branches
    (package
      (name "sbcl-cl-autowrap")
      (version (git-version "1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/rpav/cl-autowrap")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1gisldp2zns92kdcaikghm7c38ldy2d884n8bfg0wcjvbz78p3ar"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cffi" ,sbcl-cffi)
         ("cl-json" ,sbcl-cl-json)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("defpackage-plus" ,sbcl-defpackage-plus)
         ("trivial-features" ,sbcl-trivial-features)))
      (home-page "https://github.com/rpav/cl-autowrap")
      (synopsis "FFI wrapper generator for Common Lisp")
      (description "This is a c2ffi-based wrapper generator for Common Lisp.")
      (license license:bsd-2))))

(define-public cl-autowrap
  (sbcl-package->cl-source-package sbcl-cl-autowrap))

(define-public ecl-cl-autowrap
  (sbcl-package->ecl-package sbcl-cl-autowrap))

(define-public sbcl-s-sysdeps
  ;; No release since 2013.
  (let ((commit "9aa23bbdceb24bcdbe0e7c39fa1901858f823106")
        (revision "2"))
    (package
      (name "sbcl-s-sysdeps")
      (build-system asdf-build-system/sbcl)
      (version (git-version "1" revision commit))
      (home-page "https://github.com/svenvc/s-sysdeps")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1fh8r7kf8s3hvqdg6b71b8p7w3v2kkga9bw8j3qqdxhzr6anpm0b"))))
      (inputs
       `(("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("usocket" ,sbcl-usocket)))
      (synopsis "Common Lisp abstraction layer over platform dependent functionality")
      (description "@code{s-sysdeps} is an abstraction layer over platform
dependent functionality.  This simple package is used as a building block in a
number of other open source projects.

@code{s-sysdeps} abstracts:

@itemize
@item managing processes,
@item implementing a standard TCP/IP server,
@item opening a client TCP/IP socket stream,
@item working with process locks.
@end itemize\n")
      (license license:llgpl))))

(define-public cl-s-sysdeps
  (sbcl-package->cl-source-package sbcl-s-sysdeps))

(define-public ecl-s-sysdeps
  (sbcl-package->ecl-package sbcl-s-sysdeps))

(define-public sbcl-cl-prevalence
  (let ((commit "5a76be036092ed6c18cb695a9e03bce87e21b840")
        (revision "4"))
    (package
      (name "sbcl-cl-prevalence")
      (build-system asdf-build-system/sbcl)
      (version (git-version "5" revision commit))
      (home-page "https://github.com/40ants/cl-prevalence")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "050h6hwv8f16b5v6fzba8zmih92hgaaq27i2x9wv1iib41gbia3r"))))
      (inputs
       `(("s-sysdeps" ,sbcl-s-sysdeps)
         ("s-xml" ,sbcl-s-xml)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (synopsis "Implementation of object prevalence for Common Lisp")
      (description "This Common Lisp library implements object prevalence (see
@url{https://en.wikipedia.org/wiki/System_prevalence}).  It allows
for (de)serializing to and from s-exps as well as XML.  Serialization of arbitrary
classes and cyclic data structures are supported.")
      (license license:llgpl))))

(define-public cl-prevalence
  (sbcl-package->cl-source-package sbcl-cl-prevalence))

(define-public ecl-cl-prevalence
  (sbcl-package->ecl-package sbcl-cl-prevalence))

(define-public sbcl-series
  (let ((commit "da9061b336119d1e5214aff9117171d494d5a58a")
        (revision "1"))
    (package
      (name "sbcl-series")
      (version (git-version "2.2.11" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "git://git.code.sf.net/p/series/series")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "07hk2lhfx42zk018pxqvn4gs77vd4n4g8m4xxbqaxgca76mifwfw"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; Disable the tests, they are apparently buggy and I didn't find
       ;; a simple way to make them run and pass.
       '(#:tests? #f))
      (synopsis "Series data structure for Common Lisp")
      (description
       "This Common Lisp library provides a series data structure much like
a sequence, with similar kinds of operations.  The difference is that in many
situations, operations on series may be composed functionally and yet execute
iteratively, without the need to construct intermediate series values
explicitly.  In this manner, series provide both the clarity of a functional
programming style and the efficiency of an iterative programming style.")
      (home-page "http://series.sourceforge.net/")
      (license license:expat))))

(define-public cl-series
  (sbcl-package->cl-source-package sbcl-series))

(define-public ecl-series
  (sbcl-package->ecl-package sbcl-series))

(define-public sbcl-periods
  (let ((commit "983d4a57325db3c8def942f163133cec5391ec28")
        (revision "1"))
    (package
      (name "sbcl-periods")
      (version (git-version "0.0.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/jwiegley/periods")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0z30jr3lxz3cmi019fsl4lgcgwf0yqpn95v9zkkkwgymdrkd4lga"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("local-time" ,sbcl-local-time)
         ("series" ,sbcl-series)))
      (arguments
       '(#:asd-systems '("periods"
                         "periods-series")))
      (synopsis "Common Lisp library for manipulating date/time objects")
      (description
       "Periods is a Common Lisp library providing a set of utilities for
manipulating times, distances between times, and both contiguous and
discontiguous ranges of time.")
      (home-page "https://github.com/jwiegley/periods")
      (license license:bsd-3))))

(define-public cl-periods
  (sbcl-package->cl-source-package sbcl-periods))

(define-public ecl-periods
  (sbcl-package->ecl-package sbcl-periods))

(define-public sbcl-metatilities-base
  (let ((commit "6eaa9e3ff0939a93a92109dd0fcd218de85417d5")
        (revision "1"))
    (package
      (name "sbcl-metatilities-base")
      (version (git-version "0.6.6" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/gwkkwg/metatilities-base")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0xpa86pdzlnf4v5g64j3ifaplx71sx2ha8b7vvakswi652679ma0"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("lift" ,sbcl-lift)))
      (synopsis "Core of the metatilities Common Lisp library")
      (description
       "Metatilities-base is the core of the metatilities Common Lisp library
which implements a set of utilities.")
      (home-page "https://common-lisp.net/project/metatilities-base/")
      (license license:expat))))

(define-public cl-metatilities-base
  (sbcl-package->cl-source-package sbcl-metatilities-base))

(define-public ecl-metatilities-base
  (sbcl-package->ecl-package sbcl-metatilities-base))

(define-public sbcl-cl-containers
  (let ((commit "3d1df53c22403121bffb5d553cf7acb1503850e7")
        (revision "3"))
    (package
      (name "sbcl-cl-containers")
      (version (git-version "0.12.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/gwkkwg/cl-containers")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "18s6jfq11n8nv9k4biz32pm1s7y9zl054ry1gmdbcf39nisy377y"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("lift" ,sbcl-lift)))
      (inputs
       `(("metatilities-base" ,sbcl-metatilities-base)))
      (arguments
       '(#:asd-files '("cl-containers.asd")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'relax-version-checks
             (lambda _
               (substitute* "cl-containers.asd"
                 (("\\(:version \"metatilities-base\" \"0\\.6\\.6\"\\)")
                  "\"metatilities-base\""))
               (substitute* "cl-containers-test.asd"
                 (("\\(:version \"lift\" \"1\\.7\\.0\"\\)")
                  "\"lift\""))
               #t)))))
      (synopsis "Container library for Common Lisp")
      (description
       "Common Lisp ships with a set of powerful built in data structures
including the venerable list, full featured arrays, and hash-tables.
CL-containers enhances and builds on these structures by adding containers
that are not available in native Lisp (for example: binary search trees,
red-black trees, sparse arrays and so on), and by providing a standard
interface so that they are simpler to use and so that changing design
decisions becomes significantly easier.")
      (home-page "https://common-lisp.net/project/cl-containers/")
      (license license:expat))))

(define-public cl-containers
  (sbcl-package->cl-source-package sbcl-cl-containers))

(define-public ecl-cl-containers
  (sbcl-package->ecl-package sbcl-cl-containers))

(define-public sbcl-xlunit
  (let ((commit "3805d34b1d8dc77f7e0ee527a2490194292dd0fc")
        (revision "1"))
    (package
      (name "sbcl-xlunit")
      (version (git-version "0.6.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "http://git.kpe.io/xlunit.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0argfmp9nghs4sihyj3f8ch9qfib2b7ll07v5m9ziajgzsfl5xw3"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-tests
             (lambda _
               (substitute* "xlunit.asd"
                 ((" :force t") ""))
               #t)))))
      (synopsis "Unit testing package for Common Lisp")
      (description
       "The XLUnit package is a toolkit for building test suites.  It is based
on the XPTest package by Craig Brozensky and the JUnit package by Kent Beck.")
      (home-page "http://quickdocs.org/xlunit/")
      (license license:bsd-3))))

(define-public cl-xlunit
  (sbcl-package->cl-source-package sbcl-xlunit))

(define-public ecl-xlunit
  (sbcl-package->ecl-package sbcl-xlunit))

(define-public sbcl-cambl
  (let ((commit "7016d1a98215f82605d1c158e7a16504ca1f4636")
        (revision "1"))
    (package
      (name "sbcl-cambl")
      (version (git-version "4.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/jwiegley/cambl")
               (commit commit)))
         (file-name (git-file-name "cambl" version))
         (sha256
          (base32 "103mry04j2k9vznsxm7wcvccgxkil92cdrv52miwcmxl8daa4jiz"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("xlunit" ,sbcl-xlunit)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-containers" ,sbcl-cl-containers)
         ("local-time" ,sbcl-local-time)
         ("periods" ,sbcl-periods)))
      (arguments
       '(#:asd-files '("fprog.asd"
                       "cambl.asd")))
      (synopsis "Commoditized amounts and balances for Common Lisp")
      (description
       "CAMBL is a Common Lisp library providing a convenient facility for
working with commoditized values.  It does not allow compound units (and so is
not suited for scientific operations) but does work rather nicely for the
purpose of financial calculations.")
      (home-page "https://github.com/jwiegley/cambl")
      (license license:bsd-3))))

(define-public cl-cambl
  (sbcl-package->cl-source-package sbcl-cambl))

(define-public ecl-cambl
  (sbcl-package->ecl-package sbcl-cambl))

(define-public sbcl-cl-ledger
  (let ((commit "08e0be41795e804cd36142e51756ad0b1caa377b")
        (revision "1"))
    (package
      (name "sbcl-cl-ledger")
      (version (git-version "4.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ledger/cl-ledger")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1via0qf6wjcyxnfbmfxjvms0ik9j8rqbifgpmnhrzvkhrq9pv8h1"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cambl" ,sbcl-cambl)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("local-time" ,sbcl-local-time)
         ("periods" ,sbcl-periods)))
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-system-definition
             (lambda _
               (substitute* "cl-ledger.asd"
                 (("  :build-operation program-op") "")
                 (("  :build-pathname \"cl-ledger\"") "")
                 (("  :entry-point \"ledger::main\"") ""))
               #t)))))
      (synopsis "Common Lisp port of the Ledger accounting system")
      (description
       "CL-Ledger is a Common Lisp port of the Ledger double-entry accounting
system.")
      (home-page "https://github.com/ledger/cl-ledger")
      (license license:bsd-3))))

(define-public cl-ledger
  (sbcl-package->cl-source-package sbcl-cl-ledger))

(define-public ecl-cl-ledger
  (sbcl-package->ecl-package sbcl-cl-ledger))

(define-public sbcl-bst
  (let ((commit "8545aed0d504df2829ad139566feeabe22305388")
        (revision "0"))
    (package
      (name "sbcl-bst")
      (version (git-version "2.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/glv2/bst")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "18ig7rvxcra69437g0i8sxyv7c5dg26jqnx1rc2f9pxmihdprgk8"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("alexandria" ,sbcl-alexandria)
         ("fiveam" ,sbcl-fiveam)))
      (synopsis "Binary search tree for Common Lisp")
      (description
       "BST is a Common Lisp library for working with binary search trees that
can contain any kind of values.")
      (home-page "https://github.com/glv2/bst")
      (license license:gpl3))))

(define-public cl-bst
  (sbcl-package->cl-source-package sbcl-bst))

(define-public ecl-bst
  (sbcl-package->ecl-package sbcl-bst))

(define-public sbcl-cl-octet-streams
  (package
    (name "sbcl-cl-octet-streams")
    (version "1.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/glv2/cl-octet-streams")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1hffh98bv4w5yrchagzwqrc43d2p473pvw7ka4kyyvhrr52dk2f8"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("fiveam" ,sbcl-fiveam)))
    (inputs
     `(("trivial-gray-streams" ,sbcl-trivial-gray-streams)))
    (synopsis "In-memory octet streams for Common Lisp")
    (description
     "CL-octet-streams is a library implementing in-memory octet
streams for Common Lisp.  It was inspired by the trivial-octet-streams and
cl-plumbing libraries.")
    (home-page "https://github.com/glv2/cl-octet-streams")
    (license license:gpl3+)))

(define-public cl-octet-streams
  (sbcl-package->cl-source-package sbcl-cl-octet-streams))

(define-public ecl-cl-octet-streams
  (sbcl-package->ecl-package sbcl-cl-octet-streams))

(define-public sbcl-lzlib
  (let ((commit "cad10f5becbcfebb44b9d311a257563778803452")
        (revision "2"))
    (package
      (name "sbcl-lzlib")
      (version (git-version "1.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/glv2/cl-lzlib")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "09lp7li35h4jkls0448fj1sh6pjslr1w7ranbc4szjr8g0c2bdry"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("cffi" ,sbcl-cffi)
         ("cl-octet-streams" ,sbcl-cl-octet-streams)
         ("lparallel" ,sbcl-lparallel)
         ("lzlib" ,lzlib)))
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "src/lzlib.lisp"
                 (("liblz\\.so")
                  (string-append (assoc-ref inputs "lzlib") "/lib/liblz.so")))
               #t)))))
      (synopsis "Common Lisp library for lzip (de)compression")
      (description
       "This Common Lisp library provides functions for lzip (LZMA)
compression/decompression using bindings to the lzlib C library.")
      (home-page "https://github.com/glv2/cl-lzlib")
      (license license:gpl3+))))

(define-public cl-lzlib
  (sbcl-package->cl-source-package sbcl-lzlib))

(define-public ecl-lzlib
  (sbcl-package->ecl-package sbcl-lzlib))

(define-public sbcl-chanl
  (let ((commit "56e90a126c78b39bb621a01585e8d3b985238e8c")
        (revision "1"))
    (package
      (name "sbcl-chanl")
      (version (git-version "0.4.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/zkat/chanl")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0b1cf6c12qx5cy1fw2z42jgh566rp3l8nv5qf0qqc569s7bgmrh4"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("bordeaux-threads" ,sbcl-bordeaux-threads)))
      (synopsis "Portable channel-based concurrency for Common Lisp")
      (description "Common Lisp library for channel-based concurrency.  In
a nutshell, you create various threads sequentially executing tasks you need
done, and use channel objects to communicate and synchronize the state of these
threads.")
      (home-page "https://github.com/zkat/chanl")
      (license (list license:expat license:bsd-3)))))

(define-public cl-chanl
  (sbcl-package->cl-source-package sbcl-chanl))

(define-public ecl-chanl
  (sbcl-package->ecl-package sbcl-chanl))

(define-public sbcl-cl-store
  (let ((commit "c787337a16ea8cf8a06227f35933a4ec774746b3")
        (revision "1"))
    (package
      (name "sbcl-cl-store")
      (version (git-version "0.8.11" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/skypher/cl-store")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "194srkg8nrym19c6i7zbnkzshc1qhqa82m53qnkirz9fw928bqxr"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("rt" ,sbcl-rt)))
      (synopsis "Common Lisp library to serialize data")
      (description
       "CL-STORE is a portable serialization package which should give you the
ability to store all Common Lisp data types into streams.")
      (home-page "https://www.common-lisp.net/project/cl-store/")
      (license license:expat))))

(define-public cl-store
  (sbcl-package->cl-source-package sbcl-cl-store))

(define-public ecl-cl-store
  (sbcl-package->ecl-package sbcl-cl-store))

(define-public sbcl-cl-gobject-introspection
  (let ((commit "7b703e2384945ea0ac39d9b766de434a08d81560")
        (revision "0"))
    (package
      (name "sbcl-cl-gobject-introspection")
      (version (git-version "0.3" revision commit))
      (home-page "https://github.com/andy128k/cl-gobject-introspection")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1zcqd2qj14f6b38vys8gr89s6cijsp9r8j43xa8lynilwva7bwyh"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cffi" ,sbcl-cffi)
         ("iterate" ,sbcl-iterate)
         ("trivial-garbage" ,sbcl-trivial-garbage)
         ("glib" ,glib)
         ("gobject-introspection" ,gobject-introspection)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       ;; TODO: Tests fail, see
       ;; https://github.com/andy128k/cl-gobject-introspection/issues/70.
       '(#:tests? #f
         #:phases
         (modify-phases %standard-phases
           (add-after (quote unpack) (quote fix-paths)
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "src/init.lisp"
                 (("libgobject-2\\.0\\.so")
                  (string-append (assoc-ref inputs "glib") "/lib/libgobject-2.0.so"))
                 (("libgirepository-1\\.0\\.so")
                  (string-append (assoc-ref inputs "gobject-introspection")
                                 "/lib/libgirepository-1.0.so")))
               #t)))))
      (synopsis "Common Lisp bindings to GObject Introspection")
      (description
       "This library is a bridge between Common Lisp and GObject
Introspection, which enables Common Lisp programs to access the full interface
of C+GObject libraries without the need of writing dedicated bindings.")
      (license (list license:bsd-3
                     ;; Tests are under a different license.
                     license:llgpl)))))

(define-public cl-gobject-introspection
  (sbcl-package->cl-source-package sbcl-cl-gobject-introspection))

(define-public ecl-cl-gobject-introspection
  (sbcl-package->ecl-package sbcl-cl-gobject-introspection))

(define-public sbcl-string-case
  (let ((commit "718c761e33749e297cd2809c7ba3ade1985c49f7")
        (revision "0"))
    (package
      (name "sbcl-string-case")
      (version (git-version "0.0.2" revision commit))
      (home-page "https://github.com/pkhuong/string-case")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1n5i3yh0h5s636rcnwn7jwqy3rjflikra04lymimhpcshhjsk0md"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Efficient string= case in Common Lisp")
      (description
       "@code{string-case} is a Common Lisp macro that generates specialised decision
trees to dispatch on string equality.")
      (license license:bsd-3))))

(define-public cl-string-case
  (sbcl-package->cl-source-package sbcl-string-case))

(define-public ecl-string-case
  (sbcl-package->ecl-package sbcl-string-case))

(define-public sbcl-global-vars
  (let ((commit "c749f32c9b606a1457daa47d59630708ac0c266e")
        (revision "0"))
    (package
      (name "sbcl-global-vars")
      (version (git-version "1.0.0" revision commit))
      (home-page "https://github.com/lmj/global-vars")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "06m3xc8l3pgsapl8fvsi9wf6y46zs75cp9zn7zh6dc65v4s5wz3d"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Efficient global variables in Common Lisp")
      (description
       "In Common Lisp, a special variable that is never dynamically bound
typically serves as a stand-in for a global variable.  The @code{global-vars}
library provides true global variables that are implemented by some compilers.
An attempt to rebind a global variable properly results in a compiler error.
That is, a global variable cannot be dynamically bound.

Global variables therefore allow us to communicate an intended usage that
differs from special variables.  Global variables are also more efficient than
special variables, especially in the presence of threads.")
      (license license:expat))))

(define-public cl-global-vars
  (sbcl-package->cl-source-package sbcl-global-vars))

(define-public ecl-global-vars
  (sbcl-package->ecl-package sbcl-global-vars))

(define-public sbcl-trivial-file-size
  (let ((commit "1c1d672a01a446ba0391dbb4ffc40be3b0476f23")
        (revision "0"))
    (package
      (name "sbcl-trivial-file-size")
      (version (git-version "0.0.0" revision commit))
      (home-page "https://github.com/ruricolist/trivial-file-size")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "17pp86c9zs4y7i1sh7q9gbfw9iqv6655k7fz8qbj9ly1ypgxp4qs"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (synopsis "Size of a file in bytes in Common Lisp")
      (description
       "The canonical way to determine the size of a file in bytes, using Common Lisp,
is to open the file with an element type of (unsigned-byte 8) and then
calculate the length of the stream.  This is less than ideal.  In most cases
it is better to get the size of the file from its metadata, using a system
call.

This library exports a single function, file-size-in-octets.  It returns the
size of a file in bytes, using system calls when possible.")
      (license license:expat))))

(define-public cl-trivial-file-size
  (sbcl-package->cl-source-package sbcl-trivial-file-size))

(define-public ecl-trivial-file-size
  (sbcl-package->ecl-package sbcl-trivial-file-size))

(define-public sbcl-trivial-macroexpand-all
  (let ((commit "933270ac7107477de1bc92c1fd641fe646a7a8a9")
        (revision "0"))
    (package
      (name "sbcl-trivial-macroexpand-all")
      (version (git-version "0.0.0" revision commit))
      (home-page "https://github.com/cbaggers/trivial-macroexpand-all")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "191hnn4b5j4i3crydmlzbm231kj0h7l8zj6mzj69r1npbzkas4bd"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (synopsis "Portable macroexpand-all for Common Lisp")
      (description
       "This library provides a macroexpand-all function that calls the
implementation specific equivalent.")
      (license license:unlicense))))

(define-public cl-trivial-macroexpand-all
  (sbcl-package->cl-source-package sbcl-trivial-macroexpand-all))

(define-public ecl-trivial-macroexpand-all
  (sbcl-package->ecl-package sbcl-trivial-macroexpand-all))

(define-public sbcl-serapeum
  (let ((commit "c5e352a9f04a84a93742193c01734f4fb31d9f82")
        (revision "3"))
    (package
      (name "sbcl-serapeum")
      (version (git-version "0.0.0" revision commit))
      (home-page "https://github.com/ruricolist/serapeum")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "16767pxl766c15jznr4srcbp7cnxf8w9lkyaqpp5w5crqymw84nw"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("trivia" ,sbcl-trivia)
         ("split-sequence" ,sbcl-split-sequence)
         ("string-case" ,sbcl-string-case)
         ("parse-number" ,sbcl-parse-number)
         ("trivial-garbage" ,sbcl-trivial-garbage)
         ("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("named-readtables" ,sbcl-named-readtables)
         ("fare-quasiquote" ,sbcl-fare-quasiquote)
         ("parse-declarations-1.0" ,sbcl-parse-declarations)
         ("global-vars" ,sbcl-global-vars)
         ("trivial-file-size" ,sbcl-trivial-file-size)
         ("trivial-macroexpand-all" ,sbcl-trivial-macroexpand-all)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)
         ("local-time" ,sbcl-local-time)))
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'disable-failing-tests
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "serapeum.asd"
                 ;; Guix does not have Quicklisp, and probably never will.
                 (("\\(:file \"quicklisp\"\\)") ""))
               #t)))))
      (synopsis "Common Lisp utility library beyond Alexandria")
      (description
       "Serapeum is a conservative library of Common Lisp utilities.  It is a
supplement, not a competitor, to Alexandria.")
      (license license:expat))))

(define-public cl-serapeum
  (sbcl-package->cl-source-package sbcl-serapeum))

(define-public ecl-serapeum
  (sbcl-package->ecl-package sbcl-serapeum))

(define-public sbcl-arrows
  (let ((commit "df7cf0067e0132d9697ac8b1a4f1b9c88d4f5382")
        (revision "0"))
    (package
      (name "sbcl-arrows")
      (version (git-version "0.2.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://gitlab.com/Harleqin/arrows.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "042k9vkssrqx9nhp14wdzm942zgdxvp35mba0p2syz98i75im2yy"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("hu.dwim.stefil" ,sbcl-hu.dwim.stefil)))
      (synopsis "Clojure-like arrow macros for Common Lisp")
      (description
       "This library implements the @code{->} and @code{->>} macros from
Clojure, as well as several expansions on the idea.")
      (home-page "https://gitlab.com/Harleqin/arrows")
      (license license:public-domain))))

(define-public cl-arrows
  (sbcl-package->cl-source-package sbcl-arrows))

(define-public ecl-arrows
  (sbcl-package->ecl-package sbcl-arrows))

(define-public sbcl-simple-parallel-tasks
  (let ((commit "ce7b60f788d8f68dfb69b24aac54c0e3b63379a6")
        (revision "1"))
    (package
      (name "sbcl-simple-parallel-tasks")
      (version (git-version "1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/glv2/simple-parallel-tasks")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0gvbpyff4siifp3cp86cpr9ksmakn66fx21f3h0hpn647zl07nj7"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("chanl" ,sbcl-chanl)))
      (synopsis "Common Lisp library to evaluate some forms in parallel")
      (description "This is a simple Common Lisp library to evaluate some
forms in parallel.")
      (home-page "https://github.com/glv2/simple-parallel-tasks")
      (license license:gpl3))))

(define-public cl-simple-parallel-tasks
  (sbcl-package->cl-source-package sbcl-simple-parallel-tasks))

(define-public ecl-simple-parallel-tasks
  (sbcl-package->ecl-package sbcl-simple-parallel-tasks))

(define-public sbcl-cl-heap
  (package
    (name "sbcl-cl-heap")
    (version "0.1.6")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://common-lisp.net/project/cl-heap/releases/"
                           "cl-heap_" version ".tar.gz"))
       (sha256
        (base32
         "163hb07p2nxz126rpq3cj5dyala24n0by5i5786n2qcr1w0bak4i"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("xlunit" ,sbcl-xlunit)))
    (arguments
     `(#:test-asd-file "cl-heap-tests.asd"))
    (synopsis "Heap and priority queue data structures for Common Lisp")
    (description
     "CL-HEAP provides various implementations of heap data structures (a
binary heap and a Fibonacci heap) as well as an efficient priority queue.")
    (home-page "https://common-lisp.net/project/cl-heap/")
    (license license:gpl3+)))

(define-public cl-heap
  (sbcl-package->cl-source-package sbcl-cl-heap))

(define-public ecl-cl-heap
  (sbcl-package->ecl-package sbcl-cl-heap))

(define-public sbcl-curry-compose-reader-macros
  (let ((commit "beaa92dedf392726c042184bfd6149fa8d9e6ac2")
        (revision "0"))
    (package
      (name "sbcl-curry-compose-reader-macros")
      (version (git-version "1.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/eschulte/curry-compose-reader-macros")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0rv9bl8xrad5wfcg5zs1dazvnpmvqz6297lbn8bywsrcfnlf7h98"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("named-readtables" ,sbcl-named-readtables)))
      (synopsis "Reader macros for partial application and composition")
      (description
       "This Common Lisp library provides reader macros for concise expression
of function partial application and composition.")
      (home-page "https://eschulte.github.io/curry-compose-reader-macros/")
      (license license:public-domain))))

(define-public cl-curry-compose-reader-macros
  (sbcl-package->cl-source-package sbcl-curry-compose-reader-macros))

(define-public ecl-curry-compose-reader-macros
  (sbcl-package->ecl-package sbcl-curry-compose-reader-macros))

(define-public sbcl-yason
  (package
    (name "sbcl-yason")
    (version "0.7.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/phmarek/yason")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0479rbjgbj80jpk5bby18inlv1kfp771a82rlcq5psrz65qqa9bj"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("alexandria" ,sbcl-alexandria)
       ("trivial-gray-streams" ,sbcl-trivial-gray-streams)))
    (synopsis "Common Lisp JSON parser/encoder")
    (description
     "YASON is a Common Lisp library for encoding and decoding data in the
JSON interchange format.")
    (home-page "https://github.com/phmarek/yason")
    (license license:bsd-3)))

(define-public cl-yason
  (sbcl-package->cl-source-package sbcl-yason))

(define-public ecl-yason
  (sbcl-package->ecl-package sbcl-yason))

(define-public sbcl-stefil
  (let ((commit "0398548ec95dceb50fc2c2c03e5fb0ce49b86c7a")
        (revision "0"))
    (package
      (name "sbcl-stefil")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://gitlab.common-lisp.net/stefil/stefil.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0bqz64q2szzhf91zyqyssmvrz7da6442rs01808pf3wrdq28bclh"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("iterate" ,sbcl-iterate)
         ("metabang-bind" ,sbcl-metabang-bind)
         ("swank" ,sbcl-slime-swank)))
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'drop-unnecessary-dependency
             (lambda _
               (substitute* "package.lisp"
                 ((":stefil-system") ""))
               #t)))))
      (home-page "https://common-lisp.net/project/stefil/index-old.shtml")
      (synopsis "Simple test framework")
      (description
       "Stefil is a simple test framework for Common Lisp, with a focus on
interactive development.")
      (license license:public-domain))))

(define-public cl-stefil
  (sbcl-package->cl-source-package sbcl-stefil))

(define-public ecl-stefil
  (sbcl-package->ecl-package sbcl-stefil))

(define-public sbcl-graph
  (let ((commit "78bf9ec930d8eae4f0861b5be76765fb1e45e24f")
        (revision "0"))
    (package
      (name "sbcl-graph")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/eschulte/graph")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1qpij4xh8bqwc2myahpilcbh916v7vg0acz2fij14d3y0jm02h0g"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("stefil" ,sbcl-stefil)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-heap" ,sbcl-cl-heap)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("curry-compose-reader-macros" ,sbcl-curry-compose-reader-macros)
         ("metabang-bind" ,sbcl-metabang-bind)
         ("named-readtables" ,sbcl-named-readtables)
         ("yason" ,sbcl-yason)))
      (arguments
       '(#:asd-systems '("graph"
                         "graph/dot"
                         "graph/json")))
      (synopsis "Graph data structure and algorithms for Common Lisp")
      (description
       "The GRAPH Common Lisp library provides a data structures to represent
graphs, as well as some graph manipulation and analysis algorithms (shortest
path, maximum flow, minimum spanning tree, etc.).")
      (home-page "https://eschulte.github.io/graph/")
      (license license:gpl3+))))

(define-public cl-graph
  (sbcl-package->cl-source-package sbcl-graph))

(define-public ecl-graph
  (sbcl-package->ecl-package sbcl-graph))

(define-public sbcl-trivial-indent
  (let ((commit "2d016941751647c6cc5bd471751c2cf68861c94a")
        (revision "0"))
    (package
      (name "sbcl-trivial-indent")
      (version (git-version "1.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/Shinmera/trivial-indent")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1sj90nqz17w4jq0ixz00gb9g5g6d2s7l8r17zdby27gxxh51w266"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Simple Common Lisp library to allow indentation hints for SWANK")
      (description
       "This library allows you to define custom indentation hints for your
macros if the one recognised by SLIME automatically produces unwanted
results.")
      (home-page "https://shinmera.github.io/trivial-indent/")
      (license license:zlib))))

(define-public cl-trivial-indent
  (sbcl-package->cl-source-package sbcl-trivial-indent))

(define-public ecl-trivial-indent
  (sbcl-package->ecl-package sbcl-trivial-indent))

(define-public sbcl-documentation-utils
  (let ((commit "98630dd5f7e36ae057fa09da3523f42ccb5d1f55")
        (revision "0"))
    (package
      (name "sbcl-documentation-utils")
      (version (git-version "1.2.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/Shinmera/documentation-utils")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "098qhkqskmmrh4wix34mawf7p5c87yql28r51r75yjxj577k5idq"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("trivial-indent" ,sbcl-trivial-indent)))
      (synopsis "Few simple tools to document Common Lisp libraries")
      (description
       "This is a small library to help you with managing the Common Lisp
docstrings for your library.")
      (home-page "https://shinmera.github.io/documentation-utils/")
      (license license:zlib))))

(define-public cl-documentation-utils
  (sbcl-package->cl-source-package sbcl-documentation-utils))

(define-public ecl-documentation-utils
  (sbcl-package->ecl-package sbcl-documentation-utils))

(define-public sbcl-documentation-utils-extensions
  (let ((commit "f67f8a05d583174662a594b79356b201c1d9d750"))
    (package
      (name "sbcl-documentation-utils-extensions")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/sirherrbatka/documentation-utils-extensions/")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0pn45c9rbxlnhn5nvhqz6kyv0nlirwxpg4j27niwdq80yxzsn51f"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("documentation-utils" ,sbcl-documentation-utils)))
      (home-page "https://github.com/sirherrbatka/documentation-utils-extensions")
      (synopsis "Set of extensions for documentation-utils")
      (description
       "Use @code{rich-formatter} to format documentation with sections @code{:syntax},
@code{:arguments}, @code{:examples}, @code{:description}, @code{:returns},
@code{:side-effects}, @code{:thread-safety}, @code{:affected-by},
@code{:see-also} and @code{:notes}.  Gather unformatted input by using
@code{rich-aggregating-formatter} and @code{*DOCUMENTATION*} variable.  Find
gathered documentation with find-documentation function.  Execute code stored
in documentation with @code{execute-documentation}.  See the examples in the
@code{src/documentation.lisp} file.  See the @code{documentation-utils} system
for more information.")
      (license license:expat))))

(define-public cl-documentation-utils-extensions
  (sbcl-package->cl-source-package sbcl-documentation-utils-extensions))

(define-public ecl-documentation-utils-extensions
  (sbcl-package->ecl-package sbcl-documentation-utils-extensions))

(define-public sbcl-form-fiddle
  (let ((commit "e0c23599dbb8cff3e83e012f3d86d0764188ad18")
        (revision "0"))
    (package
      (name "sbcl-form-fiddle")
      (version (git-version "1.1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/Shinmera/form-fiddle")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "041iznc9mpfyrl0sv5893ys9pbb2pvbn9g3clarqi7gsfj483jln"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("documentation-utils" ,sbcl-documentation-utils)))
      (synopsis "Utilities to destructure Common Lisp lambda forms")
      (description
       "Often times we need to destructure a form definition in a Common Lisp
macro.  This library provides a set of simple utilities to help with that.")
      (home-page "https://shinmera.github.io/form-fiddle/")
      (license license:zlib))))

(define-public cl-form-fiddle
  (sbcl-package->cl-source-package sbcl-form-fiddle))

(define-public ecl-form-fiddle
  (sbcl-package->ecl-package sbcl-form-fiddle))

(define-public sbcl-parachute
  (let ((commit "ca04dd8e43010a6dfffa26dbe1d62af86008d666")
        (revision "0"))
    (package
      (name "sbcl-parachute")
      (version (git-version "1.1.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/Shinmera/parachute")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1mvsm3r0r6a2bg75nw0q7n9vlby3ch45qjl7hnb5k1z2n5x5lh60"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("documentation-utils" ,sbcl-documentation-utils)
         ("form-fiddle" ,sbcl-form-fiddle)))
      (synopsis "Extensible and cross-compatible testing framework for Common Lisp")
      (description
       "Parachute is a simple-to-use and extensible testing framework.
In Parachute, things are organised as a bunch of named tests within a package.
Each test can contain a bunch of test forms that make up its body.")
      (home-page "https://shinmera.github.io/parachute/")
      (license license:zlib))))

(define-public cl-parachute
  (sbcl-package->cl-source-package sbcl-parachute))

(define-public ecl-parachute
  (sbcl-package->ecl-package sbcl-parachute))

(define-public sbcl-array-utils
  (let ((commit "f90eb9070d0b2205af51126a35033574725e5c56")
        (revision "0"))
    (package
      (name "sbcl-array-utils")
      (version (git-version "1.1.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/Shinmera/array-utils")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0zhwfbpr53vs1ii4sx75dz2k9yhh1xpwdqqpg8nmfndxkmhpbi3x"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("parachute" ,sbcl-parachute)))
      (inputs
       `(("documentation-utils" ,sbcl-documentation-utils)))
      (synopsis "Tiny collection of array and vector utilities for Common Lisp")
      (description
       "A miniature toolkit that contains some useful shifting/popping/pushing
functions for arrays and vectors.  Originally from Plump.")
      (home-page "https://shinmera.github.io/array-utils/")
      (license license:zlib))))

(define-public cl-array-utils
  (sbcl-package->cl-source-package sbcl-array-utils))

(define-public ecl-array-utils
  (sbcl-package->ecl-package sbcl-array-utils))

(define-public sbcl-plump
  (let ((commit "34f890fe46efdebe7bb70d218f1937e98f632bf9")
        (revision "1"))
    (package
      (name "sbcl-plump")
      (version (git-version "2.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/Shinmera/plump")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0a0x8wn6vv1ylxcwck12k18gy0a366kdm6ddxxk7yynl4mwnqgkh"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("array-utils" ,sbcl-array-utils)
         ("documentation-utils" ,sbcl-documentation-utils)))
      (synopsis "Lenient XML / XHTML / HTML parser for Common Lisp")
      (description
       "Plump is a parser for HTML/XML-like documents, focusing on being
lenient towards invalid markup.  It can handle things like invalid attributes,
bad closing tag order, unencoded entities, inexistent tag types, self-closing
tags and so on.  It parses documents to a class representation and offers a
small set of DOM functions to manipulate it.  It can be extended to parse to
your own classes.")
      (home-page "https://shinmera.github.io/plump/")
      (license license:zlib))))

(define-public cl-plump
  (sbcl-package->cl-source-package sbcl-plump))

(define-public ecl-plump
  (sbcl-package->ecl-package sbcl-plump))

;;; Split the antik package in two to work around the circular dependency
;;; between antik/antik and antik/gsll.
(define-public sbcl-antik-base
  (let ((commit "e4711a69b3d6bf37b5727af05c3cfd03e8428ba3")
        (revision "1"))
    (package
      (name "sbcl-antik-base")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://gitlab.common-lisp.net/antik/antik.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "047ga2c38par2xbgg4qx6hwv06qhf1c1f67as8xvir6s80lip1km"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cffi" ,sbcl-cffi)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("drakma" ,sbcl-drakma)
         ("fare-utils" ,sbcl-fare-utils)
         ("iterate" ,sbcl-iterate)
         ("metabang-bind" ,sbcl-metabang-bind)
         ("named-readtables" ,sbcl-named-readtables)
         ("split-sequence" ,sbcl-split-sequence)
         ("static-vectors" ,sbcl-static-vectors)
         ("trivial-garbage" ,sbcl-trivial-garbage)
         ("trivial-utf-8" ,sbcl-trivial-utf-8)))
      (native-inputs
       `(("lisp-unit" ,sbcl-lisp-unit)))
      (arguments
       '(#:asd-systems '("antik-base"
                         "foreign-array")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-build
             (lambda _
               (for-each delete-file
                         '("antik.asd"
                           "physical-dimension.asd"
                           "science-data.asd"))
               #t)))))
      (synopsis "Scientific and engineering computation in Common Lisp")
      (description
       "Antik provides a foundation for scientific and engineering
computation in Common Lisp.  It is designed not only to facilitate
numerical computations, but to permit the use of numerical computation
libraries and the interchange of data and procedures, whether
foreign (non-Lisp) or Lisp libraries.  It is named after the
Antikythera mechanism, one of the oldest examples of a scientific
computer known.")
      (home-page "https://common-lisp.net/project/antik/")
      (license license:gpl3))))

(define-public cl-antik-base
  (sbcl-package->cl-source-package sbcl-antik-base))

(define-public ecl-antik-base
  (let ((pkg (sbcl-package->ecl-package sbcl-antik-base)))
    (package
      (inherit pkg)
      (arguments
       (substitute-keyword-arguments (package-arguments pkg)
         ((#:phases phases)
          `(modify-phases ,phases
             (add-after 'unpack 'fix-readtable
               (lambda _
                 (substitute* "input-output/readtable.lisp"
                   (("#-ccl")
                    "#-(or ccl ecl)"))
                 #t)))))))))

(define-public sbcl-gsll
  (let ((commit "1a8ada22f9cf5ed7372d352b2317f4ccdb6ab308")
        (revision "1"))
    (package
      (name "sbcl-gsll")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://gitlab.common-lisp.net/antik/gsll.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0z5nypfk26hxihb08p085644afawicrgb4xvadh3lmrn46qbjfn4"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("lisp-unit" ,sbcl-lisp-unit)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("antik-base" ,sbcl-antik-base)
         ("cffi" ,sbcl-cffi)
         ("gsl" ,gsl)
         ("metabang-bind" ,sbcl-metabang-bind)
         ("trivial-features" ,sbcl-trivial-features)
         ("trivial-garbage" ,sbcl-trivial-garbage)))
      (arguments
       `(#:tests? #f
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-cffi-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "gsll.asd"
                 ((":depends-on \\(#:foreign-array")
                  ":depends-on (#:foreign-array #:cffi-libffi"))
               (substitute* "init/init.lisp"
                 (("libgslcblas.so" all)
                  (string-append
                   (assoc-ref inputs "gsl") "/lib/" all)))
               (substitute* "init/init.lisp"
                 (("libgsl.so" all)
                  (string-append
                   (assoc-ref inputs "gsl") "/lib/" all))))))))
      (synopsis "GNU Scientific Library for Lisp")
      (description
       "The GNU Scientific Library for Lisp (GSLL) allows the use of the
GNU Scientific Library (GSL) from Common Lisp.  This library provides a
full range of common mathematical operations useful to scientific and
engineering applications.  The design of the GSLL interface is such
that access to most of the GSL library is possible in a Lisp-natural
way; the intent is that the user not be hampered by the restrictions
of the C language in which GSL has been written.  GSLL thus provides
interactive use of GSL for getting quick answers, even for someone not
intending to program in Lisp.")
      (home-page "https://common-lisp.net/project/gsll/")
      (license license:gpl3))))

(define-public cl-gsll
  (sbcl-package->cl-source-package sbcl-gsll))

(define-public ecl-gsll
  (sbcl-package->ecl-package sbcl-gsll))

(define-public sbcl-antik
  (package
    (inherit sbcl-antik-base)
    (name "sbcl-antik")
    (inputs
     `(("antik-base" ,sbcl-antik-base)
       ("gsll" ,sbcl-gsll)))
    (arguments
     '(#:asd-systems '("antik"
                       "science-data")
       #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-build
             (lambda _
               (for-each delete-file
                         '("antik-base.asd"
                           "foreign-array.asd"))
               #t)))))))

(define-public cl-antik
  (sbcl-package->cl-source-package sbcl-antik))

(define-public sbcl-cl-interpol
  (let ((commit "1fd288d861db85bc4677cff3cdd6af75fda1afb4")
        (revision "1"))
    (package
      (name "sbcl-cl-interpol")
      (version (git-version "0.2.6" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/edicl/cl-interpol")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1hnikak52hmcq1r5f616m6qq1108qnkw80pja950nv1fq5p0ppjn"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cl-unicode" ,sbcl-cl-unicode)
         ("named-readtables" ,sbcl-named-readtables)))
      (native-inputs
       `(("flexi-streams" ,sbcl-flexi-streams)))
      (synopsis "String interpolation for Common Lisp")
      (description
       "CL-INTERPOL is a library for Common Lisp which modifies the
reader so that you can have interpolation within strings similar to
Perl or Unix Shell scripts.  It also provides various ways to insert
arbitrary characters into literal strings even if your editor/IDE
doesn't support them.")
      (home-page "https://edicl.github.io/cl-interpol/")
      (license license:bsd-3))))

(define-public cl-interpol
  (sbcl-package->cl-source-package sbcl-cl-interpol))

(define-public ecl-cl-interpol
  (sbcl-package->ecl-package sbcl-cl-interpol))

(define-public sbcl-symbol-munger
  (let ((commit "97598d4c3c53fd5da72ab78908fbd5d8c7a13416")
        (revision "1"))
    (package
      (name "sbcl-symbol-munger")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/AccelerationNet/symbol-munger")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0y8jywjy0ldyhp7bxf16fdvdd2qgqnd7nlhlqfpfnzxcqk4xy1km"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("iterate" ,sbcl-iterate)))
      (arguments
       ;; There is a cyclical dependency between symbol-munger and lisp-unit2.
       ;; See https://github.com/AccelerationNet/symbol-munger/issues/4
       '(#:tests? #f))
      (synopsis
       "Capitalization and spacing conversion functions for Common Lisp")
      (description
       "This is a Common Lisp library to change the capitalization and spacing
of a string or a symbol.  It can convert to and from Lisp, english, underscore
and camel-case rules.")
      (home-page "https://github.com/AccelerationNet/symbol-munger")
      ;; The package declares a BSD license, but all of the license
      ;; text is MIT.
      ;; See https://github.com/AccelerationNet/symbol-munger/issues/5
      (license license:expat))))

(define-public cl-symbol-munger
  (sbcl-package->cl-source-package sbcl-symbol-munger))

(define-public ecl-symbol-munger
  (sbcl-package->ecl-package sbcl-symbol-munger))

(define-public sbcl-lisp-unit2
  ;; There is a cyclical dependency between symbol-munger and lisp-unit2.
  ;; See https://github.com/AccelerationNet/symbol-munger/issues/4
  (let ((commit "fb9721524d1e4e73abb223ee036d74ce14a5505c")
        (revision "1"))
    (package
      (name "sbcl-lisp-unit2")
      (version (git-version "0.2.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/AccelerationNet/lisp-unit2")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1rsqy8y0jqll6xn9a593848f5wvd5ribv4csry1ly0hmdhfnqzlp"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-interpol" ,sbcl-cl-interpol)
         ("iterate" ,sbcl-iterate)
         ("symbol-munger" ,sbcl-symbol-munger)))
      (synopsis "Test Framework for Common Lisp")
      (description
       "LISP-UNIT2 is a Common Lisp library that supports unit testing in the
style of JUnit for Java.  It is a new version of the lisp-unit library written
by Chris Riesbeck.")
      (home-page "https://github.com/AccelerationNet/lisp-unit2")
      (license license:expat))))

(define-public cl-lisp-unit2
  (sbcl-package->cl-source-package sbcl-lisp-unit2))

(define-public ecl-lisp-unit2
  (sbcl-package->ecl-package sbcl-lisp-unit2))

(define-public sbcl-cl-csv
  (let ((commit "68ecb5d816545677513d7f6308d9e5e8d2265651")
        (revision "2"))
    (package
      (name "sbcl-cl-csv")
      (version (git-version "1.0.6" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/AccelerationNet/cl-csv")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0gcmlbwx5m3kwgk12qi80w08ak8fgdnvyia429fz6gnxmhg0k54x"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; See: https://github.com/AccelerationNet/cl-csv/pull/34
       `(#:tests? #f))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-interpol" ,sbcl-cl-interpol)
         ("iterate" ,sbcl-iterate)))
      (native-inputs
       `(("lisp-unit2" ,sbcl-lisp-unit2)))
      (synopsis "Common lisp library for comma-separated values")
      (description
       "This is a Common Lisp library providing functions to read/write CSV
from/to strings, streams and files.")
      (home-page "https://github.com/AccelerationNet/cl-csv")
      (license license:bsd-3))))

(define-public cl-csv
  (sbcl-package->cl-source-package sbcl-cl-csv))

(define-public ecl-cl-csv
  (sbcl-package->ecl-package sbcl-cl-csv))

(define-public sbcl-external-program
  (let ((commit "5888b8f1fd3953feeeacecbba4384ddda584a749")
        (revision "1"))
    (package
      (name "sbcl-external-program")
      (version (git-version "0.0.6" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/sellout/external-program")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0vww1x3yilb3bjwg6k184vaj4vxyxw4vralhnlm6lk4xac67kc9z"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("trivial-features" ,sbcl-trivial-features)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (synopsis "Common Lisp library for running external programs")
      (description
       "EXTERNAL-PROGRAM enables running programs outside the Lisp
process.  It is an attempt to make the RUN-PROGRAM functionality in
implementations like SBCL and CCL as portable as possible without
sacrificing much in the way of power.")
      (home-page "https://github.com/sellout/external-program")
      (license license:llgpl))))

(define-public cl-external-program
  (sbcl-package->cl-source-package sbcl-external-program))

(define-public ecl-external-program
  (sbcl-package->ecl-package sbcl-external-program))

(define-public sbcl-cl-ana
  (let ((commit "fa7cee4c50aa1c859652813049ba0da7c18a0df9")
        (revision "1"))
    (package
     (name "sbcl-cl-ana")
     (version (git-version "0.0.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ghollisjr/cl-ana")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0mr47l57m276dbpap7irr4fcnk5fgknhf6mgv4043s8h73amk5qh"))))
     (build-system asdf-build-system/sbcl)
     (native-inputs
      `(("cl-fad" ,sbcl-cl-fad)))
     (inputs
      `(("alexandria" ,sbcl-alexandria)
        ("antik" ,sbcl-antik)
        ("cffi" ,sbcl-cffi)
        ("cl-csv" ,sbcl-cl-csv)
        ("closer-mop" ,sbcl-closer-mop)
        ("external-program" ,sbcl-external-program)
        ("gsl" ,gsl)
        ("gsll" ,sbcl-gsll)
        ("hdf5" ,hdf5-parallel-openmpi)
        ("iterate" ,sbcl-iterate)
        ("libffi" ,libffi)
        ("split-sequence" ,sbcl-split-sequence)))
     (arguments
      `(#:phases
        (modify-phases %standard-phases
          (add-after 'unpack 'fix-paths
            (lambda* (#:key inputs #:allow-other-keys)
              (substitute* "hdf-cffi/hdf-cffi.lisp"
                (("/usr/lib/i386-linux-gnu/hdf5/serial/libhdf5.so")
                 (string-append (assoc-ref inputs "hdf5")
                                "/lib/libhdf5.so")))
              (substitute* "gsl-cffi/gsl-cffi.lisp"
                (("define-foreign-library gsl-cffi" all)
                 (string-append all " (:unix "
                                (assoc-ref inputs "gsl")
                                "/lib/libgsl.so)")))
              #t)))))
     (synopsis "Common Lisp data analysis library")
     (description
      "CL-ANA is a data analysis library in Common Lisp providing tabular and
binned data analysis along with nonlinear least squares fitting and
visualization.")
     (home-page "https://github.com/ghollisjr/cl-ana")
     (license license:gpl3))))

(define-public cl-ana
  (sbcl-package->cl-source-package sbcl-cl-ana))

(define-public sbcl-archive
  (let ((commit "631271c091ed02994bec3980cb288a2cf32c7cdc")
        (revision "1"))
    (package
      (name "sbcl-archive")
      (version (git-version "0.9" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/sharplispers/archive")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0pvsc9fmybx7rxd0kmzq4shi6hszdpwdc1sfy7jwyfxf8n3hnv4p"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cl-fad" ,sbcl-cl-fad)
         ("trivial-gray-streams" ,sbcl-trivial-gray-streams)))
      (synopsis "Common Lisp library for tar and cpio archives")
      (description
       "This is a Common Lisp library to read and write disk-based file
archives such as those generated by the tar and cpio programs on Unix.")
      (home-page "https://github.com/sharplispers/archive")
      (license license:bsd-3))))

(define-public cl-archive
  (sbcl-package->cl-source-package sbcl-archive))

(define-public ecl-archive
  (sbcl-package->ecl-package sbcl-archive))

(define-public sbcl-misc-extensions
  (let ((commit "101c05112bf2f1e1bbf527396822d2f50ca6327a")
        (revision "1"))
    (package
      (name "sbcl-misc-extensions")
      (version (git-version "3.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://gitlab.common-lisp.net/misc-extensions/devel.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0gz5f4p70qzilnxsnf5lih2n9m4wjcw8hlw4w8mpn9jyhyppyyv0"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Collection of small macros and extensions for Common Lisp")
      (description
       "This project is intended as a catchall for small, general-purpose
extensions to Common Lisp.  It contains:

@itemize
@item @code{new-let}, a macro that combines and generalizes @code{let},
@code{let*} and @code{multiple-value-bind},
@item @code{gmap}, an iteration macro that generalizes @code{map}.
@end itemize\n")
      (home-page "https://common-lisp.net/project/misc-extensions/")
      (license license:public-domain))))

(define-public cl-misc-extensions
  (sbcl-package->cl-source-package sbcl-misc-extensions))

(define-public ecl-misc-extensions
  (sbcl-package->ecl-package sbcl-misc-extensions))

(define-public sbcl-mt19937
  (package
    (name "sbcl-mt19937")
    (version "1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://common-lisp.net/project/asdf-packaging/"
                           "mt19937-latest.tar.gz"))
       (sha256
        (base32
         "1iw636b0iw5ygkv02y8i41lh7xj0acglv0hg5agryn0zzi2nf1xv"))))
    (build-system asdf-build-system/sbcl)
    (synopsis "Mersenne Twister pseudo-random number generator")
    (description
     "MT19937 is a portable Mersenne Twister pseudo-random number generator
for Common Lisp.")
    (home-page "https://www.cliki.net/mt19937")
    (license license:public-domain)))

(define-public cl-mt19937
  (sbcl-package->cl-source-package sbcl-mt19937))

(define-public ecl-mt19937
  (sbcl-package->ecl-package sbcl-mt19937))

(define-public sbcl-fset
  (let ((commit "6d2f9ded8934d2b42f2571a0ba5bda091037d852")
        (revision "1"))
    (package
      (name "sbcl-fset")
      (version (git-version "1.3.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/slburson/fset")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "127acblwrbqicx47h6sgvknz1cqyfn8p4xkhkn1m7hxh8w5gk1zy"))
         (snippet '(begin
                     ;; Remove obsolete copy of system definition.
                     (delete-file "Code/fset.asd")
                     #t))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("misc-extensions" ,sbcl-misc-extensions)
         ("mt19937" ,sbcl-mt19937)
         ("named-readtables" ,sbcl-named-readtables)))
      (synopsis "Functional set-theoretic collections library")
      (description
       "FSet is a functional set-theoretic collections library for Common Lisp.
Functional means that all update operations return a new collection rather than
modifying an existing one in place.  Set-theoretic means that collections may
be nested arbitrarily with no additional programmer effort; for instance, sets
may contain sets, maps may be keyed by sets, etc.")
      (home-page "https://common-lisp.net/project/fset/Site/index.html")
      (license license:llgpl))))

(define-public cl-fset
  (sbcl-package->cl-source-package sbcl-fset))

(define-public ecl-fset
  (package
    (inherit (sbcl-package->ecl-package sbcl-fset))
    (arguments
     ;; Tests fails on ECL with "The function FSET::MAKE-CHAR is undefined".
     '(#:tests? #f))))

(define-public sbcl-cl-cont
  (let ((commit "fc1fa7e6eb64894fdca13e688e6015fad5290d2a")
        (revision "1"))
    (package
      (name "sbcl-cl-cont")
      (version (git-version "0.3.8" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://gitlab.common-lisp.net/cl-cont/cl-cont.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1zf8zvb0i6jm3hhfks4w74hibm6avgc6f9s1qwgjrn2bcik8lrvz"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("closer-mop" ,sbcl-closer-mop)))
      (native-inputs
       `(("rt" ,sbcl-rt)))
      (synopsis "Delimited continuations for Common Lisp")
      (description
       "This is a library that implements delimited continuations by
transforming Common Lisp code to continuation passing style.")
      (home-page "https://common-lisp.net/project/cl-cont/")
      (license license:llgpl))))

(define-public cl-cont
  (sbcl-package->cl-source-package sbcl-cl-cont))

(define-public ecl-cl-cont
  (sbcl-package->ecl-package sbcl-cl-cont))

(define-public sbcl-cl-coroutine
  (let ((commit "de098f8d5debd8b14ef6864b5bdcbbf5ddbcfd72")
        (revision "1"))
    (package
      (name "sbcl-cl-coroutine")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/takagi/cl-coroutine")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1cqdhdjxffgfs116l1swjlsmcbly0xgcgrckvaajd566idj9yj4l"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-cont" ,sbcl-cl-cont)))
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (arguments
       `(;; TODO: Fix the tests. They fail with:
         ;; "Component CL-COROUTINE-ASD::CL-COROUTINE-TEST not found"
         #:tests? #f
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-tests
             (lambda _
               (substitute* "cl-coroutine-test.asd"
                 (("cl-test-more")
                  "prove"))
               #t)))))
      (synopsis "Coroutine library for Common Lisp")
      (description
       "This is a coroutine library for Common Lisp implemented using the
continuations of the @code{cl-cont} library.")
      (home-page "https://github.com/takagi/cl-coroutine")
      (license license:llgpl))))

(define-public cl-coroutine
  (sbcl-package->cl-source-package sbcl-cl-coroutine))

(define-public ecl-cl-coroutine
  (sbcl-package->ecl-package sbcl-cl-coroutine))

(define-public sbcl-vom
  (let ((commit "1aeafeb5b74c53741b79497e0ef4acf85c92ff24")
        (revision "1"))
    (package
      (name "sbcl-vom")
      (version (git-version "0.1.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/orthecreedence/vom")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0536kppj76ax4lrxhv42npkfjsmx45km2g439vf9jmw3apinz9cy"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Tiny logging utility for Common Lisp")
      (description
       "Vom is a logging library for Common Lisp.  It's goal is to be useful
and small.  It does not provide a lot of features as other loggers do, but
has a small codebase that's easy to understand and use.")
      (home-page "https://github.com/orthecreedence/vom")
      (license license:expat))))

(define-public cl-vom
  (sbcl-package->cl-source-package sbcl-vom))

(define-public ecl-vom
  (sbcl-package->ecl-package sbcl-vom))

(define-public sbcl-cl-libuv
  (let ((commit "32100c023c518038d0670a103eaa4d50dd785d29")
        (revision "1"))
    (package
      (name "sbcl-cl-libuv")
      (version (git-version "0.1.6" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/orthecreedence/cl-libuv")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1kwix4si8a8hza34ab2k7whrh7z0yrmx39v2wc3qblv9m244jkh1"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cffi" ,sbcl-cffi)
         ("libuv" ,libuv)))
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "lib.lisp"
                 (("/usr/lib/libuv.so")
                  (string-append (assoc-ref inputs "libuv")
                                 "/lib/libuv.so")))
               #t))
           (add-after 'fix-paths 'fix-system-definition
             (lambda _
               (substitute* "cl-libuv.asd"
                 (("#:cffi #:alexandria")
                  "#:cffi #:cffi-grovel #:alexandria"))
               #t)))))
      (synopsis "Common Lisp bindings to libuv")
      (description
       "This library provides low-level libuv bindings for Common Lisp.")
      (home-page "https://github.com/orthecreedence/cl-libuv")
      (license license:expat))))

(define-public cl-libuv
  (sbcl-package->cl-source-package sbcl-cl-libuv))

(define-public ecl-cl-libuv
  (sbcl-package->ecl-package sbcl-cl-libuv))

(define-public sbcl-cl-async
  (let ((commit "f6423e44404a44434d803605e0d2e17199158e28")
        (revision "1"))
    (package
      (name "sbcl-cl-async")
      (version (git-version "0.6.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/orthecreedence/cl-async")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "11xi9dxb8mjgwzrkj88i0xkgk26z9w9ddxzbv6xsvfc1d4x5cf4x"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("babel" ,sbcl-babel)
         ("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("cffi" ,sbcl-cffi)
         ("cl-libuv" ,sbcl-cl-libuv)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("fast-io" ,sbcl-fast-io)
         ("openssl" ,openssl)
         ("static-vectors" ,sbcl-static-vectors)
         ("trivial-features" ,sbcl-trivial-features)
         ("trivial-gray-streams" ,sbcl-trivial-gray-streams)
         ("vom" ,sbcl-vom)))
      (arguments
       `(#:asd-systems '("cl-async"
                         "cl-async-repl"
                         "cl-async-ssl")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "src/ssl/package.lisp"
                 (("libcrypto\\.so")
                  (string-append (assoc-ref inputs "openssl")
                                 "/lib/libcrypto.so"))
                 (("libssl\\.so")
                  (string-append (assoc-ref inputs "openssl")
                                 "/lib/libssl.so")))
               #t)))))
      (synopsis "Asynchronous operations for Common Lisp")
      (description
       "Cl-async is a library for general purpose, non-blocking programming in
Common Lisp.  It uses the libuv library as backend.")
      (home-page "https://orthecreedence.github.io/cl-async/")
      (license license:expat))))

(define-public cl-async
  (sbcl-package->cl-source-package sbcl-cl-async))

(define-public ecl-cl-async
  (sbcl-package->ecl-package sbcl-cl-async))

(define-public sbcl-blackbird
  (let ((commit "d361f81c1411dec07f6c2dcb11c78f7aea9aaca8")
        (revision "1"))
    (package
      (name "sbcl-blackbird")
      (version (git-version "0.5.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/orthecreedence/blackbird")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0xfds5yaya64arzr7w1x38karyz11swzbhxx1afldpradj9dh19c"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("vom" ,sbcl-vom)))
      (native-inputs
       `(("cl-async" ,sbcl-cl-async)
         ("fiveam" ,sbcl-fiveam)))
      (synopsis "Promise implementation for Common Lisp")
      (description
       "This is a standalone promise implementation for Common Lisp.  It is
the successor to the now-deprecated cl-async-future project.")
      (home-page "https://orthecreedence.github.io/blackbird/")
      (license license:expat))))

(define-public cl-blackbird
  (sbcl-package->cl-source-package sbcl-blackbird))

(define-public ecl-blackbird
  (sbcl-package->ecl-package sbcl-blackbird))

(define-public sbcl-cl-async-future
  (let ((commit "ee36c22a69a9516407458d2ed8b475f1fc473959")
        (revision "1"))
    (package
      (name "sbcl-cl-async-future")
      (version (git-version "0.4.4.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/orthecreedence/cl-async-future")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0z0sc7qlzzxk99f4l26zp6rai9kv0kj0f599sxai5s44p17zbbvh"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("blackbird" ,sbcl-blackbird)))
      (native-inputs
       `(("cl-async" ,sbcl-cl-async)
         ("eos" ,sbcl-eos)))
      (synopsis "Futures implementation for Common Lisp")
      (description
       "This is futures implementation for Common Lisp.  It plugs in nicely
to cl-async.")
      (home-page "https://orthecreedence.github.io/cl-async/future")
      (license license:expat))))

(define-public cl-async-future
  (sbcl-package->cl-source-package sbcl-cl-async-future))

(define-public ecl-cl-async-future
  (sbcl-package->ecl-package sbcl-cl-async-future))

(define-public sbcl-green-threads
  (let ((commit "fff5ebecb441a37e5c511773716aafd84a3c5840")
        (revision "1"))
    (package
      (name "sbcl-green-threads")
      (version (git-version "0.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/thezerobit/green-threads")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1czw7nr0dwfps76h8hjvglk1wdh53yqbfbvv30whwbgqx33iippz"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cl-async-future" ,sbcl-cl-async-future)
         ("cl-cont" ,sbcl-cl-cont)))
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (arguments
       `(;; TODO: Fix the tests. They fail with:
         ;; "The function BLACKBIRD::PROMISE-VALUES is undefined"
         #:tests? #f
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-tests
             (lambda _
               (substitute* "green-threads-test.asd"
                 (("cl-test-more")
                  "prove"))
               #t)))))
      (synopsis "Cooperative multitasking library for Common Lisp")
      (description
       "This library allows for cooperative multitasking with help of cl-cont
for continuations.  It tries to mimic the API of bordeaux-threads as much as
possible.")
      (home-page "https://github.com/thezerobit/green-threads")
      (license license:bsd-3))))

(define-public cl-green-threads
  (sbcl-package->cl-source-package sbcl-green-threads))

(define-public ecl-green-threads
  (sbcl-package->ecl-package sbcl-green-threads))

(define-public sbcl-cl-base32
  (let ((commit "8cdee06fab397f7b0a19583b57e7f0c98405be85")
        (revision "1"))
    (package
      (name "sbcl-cl-base32")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/hargettp/cl-base32")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "17jrng8jb05d64ggyd11hp308c2fl5drvf9g175blgrkkl8l4mf8"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("lisp-unit" ,sbcl-lisp-unit)))
      (synopsis "Common Lisp library for base32 encoding and decoding")
      (description
       "This package provides functions for base32 encoding and decoding as
defined in RFC4648.")
      (home-page "https://github.com/hargettp/cl-base32")
      (license license:expat))))

(define-public cl-base32
  (sbcl-package->cl-source-package sbcl-cl-base32))

(define-public ecl-cl-base32
  (sbcl-package->ecl-package sbcl-cl-base32))

(define-public sbcl-cl-z85
  (let ((commit "85b3951a9cfa2603acb6aee15567684f9a108098")
        (revision "1"))
    (package
      (name "sbcl-cl-z85")
      (version (git-version "1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/glv2/cl-z85")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0r27pidjaxbm7k1rr90nnajwl5xm2kp65g1fv0fva17lzy45z1mp"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("cl-octet-streams" ,sbcl-cl-octet-streams)
         ("fiveam" ,sbcl-fiveam)))
      (synopsis "Common Lisp library for Z85 encoding and decoding")
      (description
       "This package provides functions to encode or decode byte vectors or
byte streams using the Z85 format, which is a base-85 encoding used by
ZeroMQ.")
      (home-page "https://github.com/glv2/cl-z85")
      (license license:gpl3+))))

(define-public cl-z85
  (sbcl-package->cl-source-package sbcl-cl-z85))

(define-public ecl-cl-z85
  (sbcl-package->ecl-package sbcl-cl-z85))

(define-public sbcl-ltk
  (package
    (name "sbcl-ltk")
    (version "0.992")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/herth/ltk")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "13l2q4mskzilya9xh5wy2xvy30lwn104bd8wrq6ifds56r82iy3x"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("imagemagick" ,imagemagick)
       ("tk" ,tk)))
    (arguments
     `(#:asd-systems '("ltk"
                       "ltk-mw"
                       "ltk-remote")
       #:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "ltk/ltk.lisp"
               (("#-freebsd \"wish\"")
                (string-append "#-freebsd \""
                               (assoc-ref inputs "tk")
                               "/bin/wish\""))
               (("do-execute \"convert\"")
                (string-append "do-execute \""
                               (assoc-ref inputs "imagemagick")
                               "/bin/convert\"")))
             #t))
         (add-after 'unpack 'fix-build
           (lambda _
             (substitute* "ltk/ltk-remote.lisp"
               (("\\(:export")
                "(:shadow #:raise) (:export"))
             #t)))))
    (synopsis "Common Lisp bindings for the Tk GUI toolkit")
    (description
     "LTK is a Common Lisp binding for the Tk graphics toolkit.  It is written
in pure Common Lisp and does not require any Tk knowledge for its usage.")
    (home-page "http://www.peter-herth.de/ltk/")
    (license license:llgpl)))

(define-public cl-ltk
  (sbcl-package->cl-source-package sbcl-ltk))

(define-public ecl-ltk
  (sbcl-package->ecl-package sbcl-ltk))

(define-public sbcl-cl-lex
  (let ((commit "f2dbbe25ef553005fb402d9a6203180c3fa1093b")
        (revision "1"))
    (package
      (name "sbcl-cl-lex")
      (version (git-version "1.1.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/djr7C4/cl-lex")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1kg50f76bfpfxcv4dfivq1n9a0xlsra2ajb0vd68lxwgbidgyc2y"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cl-ppcre" ,sbcl-cl-ppcre)))
      (synopsis "Common Lisp macros for generating lexical analyzers")
      (description
       "This is a Common Lisp library providing a set of macros for generating
lexical analyzers automatically.  The lexers generated using @code{cl-lex} can
be used with @code{cl-yacc}.")
      (home-page "https://github.com/djr7C4/cl-lex")
      (license license:gpl3))))

(define-public cl-lex
  (sbcl-package->cl-source-package sbcl-cl-lex))

(define-public ecl-cl-lex
  (sbcl-package->ecl-package sbcl-cl-lex))

(define-public sbcl-clunit2
  (let ((commit "5e28343734eb9b7aee39306a614af92c1062d50b")
        (revision "1"))
    (package
      (name "sbcl-clunit2")
      (version (git-version "0.2.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://notabug.org/cage/clunit2.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1ngiapfki6nm8a555mzhb5p7ch79i3w665za5bmb5j7q34fy80vw"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Unit testing framework for Common Lisp")
      (description
       "CLUnit is a Common Lisp unit testing framework.  It is designed to be
easy to use so that you can quickly start testing.")
      (home-page "https://notabug.org/cage/clunit2")
      (license license:expat))))

(define-public cl-clunit2
  (sbcl-package->cl-source-package sbcl-clunit2))

(define-public ecl-clunit2
  (sbcl-package->ecl-package sbcl-clunit2))

(define-public sbcl-cl-colors2
  (let ((commit "795aedee593b095fecde574bd999b520dd03ed24")
        (revision "1"))
    (package
      (name "sbcl-cl-colors2")
      (version (git-version "0.2.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://notabug.org/cage/cl-colors2.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0hlyf4h5chkjdp9armla5w4kw5acikk159sym7y8c4jbjp9x47ih"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("clunit2" ,sbcl-clunit2)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-ppcre" ,sbcl-cl-ppcre)))
      (synopsis "Color library for Common Lisp")
      (description
       "This is a very simple color library for Common Lisp, providing:

@itemize
@item Types for representing colors in HSV and RGB spaces.
@item Simple conversion functions between the above types (and also
hexadecimal representation for RGB).
@item Some predefined colors (currently X11 color names -- of course
the library does not depend on X11).
@end itemize\n")
      (home-page "https://notabug.org/cage/cl-colors2")
      (license license:boost1.0))))

(define-public cl-colors2
  (sbcl-package->cl-source-package sbcl-cl-colors2))

(define-public ecl-cl-colors2
  (sbcl-package->ecl-package sbcl-cl-colors2))

(define-public sbcl-cl-jpeg
  (let ((commit "ec557038128df6895fbfb743bfe8faf8ec2534af")
        (revision "1"))
    (package
      (name "sbcl-cl-jpeg")
      (version (git-version "2.8" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/sharplispers/cl-jpeg")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1bkkiqz8fqldlj1wbmrccjsvxcwj98h6s4b6gslr3cg2wmdv5xmy"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "JPEG image library for Common Lisp")
      (description
       "This is a baseline JPEG codec written in Common Lisp.  It can be used
for reading and writing JPEG image files.")
      (home-page "https://github.com/sharplispers/cl-jpeg")
      (license license:bsd-3))))

(define-public cl-jpeg
  (sbcl-package->cl-source-package sbcl-cl-jpeg))

(define-public ecl-cl-jpeg
  (sbcl-package->ecl-package sbcl-cl-jpeg))

(define-public sbcl-nodgui
  (let ((commit "bc59ed9b787dfc9e68ae3bd7f7e8507c5c619212")
        (revision "1"))
    (package
      (name "sbcl-nodgui")
      (version (git-version "0.0.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://notabug.org/cage/nodgui.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0xx0dk54d882i598ydnwmy7mnfk0b7vib3ddsgpqxhjck1rwq8l8"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("cl-colors2" ,sbcl-cl-colors2)
         ("cl-jpeg" ,sbcl-cl-jpeg)
         ("cl-lex" ,sbcl-cl-lex)
         ("cl-ppcre-unicode" ,sbcl-cl-ppcre-unicode)
         ("cl-unicode" ,sbcl-cl-unicode)
         ("cl-yacc" ,sbcl-cl-yacc)
         ("clunit2" ,sbcl-clunit2)
         ("named-readtables" ,sbcl-named-readtables)
         ("parse-number" ,sbcl-parse-number)
         ("tk" ,tk)))
      (arguments
       `(#:phases (modify-phases %standard-phases
                    (add-after 'unpack 'fix-paths
                      (lambda* (#:key inputs #:allow-other-keys)
                        (substitute* "src/wish-communication.lisp"
                          (("#-freebsd \"wish\"")
                           (string-append "#-freebsd \""
                                          (assoc-ref inputs "tk")
                                          "/bin/wish\"")))
                        #t)))))
      (synopsis "Common Lisp bindings for the Tk GUI toolkit")
      (description
       "Nodgui (@emph{No Drama GUI}) is a Common Lisp binding for the Tk GUI
toolkit.  It also provides a few additional widgets more than the standard Tk
ones.")
      (home-page "https://www.autistici.org/interzona/nodgui.html")
      (license license:llgpl))))

(define-public cl-nodgui
  (sbcl-package->cl-source-package sbcl-nodgui))

(define-public ecl-nodgui
  (sbcl-package->ecl-package sbcl-nodgui))

(define-public sbcl-salza2
  (package
    (name "sbcl-salza2")
    (version "2.0.9")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/xach/salza2")
             (commit (string-append "release-" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0p38rj4gq7j5k807php7hrz7l2zyyfshv8i9yms7i8lkgg3433ki"))))
    (build-system asdf-build-system/sbcl)
    (synopsis "Common Lisp library for zlib, deflate and gzip compression")
    (description
     "Salza2 is a Common Lisp library for creating compressed data in the zlib,
deflate, or gzip data formats, described in RFC 1950, RFC 1951, and RFC 1952,
respectively.")
    (home-page "https://www.xach.com/lisp/salza2/")
    (license license:bsd-2)))

(define-public cl-salza2
  (sbcl-package->cl-source-package sbcl-salza2))

(define-public ecl-salza2
  (sbcl-package->ecl-package sbcl-salza2))

(define-public sbcl-png-read
  (let ((commit "ec29f38a689972b9f1373f13bbbcd6b05deada88")
        (revision "1"))
    (package
      (name "sbcl-png-read")
      (version (git-version "0.3.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Ramarren/png-read")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0vyczbcwskrygrf1hgrsnk0jil8skmvf1kiaalw5jps4fjrfdkw0"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("babel" ,sbcl-babel)
         ("chipz" ,sbcl-chipz)
         ("iterate" ,sbcl-iterate)))
      (synopsis "PNG decoder for Common Lisp")
      (description "This is a Common Lisp library for reading PNG images.")
      (home-page "https://github.com/Ramarren/png-read")
      (license license:bsd-3))))

(define-public cl-png-read
  (sbcl-package->cl-source-package sbcl-png-read))

(define-public ecl-png-read
  (sbcl-package->ecl-package sbcl-png-read))

(define-public sbcl-zpng
  (package
    (name "sbcl-zpng")
    (version "1.2.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/xach/zpng")
             (commit (string-append "release-" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0b3ag3jhl3z7kdls3ahdsdxsfhhw5qrizk769984f4wkxhb69rcm"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("salza2" ,sbcl-salza2)))
    (synopsis "PNG encoder for Common Lisp")
    (description "This is a Common Lisp library for creating PNG images.")
    (home-page "https://www.xach.com/lisp/zpng/")
    (license license:bsd-2)))

(define-public cl-zpng
  (sbcl-package->cl-source-package sbcl-zpng))

(define-public ecl-zpng
  (sbcl-package->ecl-package sbcl-zpng))

(define-public sbcl-cl-qrencode
  (package
    (name "sbcl-cl-qrencode")
    (version "0.1.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jnjcc/cl-qrencode")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1l5k131dchbf6cj8a8xqa731790p01p3qa1kdy2wa9dawy3ymkxr"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("lisp-unit" ,sbcl-lisp-unit)))
    (inputs
     `(("zpng" ,sbcl-zpng)))
    (synopsis "QR code encoder for Common Lisp")
    (description
     "This Common Lisp library provides function to make QR codes and to save
them as PNG files.")
    (home-page "https://github.com/jnjcc/cl-qrencode")
    (license license:gpl2+)))

(define-public cl-qrencode
  (sbcl-package->cl-source-package sbcl-cl-qrencode))

(define-public ecl-cl-qrencode
  (sbcl-package->ecl-package sbcl-cl-qrencode))

(define-public sbcl-hdf5-cffi
  (let ((commit "5b5c88f191e470e4fe96b462334e3ce0806eed5c")
        (revision "1"))
    (package
      (name "sbcl-hdf5-cffi")
      (version (git-version "1.8.18" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/hdfgroup/hdf5-cffi")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0vda3075423xz83qky998lpac5b04dwfv7bwgh9jq8cs5v0zrxjf"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Common Lisp bindings for the HDF5 library")
      (description
       "@code{hdf5-cffi} is a CFFI wrapper for the HDF5 library.")
      (home-page "https://github.com/hdfgroup/hdf5-cffi")
      (license (license:non-copyleft
                (string-append "https://github.com/HDFGroup/hdf5-cffi/raw/"
                               commit
                               "/LICENSE")))
      (inputs
       `(("cffi" ,sbcl-cffi)
         ("hdf5" ,hdf5-1.10)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       `(#:test-asd-file "hdf5-cffi.test.asd"
         ;; Tests depend on hdf5-cffi.examples.asd in addition to hdf5-cffi.asd,
         ;; I don't know if there is a way to tell asdf-build-system to load
         ;; an additional system first, so tests are disabled.
         #:tests? #f
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "src/library.lisp"
                 (("libhdf5.so")
                  (string-append
                   (assoc-ref inputs "hdf5")
                   "/lib/libhdf5.so")))))
           (add-after 'unpack 'fix-dependencies
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "hdf5-cffi.asd"
                 ((":depends-on \\(:cffi\\)")
                  ":depends-on (:cffi :cffi-grovel)"))
               (substitute* "hdf5-cffi.test.asd"
                 ((":depends-on \\(:cffi :hdf5-cffi")
                  ":depends-on (:cffi :cffi-grovel :hdf5-cffi"))))))))))

(define-public cl-hdf5-cffi
  (sbcl-package->cl-source-package sbcl-hdf5-cffi))

(define-public ecl-hdf5-cffi
  (sbcl-package->ecl-package sbcl-hdf5-cffi))

(define-public sbcl-cl-randist
  (package
    (name "sbcl-cl-randist")
    (version "0.4.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/lvaruzza/cl-randist")
             (commit "f088a54b540a7adefab7c04094a6103f9edda3d0")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0l8hyd6nbxb7f50vyxz3rbbm7kgr1fnadc40jywy4xj5vi5kpj5g"))))
    (build-system asdf-build-system/sbcl)
    (synopsis "Random distributions for Common Lisp")
    (description
     "Manual translation from C to Common Lisp of some random number
generation functions from the GSL library.")
    (home-page "https://github.com/lvaruzza/cl-randist")
    (license license:bsd-2)
    (arguments
     `(#:tests? #f))))

(define-public cl-randist
  (sbcl-package->cl-source-package sbcl-cl-randist))

(define-public ecl-cl-randist
  (sbcl-package->ecl-package sbcl-cl-randist))

(define-public sbcl-float-features
  (package
    (name "sbcl-float-features")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Shinmera/float-features")
             (commit "d3ef60181635b0849aa28cfc238053b7ca4644b0")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0yj419k7n59x6rh3grwr6frgwwyria2il6f7wxpfazm8cskv4lzr"))))
    (build-system asdf-build-system/sbcl)
    (synopsis "Common Lisp IEEE float portability library")
    (description
     "Portability library for IEEE float features that are not
covered by the Common Lisp standard.")
    (home-page "https://github.com/Shinmera/float-features")
    (license license:zlib)
    (inputs
     `(("documentation-utils" ,sbcl-documentation-utils)))
    (arguments
     `(#:tests? #f))))

(define-public cl-float-features
  (sbcl-package->cl-source-package sbcl-float-features))

(define-public ecl-float-features
  (sbcl-package->ecl-package sbcl-float-features))

(define-public sbcl-function-cache
  (package
    (name "sbcl-function-cache")
    (version "1.0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/AccelerationNet/function-cache")
             (commit "6a5ada401e57da2c8abf046f582029926e61fce8")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "000vmd3f5rx5hs9nvphfric0gkzaadns31c6mxaslpv0k7pkrmc6"))))
    (build-system asdf-build-system/sbcl)
    (synopsis "Function caching / memoization library for Common Lisp")
    (description
     "A common lisp library that provides extensible function result
caching based on arguments (an expanded form of memoization).")
    (home-page "https://github.com/AccelerationNet/function-cache")
    (license
     (license:non-copyleft
      "https://github.com/AccelerationNet/function-cache/blob/master/README.md"))
    (inputs
     `(("alexandria" ,sbcl-alexandria)
       ("cl-interpol" ,sbcl-cl-interpol)
       ("iterate" ,sbcl-iterate)
       ("symbol-munger" ,sbcl-symbol-munger)
       ("closer-mop" ,sbcl-closer-mop)))
    (arguments
     `(#:tests? #f))))

(define-public cl-function-cache
  (sbcl-package->cl-source-package sbcl-function-cache))

(define-public ecl-function-cache
  (sbcl-package->ecl-package sbcl-function-cache))

(define-public sbcl-type-r
  (let ((commit "83c89e38f2f7a7b16f1012777ecaf878cfa6a267")
        (revision "1"))
    (package
      (name "sbcl-type-r")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/guicho271828/type-r")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1arsxc2539rg8vbrdirz4xxj1b06mc6g6rqndz7a02g127qvk2sm"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Parser interface for Common Lisp built-in compound types")
      (description
       "Collections of accessor functions and patterns to access
the elements in compound type specifier, e.g. @code{dimensions} in
@code{(array element-type dimensions)}")
      (home-page "https://github.com/guicho271828/type-r")
      (license license:lgpl3+)
      (inputs
       `(("trivia" ,sbcl-trivia)
         ("alexandria" ,sbcl-alexandria)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       `(#:test-asd-file "type-r.test.asd")))))

(define-public cl-type-r
  (sbcl-package->cl-source-package sbcl-type-r))

(define-public ecl-type-r
  (sbcl-package->ecl-package sbcl-type-r))

(define-public sbcl-trivialib-type-unify
  (let ((commit "62492ebf04db567dcf435ae84c50b7b8202ecf99")
        (revision "1"))
    (package
      (name "sbcl-trivialib-type-unify")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/guicho271828/trivialib.type-unify")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1bkyfzbwv75p50zp8n1n9rh2r29pw3vgz91gmn2gzzkyq3khj1vh"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Common Lisp type unification")
      (description
       "Unifies a parametrized type specifier against an actual type specifier.
Importantly, it handles complicated array-subtypes and number-related types
correctly.")
      (home-page "https://github.com/guicho271828/trivialib.type-unify")
      (license license:lgpl3+)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("trivia" ,sbcl-trivia)
         ("introspect-environment" ,sbcl-introspect-environment)
         ("type-r" ,sbcl-type-r)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       `(#:asd-systems '("trivialib.type-unify")
         #:test-asd-file "trivialib.type-unify.test.asd")))))

(define-public cl-trivialib-type-unify
  (sbcl-package->cl-source-package sbcl-trivialib-type-unify))

(define-public ecl-trivialib-type-unify
  (sbcl-package->ecl-package sbcl-trivialib-type-unify))

(define-public sbcl-specialized-function
  (let ((commit "dee56d2d2b6ecd10500ad291c56217698604ec35")
        (revision "2"))
    (package
      (name "sbcl-specialized-function")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/numcl/specialized-function")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1mcc7mmpbnmgnr1cl2jl5r1ai54gn7fbisv2c14sh9za5w4sib82"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Julia-like dispatch for Common Lisp")
      (description
       "This library is part of NUMCL.  It provides a macro
@code{SPECIALIZED} that performs a Julia-like dispatch on the arguments,
lazily compiling a type-specific version of the function from the same
code.  The main target of this macro is speed.")
      (home-page "https://github.com/numcl/specialized-function")
      (license license:lgpl3+)
      (inputs
       `(("trivia" ,sbcl-trivia)
         ("alexandria" ,sbcl-alexandria)
         ("iterate" ,sbcl-iterate)
         ("lisp-namespace" ,sbcl-lisp-namespace)
         ("type-r" ,sbcl-type-r)
         ("trivial-cltl2" ,sbcl-trivial-cltl2)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       `(#:asd-files '("specialized-function.asd")
         #:test-asd-file "specialized-function.test.asd"
         ;; Tests fail because they try to use an internal symbol of SBCL
         ;; that does not exists in recent versions:
         ;;   "The variable SB-VM:COMPLEX-VECTOR-NIL-WIDETAG is unbound."
         #:tests? #f)))))

(define-public cl-specialized-function
  (sbcl-package->cl-source-package sbcl-specialized-function))

(define-public ecl-specialized-function
  (sbcl-package->ecl-package sbcl-specialized-function))

(define-public sbcl-constantfold
  (let ((commit "0ff1d97a3fbcb89264f6a2af6ce62b73e7b421f4")
        (revision "1"))
    (package
      (name "sbcl-constantfold")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/numcl/constantfold")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "153h0569z6bff1qbad0bdssplwwny75l7ilqwcfqfdvzsxf9jh06"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Support library for numcl")
      (description
       "Support library for numcl.  Registers a function as an
additional form that is considered as a candidate for a constant.")
      (home-page "https://github.com/numcl/constantfold")
      (license license:lgpl3+)
      (inputs
       `(("trivia" ,sbcl-trivia)
         ("alexandria" ,sbcl-alexandria)
         ("iterate" ,sbcl-iterate)
         ("lisp-namespace" ,sbcl-lisp-namespace)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       `(#:asd-files '("constantfold.asd")
         #:test-asd-file "constantfold.test.asd")))))

(define-public cl-constantfold
  (sbcl-package->cl-source-package sbcl-constantfold))

(define-public ecl-constantfold
  (sbcl-package->ecl-package sbcl-constantfold))

(define-public sbcl-gtype
  (let ((commit "2442e32485635525af278ebd8fa69a27d5b8cf18")
        (revision "2"))
    (package
      (name "sbcl-gtype")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/numcl/gtype")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0hbkfdw00v7bsa6zbric34p5w6hfwxycccg8wc2faq0cxhsvpv9h"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "C++/Julia-like parametric types in Common Lisp")
      (description
       "Support library for numcl that provides Julia-like runtime parametric
type correctness in Common Lisp.  It is based on CLtL2 extensions.")
      (home-page "https://github.com/numcl/gtype")
      (license license:lgpl3+)
      (inputs
       `(("trivialib.type-unify" ,sbcl-trivialib-type-unify)
         ("trivial-cltl2" ,sbcl-trivial-cltl2)
         ("trivia" ,sbcl-trivia)
         ("alexandria" ,sbcl-alexandria)
         ("iterate" ,sbcl-iterate)
         ("type-r" ,sbcl-type-r)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       `(#:asd-files '("gtype.asd")
         #:test-asd-file "gtype.test.asd")))))

(define-public cl-gtype
  (sbcl-package->cl-source-package sbcl-gtype))

(define-public ecl-gtype
  (let ((pkg (sbcl-package->ecl-package sbcl-gtype)))
    (package
      (inherit pkg)
      (arguments
       (substitute-keyword-arguments (package-arguments pkg)
         ;; The tests fail on ECL with a COMPILE-FILE-ERROR for t/package.lisp.
         ((#:tests? _ #f) #f))))))

(define-public sbcl-numcl
  (let ((commit "3e8d40bf774e070e7af1d3dbf01bc8c37dbebd3a")
        (revision "2"))
    (package
      (name "sbcl-numcl")
      (version (git-version "0.1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/numcl/numcl")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1hqpr68f6xkxaj1hjjayyh97wcdmj51k20qrd3nsv1rcpmdc5ll4"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Numpy clone in Common Lisp")
      (description
       "This is a Numpy clone in Common Lisp.  At the moment the
library is written in pure Common Lisp, focusing more on correctness
and usefulness, not speed.  Track the progress at
@url{https://github.com/numcl/numcl/projects/1}.")
      (home-page "https://github.com/numcl/numcl")
      (license license:lgpl3+)
      (inputs
       `(("trivia" ,sbcl-trivia)
         ("alexandria" ,sbcl-alexandria)
         ("iterate" ,sbcl-iterate)
         ("lisp-namespace" ,sbcl-lisp-namespace)
         ("type-r" ,sbcl-type-r)
         ("constantfold" ,sbcl-constantfold)
         ("cl-randist" ,sbcl-cl-randist)
         ("float-features" ,sbcl-float-features)
         ("function-cache" ,sbcl-function-cache)
         ("specialized-function" ,sbcl-specialized-function)
         ("gtype" ,sbcl-gtype)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       `(#:asd-files '("numcl.asd")
         #:test-asd-file "numcl.test.asd"
         ;; Tests fail on SBCL with "Heap exhausted, game over",
         ;; but they pass on ECL.
         #:tests? #f)))))

(define-public cl-numcl
  (sbcl-package->cl-source-package sbcl-numcl))

(define-public ecl-numcl
  (let ((pkg (sbcl-package->ecl-package sbcl-numcl)))
    (package
      (inherit pkg)
      (arguments
       (substitute-keyword-arguments (package-arguments pkg)
         ((#:tests? _ #f) #t))))))

(define-public sbcl-pzmq
  (let ((commit "7c7390eedc469d033c72dc497984d1536ee75826")
        (revision "1"))
    (package
      (name "sbcl-pzmq")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/orivej/pzmq")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0gmwzf7h90wa7v4wnk49g0hv2mdalljpwhyigxcb967wzv8lqci9"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("fiveam" ,sbcl-fiveam)
         ("let-plus" ,sbcl-let-plus)))
      (inputs
       `(("cffi" ,sbcl-cffi)
         ("zeromq" ,zeromq)))
      (arguments
       `(#:phases (modify-phases %standard-phases
                    (add-after 'unpack 'fix-paths
                      (lambda* (#:key inputs #:allow-other-keys)
                        (substitute* "c-api.lisp"
                          (("\"libzmq")
                           (string-append "\""
                                          (assoc-ref inputs "zeromq")
                                          "/lib/libzmq")))
                        #t)))))
      (synopsis "Common Lisp bindings for the ZeroMQ library")
      (description "This Common Lisp library provides bindings for the ZeroMQ
lightweight messaging kernel.")
      (home-page "https://github.com/orivej/pzmq")
      (license license:unlicense))))

(define-public cl-pzmq
  (sbcl-package->cl-source-package sbcl-pzmq))

(define-public ecl-pzmq
  (sbcl-package->ecl-package sbcl-pzmq))

(define-public sbcl-clss
  (let ((revision "1")
        (commit "2a8e8615ab55870d4ca01928f3ed3bbeb4e75c8d"))
    (package
      (name "sbcl-clss")
      (version (git-version "0.3.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/Shinmera/clss")
           (commit commit)))
         (sha256
          (base32 "0la4dbcda78x29szanylccrsljqrn9d1mhh569sqkyp44ni5fv91"))
         (file-name (git-file-name name version))))
      (inputs
       `(("array-utils" ,sbcl-array-utils)
         ("plump" ,sbcl-plump)))
      (build-system asdf-build-system/sbcl)
      (synopsis "DOM tree searching engine based on CSS selectors")
      (description "CLSS is a DOM traversal engine based on CSS
selectors.  It makes use of the Plump-DOM and is used by lQuery.")
      (home-page "https://github.com/Shinmera/clss")
      (license license:zlib))))

(define-public cl-clss
  (sbcl-package->cl-source-package sbcl-clss))

(define-public ecl-clss
  (sbcl-package->ecl-package sbcl-clss))

(define-public sbcl-lquery
  (let ((revision "1")
        (commit "8048111c6b83956daa632e7a3ffbd8c9c203bd8d"))
    (package
      (name "sbcl-lquery")
      (version (git-version "3.2.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/Shinmera/lquery")
           (commit commit)))
         (sha256
          (base32 "0520mcpxc2d6fdm8z61arpgd2z38kan7cf06qs373n5r64rakz6w"))
         (file-name (git-file-name name version))))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("array-utils" ,sbcl-array-utils)
         ("form-fiddle" ,sbcl-form-fiddle)
         ("plump" ,sbcl-plump)
         ("clss" ,sbcl-clss)))
      (build-system asdf-build-system/sbcl)
      (synopsis "Library to allow jQuery-like HTML/DOM manipulation")
      (description "@code{lQuery} is a DOM manipulation library written in
Common Lisp, inspired by and based on the jQuery syntax and
functions.  It uses Plump and CLSS as DOM and selector engines.  The
main idea behind lQuery is to provide a simple interface for crawling
and modifying HTML sites, as well as to allow for an alternative
approach to templating.")
      (home-page "https://github.com/Shinmera/lquery")
      (license license:zlib))))

(define-public cl-lquery
  (sbcl-package->cl-source-package sbcl-lquery))

(define-public ecl-lquery
  (sbcl-package->ecl-package sbcl-lquery))

(define-public sbcl-cl-mysql
  (let ((commit "ab56c279c1815aec6ca0bfe85164ff7e85cfb6f9")
        (revision "1"))
    (package
      (name "sbcl-cl-mysql")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/hackinghat/cl-mysql")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0dg5ynx2ww94d0qfwrdrm7plkn43h64hs4iiq9mj2s1s4ixnp3lr"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("stefil" ,sbcl-stefil)))
      (inputs
       `(("cffi" ,sbcl-cffi)
         ("mariadb-lib" ,mariadb "lib")))
      (arguments
       `(#:tests? #f ; TODO: Tests require a running server
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "system.lisp"
                 (("libmysqlclient_r" all)
                  (string-append (assoc-ref inputs "mariadb-lib")
                                 "/lib/"
                                 all)))
               #t)))))
      (synopsis "Common Lisp wrapper for MySQL")
      (description
       "@code{cl-mysql} is a Common Lisp implementation of a MySQL wrapper.")
      (home-page "http://www.hackinghat.com/index.php/cl-mysql")
      (license license:expat))))

(define-public cl-mysql
  (sbcl-package->cl-source-package sbcl-cl-mysql))

(define-public ecl-cl-mysql
  (sbcl-package->ecl-package sbcl-cl-mysql))

(define-public sbcl-postmodern
  (let ((commit "74469b25bbda990ec9b77e0d0eccdba0cd7e721a")
        (revision "1"))
    (package
      (name "sbcl-postmodern")
      (version (git-version "1.19" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/marijnh/Postmodern")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0im7ymnyxjhn2w74jfg76k5gpr0gl33n31akx33hl28722ljd0hd"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("closer-mop" ,sbcl-closer-mop)
         ("global-vars" ,sbcl-global-vars)
         ("md5" ,sbcl-md5)
         ("split-sequence" ,sbcl-split-sequence)
         ("usocket" ,sbcl-usocket)))
      (arguments
       ;; TODO: Fix missing dependency errors for simple-date/postgres-glue,
       ;; cl-postgres/tests and s-sql/tests.
       `(#:tests? #f
         #:asd-systems '("postmodern"
                         "simple-date/postgres-glue")))
      (synopsis "Common Lisp library for interacting with PostgreSQL")
      (description
       "@code{postmodern} is a Common Lisp library for interacting with
PostgreSQL databases.  It provides the following features:

@itemize
@item Efficient communication with the database server without need for
foreign libraries.
@item Support for UTF-8 on Unicode-aware Lisp implementations.
@item A syntax for mixing SQL and Lisp code.
@item Convenient support for prepared statements and stored procedures.
@item A metaclass for simple database-access objects.
@end itemize\n")
      (home-page "https://marijnhaverbeke.nl/postmodern/")
      (license license:zlib))))

(define-public cl-postmodern
  (sbcl-package->cl-source-package sbcl-postmodern))

(define-public ecl-postmodern
  (package
    (inherit (sbcl-package->ecl-package sbcl-postmodern))
    (arguments
     `(#:tests? #f
       #:asd-systems '("postmodern"
                       "simple-date/postgres-glue")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-build
           (lambda _
             (substitute* "cl-postgres.asd"
               (("\\) \"usocket\"")
                " :ecl) \"usocket\""))
             #t)))))))

(define-public sbcl-dbi
  ;; Master includes a breaking change which other packages depend on since
  ;; Quicklisp decided to follow it:
  ;; https://github.com/fukamachi/cl-dbi/commit/31c46869722f77fd5292a81b5b101f1347d7fce1
  (let ((commit "31c46869722f77fd5292a81b5b101f1347d7fce1"))
    (package
      (name "sbcl-dbi")
      (version (git-version "0.9.4" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/cl-dbi")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0r3n4rw12qqxad0cryym2ibm4ddl49gbq4ra227afibsr43nw5k3"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("rove" ,sbcl-rove)
         ("trivial-types" ,sbcl-trivial-types)))
      (inputs
       `(("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("cl-mysql" ,sbcl-cl-mysql)
         ("cl-sqlite" ,sbcl-cl-sqlite)
         ("closer-mop" ,sbcl-closer-mop)
         ("postmodern" ,sbcl-postmodern)
         ("split-sequence" ,sbcl-split-sequence)
         ("trivial-garbage" ,sbcl-trivial-garbage)))
      (arguments
       `(#:asd-systems '("dbi"
                         "dbd-mysql"
                         "dbd-postgres"
                         "dbd-sqlite3")))
      (synopsis "Database independent interface for Common Lisp")
      (description
       "@code{dbi} is a Common Lisp library providing a database independent
interface for MySQL, PostgreSQL and SQLite.")
      (home-page "https://github.com/fukamachi/cl-dbi")
      (license license:llgpl))))

(define-public cl-dbi
  (sbcl-package->cl-source-package sbcl-dbi))

(define-public ecl-dbi
  (sbcl-package->ecl-package sbcl-dbi))

(define-public sbcl-uffi
  (package
    (name "sbcl-uffi")
    (version "2.1.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "http://git.kpe.io/uffi.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1hqszvz0a3wk4s9faa83sc3vjxcb5rxmjclyr17yzwg55z733kry"))))
    (build-system asdf-build-system/sbcl)
    (arguments
     `(#:tests? #f ; TODO: Fix use of deprecated ASDF functions
       #:asd-files '("uffi.asd")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-permissions
           (lambda _
             (make-file-writable "doc/html.tar.gz")
             #t)))))
    (synopsis "Universal foreign function library for Common Lisp")
    (description
     "UFFI provides a universal foreign function interface (FFI)
 for Common Lisp.")
    (home-page "http://quickdocs.org/uffi/")
    (license license:llgpl)))

(define-public cl-uffi
  (package
    (inherit (sbcl-package->cl-source-package sbcl-uffi))
    (arguments
     `(#:phases
       ;; asdf-build-system/source has its own phases and does not inherit
       ;; from asdf-build-system/sbcl phases.
       (modify-phases %standard-phases/source
         ;; Already done in SBCL package.
         (delete 'reset-gzip-timestamps))))))

(define-public sbcl-clsql
  (package
    (name "sbcl-clsql")
    (version "6.7.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "http://git.kpe.io/clsql.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1v1k3s5bsy3lgd9gk459bzpb1r0kdjda25s29samxw4gsgf1fqvp"))
       (snippet
        '(begin
           ;; Remove precompiled libraries.
           (delete-file "db-mysql/clsql_mysql.dll")
           (delete-file "uffi/clsql_uffi.dll")
           (delete-file "uffi/clsql_uffi.lib")
           #t))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("rt" ,sbcl-rt)))
    (inputs
     `(("cffi" ,sbcl-cffi)
       ("md5" ,sbcl-md5)
       ("mysql" ,mysql)
       ("postgresql" ,postgresql)
       ("postmodern" ,sbcl-postmodern)
       ("sqlite" ,sqlite)
       ("uffi" ,sbcl-uffi)
       ("zlib" ,zlib)))
    (arguments
     `(#:asd-files '("clsql.asd"
                     "clsql-uffi.asd"
                     "clsql-sqlite3.asd"
                     "clsql-postgresql.asd"
                     "clsql-postgresql-socket3.asd"
                     "clsql-mysql.asd")
       #:asd-systems '("clsql"
                       "clsql-sqlite3"
                       "clsql-postgresql"
                       "clsql-postgresql-socket3"
                       "clsql-mysql")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-permissions
           (lambda _
             (make-file-writable "doc/html.tar.gz")
             #t))
         (add-after 'unpack 'fix-build
           (lambda _
             (substitute* "clsql-uffi.asd"
               (("\\(:version uffi \"2.0\"\\)")
                "uffi"))
             (substitute* "db-postgresql/postgresql-api.lisp"
               (("\\(data :cstring\\)")
                "(data :string)"))
             #t))
         (add-after 'unpack 'fix-paths
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (substitute* "db-sqlite3/sqlite3-loader.lisp"
               (("libsqlite3")
                (string-append (assoc-ref inputs "sqlite")
                               "/lib/libsqlite3")))
             (substitute* "db-postgresql/postgresql-loader.lisp"
               (("libpq")
                (string-append (assoc-ref inputs "postgresql")
                               "/lib/libpq")))
             (let ((lib (string-append "#p\""
                                       (assoc-ref outputs "out")
                                       "/lib/\"")))
               (substitute* "clsql-mysql.asd"
                 (("#p\"/usr/lib/clsql/clsql_mysql\\.so\"")
                  lib))
               (substitute* "db-mysql/mysql-loader.lisp"
                 (("libmysqlclient" all)
                  (string-append (assoc-ref inputs "mysql") "/lib/" all))
                 (("clsql-mysql-system::\\*library-file-dir\\*")
                  lib)))
             #t))
         (add-before 'build 'build-helper-library
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((mysql (assoc-ref inputs "mysql"))
                    (inc-dir (string-append mysql "/include/mysql"))
                    (lib-dir (string-append mysql "/lib"))
                    (shared-lib-dir (string-append (assoc-ref outputs "out")
                                                   "/lib"))
                    (shared-lib (string-append shared-lib-dir
                                               "/clsql_mysql.so")))
               (mkdir-p shared-lib-dir)
               (invoke "gcc" "-fPIC" "-shared"
                       "-I" inc-dir
                       "db-mysql/clsql_mysql.c"
                       "-Wl,-soname=clsql_mysql"
                       "-L" lib-dir "-lmysqlclient" "-lz"
                       "-o" shared-lib)
               #t)))
         (add-after 'unpack 'fix-tests
           (lambda _
             (substitute* "clsql.asd"
               (("clsql-tests :force t")
                "clsql-tests"))
             #t)))))
    (synopsis "Common Lisp SQL Interface library")
    (description
     "@code{clsql} is a Common Lisp interface to SQL RDBMS based on the
Xanalys CommonSQL interface for Lispworks.  It provides low-level database
interfaces as well as a functional and an object oriented interface.")
    (home-page "http://clsql.kpe.io/")
    (license license:llgpl)))

(define-public cl-clsql
  (package
    (inherit (sbcl-package->cl-source-package sbcl-clsql))
    (native-inputs
     `(("rt" ,cl-rt)))
    (inputs
     `(("mysql" ,mysql)
       ("postgresql" ,postgresql)
       ("sqlite" ,sqlite)
       ("zlib" ,zlib)))
    (propagated-inputs
     `(("cffi" ,cl-cffi)
       ("md5" ,cl-md5)
       ("postmodern" ,cl-postmodern)
       ("uffi" ,cl-uffi)))
    (arguments
     `(#:phases
       ;; asdf-build-system/source has its own phases and does not inherit
       ;; from asdf-build-system/sbcl phases.
       (modify-phases %standard-phases/source
         (add-after 'unpack 'fix-permissions
           (lambda _
             (make-file-writable "doc/html.tar.gz")
             #t)))))))

(define-public ecl-clsql
  (let ((pkg (sbcl-package->ecl-package sbcl-clsql)))
    (package
      (inherit pkg)
      (inputs
       (alist-delete "uffi" (package-inputs pkg)))
      (arguments
       (substitute-keyword-arguments (package-arguments pkg)
         ((#:asd-files asd-files '())
          `(cons "clsql-cffi.asd" ,asd-files)))))))

(define-public sbcl-sycamore
  (let ((commit "fd2820fec165ad514493426dea209728f64e6d18"))
    (package
      (name "sbcl-sycamore")
      (version "0.0.20120604")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ndantam/sycamore/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "00bv1aj89q5vldmq92zp2364jq312zjq2mbd3iyz1s2b4widzhl7"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-ppcre" ,sbcl-cl-ppcre)))
      (synopsis "Purely functional data structure library in Common Lisp")
      (description
       "Sycamore is a fast, purely functional data structure library in Common Lisp.
If features:

@itemize
@item Fast, purely functional weight-balanced binary trees.
@item Leaf nodes are simple-vectors, greatly reducing tree height.
@item Interfaces for tree Sets and Maps (dictionaries).
@item Ropes.
@item Purely functional pairing heaps.
@item Purely functional amortized queue.
@end itemize\n")
      (home-page "http://ndantam.github.io/sycamore/")
      (license license:bsd-3))))

(define-public cl-sycamore
  (sbcl-package->cl-source-package sbcl-sycamore))

(define-public ecl-sycamore
  (sbcl-package->ecl-package sbcl-sycamore))

(define-public sbcl-trivial-package-local-nicknames
  (package
    (name "sbcl-trivial-package-local-nicknames")
    (version "0.2")
    (home-page "https://github.com/phoe/trivial-package-local-nicknames")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit "16b7ad4c2b120f50da65154191f468ea5598460e")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "18qc27xkjzdcqrilpk3pm7djldwq5rm3ggd5h9cr8hqcd54i2fqg"))))
    (build-system asdf-build-system/sbcl)
    (synopsis "Common Lisp compatibility library for package local nicknames")
    (description
     "This library is a portable compatibility layer around package local nicknames (PLN).
This was done so there is a portability library for the PLN API not included
in DEFPACKAGE.")
    (license license:unlicense)))

(define-public cl-trivial-package-local-nicknames
  (sbcl-package->cl-source-package sbcl-trivial-package-local-nicknames))

(define-public ecl-trivial-package-local-nicknames
  (sbcl-package->ecl-package sbcl-trivial-package-local-nicknames))

(define-public sbcl-enchant
  (let ((commit "6af162a7bf10541cbcfcfa6513894900329713fa"))
    (package
      (name "sbcl-enchant")
      (version (git-version "0.0.0" "1" commit))
      (home-page "https://github.com/tlikonen/cl-enchant")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "19yh5ihirzi1d8xqy1cjqipzd6ly3245cfxa5s9xx496rryz0s01"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("enchant" ,enchant)
         ("cffi" ,sbcl-cffi)))
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "load-enchant.lisp"
                 (("libenchant")
                  (string-append
                   (assoc-ref inputs "enchant") "/lib/libenchant-2"))))))))
      (synopsis "Common Lisp interface for the Enchant spell-checker library")
      (description
       "Enchant is a Common Lisp interface for the Enchant spell-checker
library.  The Enchant library is a generic spell-checker library which uses
other spell-checkers transparently as back-end.  The library supports the
multiple checkers, including Aspell and Hunspell.")
      (license license:public-domain))))

(define-public cl-enchant
  (sbcl-package->cl-source-package sbcl-enchant))

(define-public ecl-enchant
  (sbcl-package->ecl-package sbcl-enchant))

(define-public sbcl-cl-change-case
  (let ((commit "5ceff2a5f8bd845b6cb510c6364176b27a238fd3"))
    (package
      (name "sbcl-cl-change-case")
      (version (git-version "0.1.0" "1" commit))
      (home-page "https://github.com/rudolfochrist/cl-change-case")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1afyglglk9z3yg8gylcl301bl2r8vq3sllyznzj9s5xi5gs6qyf2"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cl-ppcre" ,sbcl-cl-ppcre)
         ("cl-ppcre-unicode" ,sbcl-cl-ppcre-unicode)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (arguments
       '(;; FIXME: Test pass but phase fails with 'Component
         ;; "cl-change-case-test" not found, required by'.
         #:tests? #f
         #:test-asd-file "cl-change-case-test.asd"))
      (synopsis "Convert Common Lisp strings between camelCase, PascalCase and more")
      (description
       "@code{cl-change-case} is library to convert strings between camelCase,
PascalCase, snake_case, param-case, CONSTANT_CASE and more.")
      (license license:llgpl))))

(define-public cl-change-case
  (sbcl-package->cl-source-package sbcl-cl-change-case))

(define-public ecl-cl-change-case
  (sbcl-package->ecl-package sbcl-cl-change-case))

(define-public sbcl-moptilities
  (let ((commit "a436f16b357c96b82397ec018ea469574c10dd41"))
    (package
      (name "sbcl-moptilities")
      (version (git-version "0.3.13" "1" commit))
      (home-page "https://github.com/gwkkwg/moptilities/")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1q12bqjbj47lx98yim1kfnnhgfhkl80102fkgp9pdqxg0fp6g5fc"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("closer-mop" ,sbcl-closer-mop)))
      (native-inputs
       `(("lift" ,sbcl-lift)))
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-tests
             (lambda _
               (substitute* "lift-standard.config"
                 ((":relative-to lift-test")
                  ":relative-to moptilities-test"))
               #t)))))
      (synopsis "Compatibility layer for Common Lisp MOP implementation differences")
      (description
       "MOP utilities provide a common interface between Lisps and make the
MOP easier to use.")
      (license license:expat))))

(define-public cl-moptilities
  (sbcl-package->cl-source-package sbcl-moptilities))

(define-public sbcl-osicat
  (let ((commit "de0c18a367eedc857e1902a7319828af072a0d97"))
    (package
      (name "sbcl-osicat")
      (version (git-version "0.7.0" "1" commit))
      (home-page "http://www.common-lisp.net/project/osicat/")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/osicat/osicat")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "15viw5pi5sa7qq9b4n2rr3dj2jkqr180rh9z1lh8w3rgl42i2adc"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cffi" ,sbcl-cffi)
         ("trivial-features" ,sbcl-trivial-features)))
      (native-inputs
       `(("rt" ,sbcl-rt)))
      (synopsis "Operating system interface for Common Lisp")
      (description
       "Osicat is a lightweight operating system interface for Common Lisp on
Unix-platforms.  It is not a POSIX-style API, but rather a simple lispy
accompaniment to the standard ANSI facilities.")
      (license license:expat))))

(define-public cl-osicat
  (sbcl-package->cl-source-package sbcl-osicat))

(define-public ecl-osicat
  (sbcl-package->ecl-package sbcl-osicat))

(define-public sbcl-clx-xembed
  (let ((commit "a5c4b844d31ee68ffa58c933cc1cdddde6990743")
        (revision "1"))
    (package
      (name "sbcl-clx-xembed")
      (version (git-version "0.1" revision commit))
      (home-page "https://github.com/laynor/clx-xembed")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/laynor/clx-xembed")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1abx4v36ycmfjdwpjk4hh8058ya8whwia7ds9vd96q2qsrs57f12"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       `(#:asd-systems '("xembed")))
      (inputs
       `(("sbcl-clx" ,sbcl-clx)))
      (synopsis "CL(x) xembed protocol implementation ")
      (description "CL(x) xembed protocol implementation")
      ;; MIT License
      (license license:expat))))

(define-public cl-clx-xembed
  (sbcl-package->cl-source-package sbcl-clx-xembed))

(define-public ecl-clx-xembed
  (sbcl-package->ecl-package sbcl-clx-xembed))

(define-public sbcl-quantile-estimator
  (package
    (name "sbcl-quantile-estimator")
    (version "0.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/deadtrickster/quantile-estimator.cl")
             (commit "84d0ea405d793f5e808c68c4ddaf25417b0ff8e5")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0rlswkf0siaabsvvch3dgxmg45fw5w8pd9b7ri2w7a298aya52z9"))))
    (build-system asdf-build-system/sbcl)
    (arguments
     '(#:asd-files '("quantile-estimator.asd")))
    (inputs
     `(("alexandria" ,sbcl-alexandria)))
    (home-page "https://github.com/deadtrickster/quantile-estimator.cl")
    (synopsis
     "Effective computation of biased quantiles over data streams")
    (description
     "Common Lisp implementation of Graham Cormode and S.
Muthukrishnan's Effective Computation of Biased Quantiles over Data
Streams in ICDE’05.")
    (license license:expat)))

(define-public cl-quantile-estimator
  (sbcl-package->cl-source-package sbcl-quantile-estimator))

(define-public ecl-quantile-estimator
  (sbcl-package->ecl-package sbcl-quantile-estimator))

(define-public sbcl-prometheus
  (package
    (name "sbcl-prometheus")
    (version "0.4.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/deadtrickster/prometheus.cl")
             (commit "7352b92296996ff383503e19bdd3bcea30409a15")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0fzczls2kfgdx18pja4lqxjrz72i583185d8nq0pb3s331hhzh0z"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("alexandria" ,sbcl-alexandria)
       ("bordeaux-threads" ,sbcl-bordeaux-threads)
       ("cffi" ,sbcl-cffi)
       ("cl-fad" ,sbcl-cl-fad)
       ("cl-ppcre" ,sbcl-cl-ppcre)
       ("drakma" ,sbcl-drakma)
       ("hunchentoot" ,sbcl-hunchentoot)
       ("local-time" ,sbcl-local-time)
       ("quantile-estimator" ,sbcl-quantile-estimator)
       ("salza2" ,sbcl-salza2)
       ("split-sequence" ,sbcl-split-sequence)
       ("trivial-utf-8" ,sbcl-trivial-utf-8)))
    (arguments
     '(#:asd-files '("prometheus.asd"
                     "prometheus.collectors.sbcl.asd"
                     "prometheus.collectors.process.asd"
                     "prometheus.formats.text.asd"
                     "prometheus.exposers.hunchentoot.asd"
                     "prometheus.pushgateway.asd")
       #:asd-systems '("prometheus"
                       "prometheus.collectors.sbcl"
                       "prometheus.collectors.process"
                       "prometheus.formats.text"
                       "prometheus.exposers.hunchentoot"
                       "prometheus.pushgateway")))
    (home-page "https://github.com/deadtrickster/prometheus.cl")
    (synopsis "Prometheus.io Common Lisp client")
    (description "Prometheus.io Common Lisp client.")
    (license license:expat)))

(define-public cl-prometheus
  (sbcl-package->cl-source-package sbcl-prometheus))

(define-public ecl-prometheus
  (sbcl-package->ecl-package sbcl-prometheus))

(define-public sbcl-uuid
  (let ((commit "e7d6680c3138385c0708f7aaf0c96622eeb140e8"))
    (package
      (name "sbcl-uuid")
      (version (git-version "2012.12.26" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/dardoria/uuid")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0jnyp2kibcf5cwi60l6grjrj8wws9chasjvsw7xzwyym2lyid46f"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("ironclad" ,sbcl-ironclad)
         ("trivial-utf-8" ,sbcl-trivial-utf-8)))
      (home-page "https://github.com/dardoria/uuid")
      (synopsis
       "Common Lisp implementation of UUIDs according to RFC4122")
      (description
       "Common Lisp implementation of UUIDs according to RFC4122.")
      (license license:llgpl))))

(define-public cl-uuid
  (sbcl-package->cl-source-package sbcl-uuid))

(define-public ecl-uuid
  (sbcl-package->ecl-package sbcl-uuid))

(define-public sbcl-dissect
  (let ((commit "cffd38479f0e64e805f167bbdb240b783ecc8d45"))
    (package
      (name "sbcl-dissect")
      (version (git-version "1.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Shinmera/dissect")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0rmsjkgjl90gl6ssvgd60hb0d5diyhsiyypvw9hbc0ripvbmk5r5"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cl-ppcre" ,sbcl-cl-ppcre)))
      (home-page "https://shinmera.github.io/dissect/")
      (synopsis
       "Introspection library for the call stack and restarts")
      (description
       "Dissect is a small Common Lisp library for introspecting the call stack
and active restarts.")
      (license license:zlib))))

(define-public cl-dissect
  (sbcl-package->cl-source-package sbcl-dissect))

(define-public ecl-dissect
  (sbcl-package->ecl-package sbcl-dissect))

(define-public sbcl-rove
  (package
    (name "sbcl-rove")
    (version "0.9.6")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/fukamachi/rove")
             (commit "f3695db08203bf26f3b861dc22ac0f4257d3ec21")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "07ala4l2fncxf540fzxj3h5mhi9i4wqllhj0rqk8m2ljl5zbz89q"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("bordeaux-threads" ,sbcl-bordeaux-threads)
       ("dissect" ,sbcl-dissect)
       ("trivial-gray-streams" ,sbcl-trivial-gray-streams)))
    (home-page "https://github.com/fukamachi/rove")
    (synopsis
     "Yet another common lisp testing library")
    (description
     "Rove is a unit testing framework for Common Lisp applications.
This is intended to be a successor of Prove.")
    (license license:bsd-3)))

(define-public cl-rove
  (sbcl-package->cl-source-package sbcl-rove))

(define-public ecl-rove
  (sbcl-package->ecl-package sbcl-rove))

(define-public sbcl-exponential-backoff
  (let ((commit "8d9e8444d8b3184a524c12ce3449f91613ab714f"))
    (package
      (name "sbcl-exponential-backoff")
      (version (git-version "0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/death/exponential-backoff")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1389hm9hxv85s0125ja4js1bvh8ay4dsy9q1gaynjv27ynik6gmv"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/death/exponential-backoff")
      (synopsis "Exponential backoff algorithm in Common Lisp")
      (description
       "An implementation of the exponential backoff algorithm in Common Lisp.
Inspired by the implementation found in Chromium.  Read the header file to
learn about each of the parameters.")
      (license license:expat))))

(define-public cl-exponential-backoff
  (sbcl-package->cl-source-package sbcl-exponential-backoff))

(define-public ecl-exponential-backoff
  (sbcl-package->ecl-package sbcl-exponential-backoff))

(define-public sbcl-sxql
  (let ((commit "5aa8b739492c5829e8623432b5d46482263990e8"))
    (package
      (name "sbcl-sxql")
      (version (git-version "0.1.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/sxql")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0k25p6w2ld9cn8q8s20lda6yjfyp4q89219sviayfgixnj27avnj"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       `(#:test-asd-file "sxql-test.asd"))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-syntax" ,sbcl-cl-syntax)
         ("iterate" ,sbcl-iterate)
         ("optima" ,sbcl-optima)
         ("split-sequence" ,sbcl-split-sequence)
         ("trivial-types" ,sbcl-trivial-types)))
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (home-page "https://github.com/fukamachi/sxql")
      (synopsis "SQL generator for Common Lisp")
      (description "SQL generator for Common Lisp.")
      (license license:bsd-3))))

(define-public cl-sxql
  (sbcl-package->cl-source-package sbcl-sxql))

(define-public ecl-sxql
  (sbcl-package->ecl-package sbcl-sxql))

(define-public sbcl-1am
  (let ((commit "8b1da94eca4613fd8a20bdf63f0e609e379b0ba5"))
    (package
      (name "sbcl-1am")
      (version (git-version "0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/lmj/1am")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "05ss4nz1jb9kb796295482b62w5cj29msfj8zis33sp2rw2vmv2g"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       `(#:asd-systems '("1am")))
      (home-page "https://github.com/lmj/1am")
      (synopsis "Minimal testing framework for Common Lisp")
      (description "A minimal testing framework for Common Lisp.")
      (license license:expat))))

(define-public cl-1am
  (sbcl-package->cl-source-package sbcl-1am))

(define-public ecl-1am
  (sbcl-package->ecl-package sbcl-1am))

(define-public sbcl-cl-ascii-table
  (let ((commit "d9f5e774a56fad1b416e4dadb8f8a5b0e84094e2")
        (revision "1"))
    (package
      (name "sbcl-cl-ascii-table")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/telephil/cl-ascii-table")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "125fdif9sgl7k0ngjhxv0wjas2q27d075025hvj2rx1b1x948z4s"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Library to make ascii-art tables")
      (description
       "This is a Common Lisp library to present tabular data in ascii-art
tables.")
      (home-page "https://github.com/telephil/cl-ascii-table")
      (license license:expat))))

(define-public cl-ascii-table
  (sbcl-package->cl-source-package sbcl-cl-ascii-table))

(define-public ecl-cl-ascii-table
  (sbcl-package->ecl-package sbcl-cl-ascii-table))

(define-public sbcl-cl-rdkafka
  (package
    (name "sbcl-cl-rdkafka")
    (version "1.0.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/SahilKang/cl-rdkafka")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1qcgfd4h7syilzmrmd4z2vknbvawda3q3ykw7xm8n381syry4g82"))))
    (build-system asdf-build-system/sbcl)
    (arguments
     `(#:tests? #f ; Attempts to connect to locally running Kafka
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "src/low-level/librdkafka-bindings.lisp"
               (("librdkafka" all)
                (string-append (assoc-ref inputs "librdkafka") "/lib/"
                               all))))))))
    (inputs
     `(("bordeaux-threads" ,sbcl-bordeaux-threads)
       ("cffi" ,sbcl-cffi)
       ("librdkafka" ,librdkafka)
       ("lparallel" ,sbcl-lparallel)
       ("trivial-garbage" ,sbcl-trivial-garbage)))
    (home-page "https://github.com/SahilKang/cl-rdkafka")
    (synopsis "Common Lisp client library for Apache Kafka")
    (description "A Common Lisp client library for Apache Kafka.")
    (license license:gpl3)))

(define-public cl-rdkafka
  (sbcl-package->cl-source-package sbcl-cl-rdkafka))

(define-public ecl-cl-rdkafka
  (sbcl-package->ecl-package sbcl-cl-rdkafka))

(define-public sbcl-acclimation
  (let ((commit "4d51150902568fcd59335f4cc4cfa022df6116a5"))
    (package
      (name "sbcl-acclimation")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/robert-strandh/Acclimation")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1aw7rarjl8ai57h0jxnp9hr3dka7qrs55mmbl1p6rhd6xj8mp9wq"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/robert-strandh/Acclimation")
      (synopsis "Internationalization library for Common Lisp")
      (description "This project is meant to provide tools for
internationalizing Common Lisp programs.

One important aspect of internationalization is of course the language used in
error messages, documentation strings, etc.  But with this project we provide
tools for all other aspects of internationalization as well, including dates,
weight, temperature, names of physical quantitites, etc.")
      (license license:bsd-2))))

(define-public cl-acclimation
  (sbcl-package->cl-source-package sbcl-acclimation))

(define-public ecl-acclimation
  (sbcl-package->ecl-package sbcl-acclimation))

(define-public sbcl-clump
  (let ((commit "1ea4dbac1cb86713acff9ae58727dd187d21048a"))
    (package
      (name "sbcl-clump")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/robert-strandh/Clump")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1639msyagsswj85gc0wd90jgh8588j3qg5q70by9s2brf2q6w4lh"))))
      (inputs
       `(("acclimation" ,sbcl-acclimation)))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/robert-strandh/Clump")
      (synopsis "Collection of tree implementations for Common Lisp")
      (description "The purpose of this library is to provide a collection of
implementations of trees.

In contrast to existing libraries such as cl-containers, it does not impose a
particular use for the trees.  Instead, it aims for a stratified design,
allowing client code to choose between different levels of abstraction.

As a consequence of this policy, low-level interfaces are provided where
the concrete representation is exposed, but also high level interfaces
where the trees can be used as search trees or as trees that represent
sequences of objects.")
      (license license:bsd-2))))

(define-public cl-clump
  (sbcl-package->cl-source-package sbcl-clump))

(define-public ecl-clump
  (sbcl-package->ecl-package sbcl-clump))

(define-public sbcl-cluffer
  (let ((commit "4aad29c276a58a593064e79972ee4d77cae0af4a"))
    (package
      (name "sbcl-cluffer")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/robert-strandh/cluffer")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1bcg13g7qb3dr8z50aihdjqa6miz5ivlc9wsj2csgv1km1mak2kj"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("acclimation" ,sbcl-acclimation)
         ("clump" ,sbcl-clump)))
      (home-page "https://github.com/robert-strandh/cluffer")
      (synopsis "Common Lisp library providing a protocol for text-editor buffers")
      (description "Cluffer is a library for representing the buffer of a text
editor.  As such, it defines a set of CLOS protocols for client code to
interact with the buffer contents in various ways, and it supplies different
implementations of those protocols for different purposes.")
      (license license:bsd-2))))

(define-public cl-cluffer
  (sbcl-package->cl-source-package sbcl-cluffer))

(define-public ecl-cluffer
  (sbcl-package->ecl-package sbcl-cluffer))

(define-public sbcl-cl-libsvm-format
  (let ((commit "3300f84fd8d9f5beafc114f543f9d83417c742fb")
        (revision "0"))
    (package
      (name "sbcl-cl-libsvm-format")
      (version (git-version "0.1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/masatoi/cl-libsvm-format")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0284aj84xszhkhlivaigf9qj855fxad3mzmv3zfr0qzb5k0nzwrg"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)))
      (synopsis "LibSVM data format reader for Common Lisp")
      (description
       "This Common Lisp library provides a fast reader for data in LibSVM
format.")
      (home-page "https://github.com/masatoi/cl-libsvm-format")
      (license license:expat))))

(define-public cl-libsvm-format
  (sbcl-package->cl-source-package sbcl-cl-libsvm-format))

(define-public ecl-cl-libsvm-format
  (sbcl-package->ecl-package sbcl-cl-libsvm-format))

(define-public sbcl-cl-online-learning
  (let ((commit "fc7a34f4f161cd1c7dd747d2ed8f698947781423")
        (revision "0"))
    (package
      (name "sbcl-cl-online-learning")
      (version (git-version "0.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/masatoi/cl-online-learning")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "14x95rlg80ay5hv645ki57pqvy12v28hz4k1w0f6bsfi2rmpxchq"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (inputs
       `(("cl-libsvm-format" ,sbcl-cl-libsvm-format)
         ("cl-store" ,sbcl-cl-store)))
      (arguments
       `(;; FIXME: Tests pass but then the check phase crashes
         #:tests? #f))
      (synopsis "Online Machine Learning for Common Lisp")
      (description
       "This library contains a collection of machine learning algorithms for
online linear classification written in Common Lisp.")
      (home-page "https://github.com/masatoi/cl-online-learning")
      (license license:expat))))

(define-public cl-online-learning
  (sbcl-package->cl-source-package sbcl-cl-online-learning))

(define-public ecl-cl-online-learning
  (sbcl-package->ecl-package sbcl-cl-online-learning))

(define-public sbcl-cl-random-forest
  (let ((commit "fedb36ce99bb6f4d7e3a7dd6d8b058f331308f91")
        (revision "1"))
    (package
      (name "sbcl-cl-random-forest")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/masatoi/cl-random-forest")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0wqh4dxy5hrvm14jgyfypwhdw35f24rsksid4blz5a6l2z16rlmq"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("prove" ,sbcl-prove)
         ("trivial-garbage" ,sbcl-trivial-garbage)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-libsvm-format" ,sbcl-cl-libsvm-format)
         ("cl-online-learning" ,sbcl-cl-online-learning)
         ("lparallel" ,sbcl-lparallel)))
      (arguments
       `(#:tests? #f)) ; The tests download data from the Internet
      (synopsis "Random Forest and Global Refinement for Common Lisp")
      (description
       "CL-random-forest is an implementation of Random Forest for multiclass
classification and univariate regression written in Common Lisp.  It also
includes an implementation of Global Refinement of Random Forest.")
      (home-page "https://github.com/masatoi/cl-random-forest")
      (license license:expat))))

(define-public cl-random-forest
  (sbcl-package->cl-source-package sbcl-cl-random-forest))

(define-public ecl-cl-random-forest
  (sbcl-package->ecl-package sbcl-cl-random-forest))

(define-public sbcl-bordeaux-fft
  (let ((commit "4a1f5600cae59bdabcb32de4ee2d7d73a9450d6e")
        (revision "0"))
    (package
      (name "sbcl-bordeaux-fft")
      (version (git-version "1.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ahefner/bordeaux-fft")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0j584w6kq2k6r8lp2i14f9605rxhp3r15s33xs08iz1pndn6iwqf"))))
      (build-system asdf-build-system/sbcl)
      (home-page "http://vintage-digital.com/hefner/software/bordeaux-fft/")
      (synopsis "Fast Fourier Transform for Common Lisp")
      (description
       "The Bordeaux-FFT library provides a reasonably efficient implementation
of the Fast Fourier Transform and its inverse for complex-valued inputs, in
portable Common Lisp.")
      (license license:gpl2+))))

(define-public cl-bordeaux-fft
  (sbcl-package->cl-source-package sbcl-bordeaux-fft))

(define-public ecl-bordeaux-fft
  (sbcl-package->ecl-package sbcl-bordeaux-fft))

(define-public sbcl-napa-fft3
  (let ((commit "f2d9614c7167da327c9ceebefb04ff6eae2d2236")
        (revision "0"))
    (package
      (name "sbcl-napa-fft3")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/pkhuong/Napa-FFT3")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1hxjf599xgwm28gbryy7q96j9ys6hfszmv0qxpr5698hxnhknscp"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/pkhuong/Napa-FFT3")
      (synopsis "Fast Fourier Transform routines in Common Lisp")
      (description
       "Napa-FFT3 provides Discrete Fourier Transform (DFT) routines, but also
buildings blocks to express common operations that involve DFTs: filtering,
convolutions, etc.")
      (license license:bsd-3))))

(define-public cl-napa-fft3
  (sbcl-package->cl-source-package sbcl-napa-fft3))

(define-public sbcl-cl-tga
  (let ((commit "4dc2f7b8a259b9360862306640a07a23d4afaacc")
        (revision "0"))
    (package
      (name "sbcl-cl-tga")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fisxoj/cl-tga")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "03k3npmn0xd3fd2m7vwxph82av2xrfb150imqrinlzqmzvz1v1br"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/fisxoj/cl-tga")
      (synopsis "TGA file loader for Common Lisp")
      (description
       "Cl-tga was written to facilitate loading @emph{.tga} files into OpenGL
programs.  It's a very simple library, and, at the moment, only supports
non-RLE encoded forms of the files.")
      (license license:expat))))

(define-public cl-tga
  (sbcl-package->cl-source-package sbcl-cl-tga))

(define-public ecl-cl-tga
  (sbcl-package->ecl-package sbcl-cl-tga))

(define-public sbcl-com.gigamonkeys.binary-data
  (let ((commit "22e908976d7f3e2318b7168909f911b4a00963ee")
        (revision "0"))
    (package
      (name "sbcl-com.gigamonkeys.binary-data")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/gigamonkey/monkeylib-binary-data")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "072v417vmcnvmyh8ddq9vmwwrizm7zwz9dpzi14qy9nsw8q649zw"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)))
      (home-page "https://github.com/gigamonkey/monkeylib-binary-data")
      (synopsis "Common Lisp library for reading and writing binary data")
      (description
       "This a Common Lisp library for reading and writing binary data.  It is
based on code from chapter 24 of the book @emph{Practical Common Lisp}.")
      (license license:bsd-3))))

(define-public cl-com.gigamonkeys.binary-data
  (sbcl-package->cl-source-package sbcl-com.gigamonkeys.binary-data))

(define-public ecl-com.gigamonkeys.binary-data
  (sbcl-package->ecl-package sbcl-com.gigamonkeys.binary-data))

(define-public sbcl-deflate
  (package
    (name "sbcl-deflate")
    (version "1.0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pmai/Deflate")
             (commit (string-append "release-" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1jpdjnxh6cw2d8hk70r2sxn92is52s9b855irvwkdd777fdciids"))))
    (build-system asdf-build-system/sbcl)
    (home-page "https://github.com/pmai/Deflate")
    (synopsis "Native deflate decompression for Common Lisp")
    (description
     "This library is an implementation of Deflate (RFC 1951) decompression,
with optional support for ZLIB-style (RFC 1950) and gzip-style (RFC 1952)
wrappers of deflate streams.  It currently does not handle compression.")
    (license license:expat)))

(define-public cl-deflate
  (sbcl-package->cl-source-package sbcl-deflate))

(define-public ecl-deflate
  (sbcl-package->ecl-package sbcl-deflate))

(define-public sbcl-skippy
  (let ((commit "e456210202ca702c792292c5060a264d45e47090")
        (revision "0"))
    (package
      (name "sbcl-skippy")
      (version (git-version "1.3.12" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/xach/skippy")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1sxbn5nh24qpx9w64x8mhp259cxcl1x8p126wk3b91ijjsj7l5vj"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://xach.com/lisp/skippy/")
      (synopsis "Common Lisp library for GIF images")
      (description
       "Skippy is a Common Lisp library to read and write GIF image files.")
      (license license:bsd-2))))

(define-public cl-skippy
  (sbcl-package->cl-source-package sbcl-skippy))

(define-public ecl-skippy
  (sbcl-package->ecl-package sbcl-skippy))

(define-public sbcl-cl-freetype2
  (let ((commit "96058da730b4812df916c1f4ee18c99b3b15a3de")
        (revision "0"))
    (package
      (name "sbcl-cl-freetype2")
      (version (git-version "1.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/rpav/cl-freetype2")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0f8darhairgxnb5bzqcny7nh7ss3471bdzix5rzcyiwdbr5kymjl"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cffi" ,sbcl-cffi)
         ("freetype" ,freetype)
         ("trivial-garbage" ,sbcl-trivial-garbage)))
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "src/ffi/ft2-lib.lisp"
                 (("\"libfreetype\"")
                  (string-append "\"" (assoc-ref inputs "freetype")
                                 "/lib/libfreetype\"")))
               (substitute* "src/ffi/grovel/grovel-freetype2.lisp"
                 (("-I/usr/include/freetype")
                  (string-append "-I" (assoc-ref inputs "freetype")
                                 "/include/freetype")))
               #t)))))
      (home-page "https://github.com/rpav/cl-freetype2")
      (synopsis "Common Lisp bindings for Freetype 2")
      (description
       "This is a general Freetype 2 wrapper for Common Lisp using CFFI.  It's
geared toward both using Freetype directly by providing a simplified API, as
well as providing access to the underlying C structures and functions for use
with other libraries which may also use Freetype.")
      (license license:bsd-3))))

(define-public cl-freetype2
  (sbcl-package->cl-source-package sbcl-cl-freetype2))

(define-public ecl-cl-freetype2
  (sbcl-package->ecl-package sbcl-cl-freetype2))

(define-public sbcl-opticl-core
  (let ((commit "b7cd13d26df6b824b216fbc360dc27bfadf04999")
        (revision "0"))
    (package
      (name "sbcl-opticl-core")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/slyrus/opticl-core")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0458bllabcdjghfrqx6aki49c9qmvfmkk8jl75cfpi7q0i12kh95"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)))
      (home-page "https://github.com/slyrus/opticl-core")
      (synopsis "Core classes and pixel access macros for Opticl")
      (description
       "This Common Lisp library contains the core classes and pixel access
macros for the Opticl image processing library.")
      (license license:bsd-2))))

(define-public cl-opticl-core
  (sbcl-package->cl-source-package sbcl-opticl-core))

(define-public ecl-opticl-core
  (sbcl-package->ecl-package sbcl-opticl-core))

(define-public sbcl-retrospectiff
  (let ((commit "c2a69d77d5010f8cdd9045b3e36a08a73da5d321")
        (revision "0"))
    (package
      (name "sbcl-retrospectiff")
      (version (git-version "0.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/slyrus/retrospectiff")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0qsn9hpd8j2kp43dk05j8dczz9zppdff5rrclbp45n3ksk9inw8i"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("cl-jpeg" ,sbcl-cl-jpeg)
         ("com.gigamonkeys.binary-data" ,sbcl-com.gigamonkeys.binary-data)
         ("deflate" ,sbcl-deflate)
         ("flexi-streams" ,sbcl-flexi-streams)
         ("ieee-floats" ,sbcl-ieee-floats)
         ("opticl-core" ,sbcl-opticl-core)))
      (home-page "https://github.com/slyrus/retrospectiff")
      (synopsis "Common Lisp library for TIFF images")
      (description
       "Retrospectiff is a common lisp library for reading and writing images
in the TIFF (Tagged Image File Format) format.")
      (license license:bsd-2))))

(define-public cl-retrospectif
  (sbcl-package->cl-source-package sbcl-retrospectiff))

(define-public ecl-retrospectiff
  (sbcl-package->ecl-package sbcl-retrospectiff))

(define-public sbcl-mmap
  (let ((commit "ba2e98c67e25f0fb8ff838238561120a23903ce7")
        (revision "0"))
    (package
      (name "sbcl-mmap")
      (version (git-version "1.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Shinmera/mmap")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0qd0xp20i1pcfn12kkapv9pirb6hd4ns7kz4zf1mmjwykpsln96q"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cffi" ,sbcl-cffi)
         ("parachute" ,sbcl-parachute)
         ("trivial-features" ,sbcl-trivial-features)))
      (inputs
       `(("cffi" ,sbcl-cffi)
         ("documentation-utils" ,sbcl-documentation-utils)))
      (home-page "https://shinmera.github.io/mmap/")
      (synopsis "File memory mapping for Common Lisp")
      (description
       "This is a utility library providing access to the @emph{mmap} family of
functions in a portable way.  It allows you to directly map a file into the
address space of your process without having to manually read it into memory
sequentially.  Typically this is much more efficient for files that are larger
than a few Kb.")
      (license license:zlib))))

(define-public cl-mmap
  (sbcl-package->cl-source-package sbcl-mmap))

(define-public ecl-mmap
  (sbcl-package->ecl-package sbcl-mmap))

(define-public sbcl-3bz
  (let ((commit "d6119083b5e0b0a6dd3abc2877936c51f3f3deed")
        (revision "0"))
    (package
      (name "sbcl-3bz")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/3b/3bz")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0fyxzyf2b6sc0w8d9g4nlva861565z6f3xszj0lw29x526dd9rhj"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("babel" ,sbcl-babel)
         ("cffi" ,sbcl-cffi)
         ("mmap" ,sbcl-mmap)
         ("nibbles" ,sbcl-nibbles)
         ("trivial-features" ,sbcl-trivial-features)))
      (arguments
       ;; FIXME: Without the following line, the build fails (see issue 41437).
       `(#:asd-systems '("3bz")))
      (home-page "https://github.com/3b/3bz")
      (synopsis "Deflate decompression for Common Lisp")
      (description
       "3bz is an implementation of Deflate decompression (RFC 1951) optionally
with zlib (RFC 1950) or gzip (RFC 1952) wrappers, with support for reading from
foreign pointers (for use with mmap and similar, etc), and from CL octet
vectors and streams.")
      (license license:expat))))

(define-public cl-3bz
  (sbcl-package->cl-source-package sbcl-3bz))

(define-public ecl-3bz
  (sbcl-package->ecl-package sbcl-3bz))

(define-public sbcl-zpb-exif
  (package
    (name "sbcl-zpb-exif")
    (version "1.2.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/xach/zpb-exif")
             (commit (string-append "release-" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "15s227jhby55cisz14xafb0p1ws2jmrg2rrbbd00lrb97im84hy6"))))
    (build-system asdf-build-system/sbcl)
    (home-page "https://xach.com/lisp/zpb-exif/")
    (synopsis "EXIF information extractor for Common Lisp")
    (description
     "This is a Common Lisp library to extract EXIF information from image
files.")
    (license license:bsd-2)))

(define-public cl-zpb-exif
  (sbcl-package->cl-source-package sbcl-zpb-exif))

(define-public ecl-zpb-exif
  (sbcl-package->ecl-package sbcl-zpb-exif))

(define-public sbcl-pngload
  (package
    (name "sbcl-pngload")
    (version "2.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bufferswap/pngload")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ix8dd0fxlf8xm0bszh1s7sx83hn0vqq8b8c9gkrd5m310w8mpvh"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("3bz" ,sbcl-3bz)
       ("alexandria" ,sbcl-alexandria)
       ("cffi" ,sbcl-cffi)
       ("mmap" ,sbcl-mmap)
       ("parse-float" ,sbcl-parse-float)
       ("static-vectors" ,sbcl-static-vectors)
       ("swap-bytes" ,sbcl-swap-bytes)
       ("zpb-exif" ,sbcl-zpb-exif)))
    (arguments
     ;; Test suite disabled because of a dependency cycle.
     ;; pngload tests depend on opticl which depends on pngload.
     '(#:tests? #f))
    (home-page "https://github.com/bufferswap/pngload")
    (synopsis "PNG image decoder for Common Lisp")
    (description
     "This is a Common Lisp library to load images in the PNG image format,
both from files on disk, or streams in memory.")
    (license license:expat)))

(define-public cl-pngload
  (sbcl-package->cl-source-package sbcl-pngload))

(define-public ecl-pngload
  (sbcl-package->ecl-package sbcl-pngload))

(define-public sbcl-opticl
  (let ((commit "e8684416eca2e78e82a7b436d436ef2ea24c019d")
        (revision "0"))
    (package
      (name "sbcl-opticl")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/slyrus/opticl")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "03rirnnhhisjbimlmpi725h1d3x0cfv00r57988am873dyzawmm1"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-jpeg" ,sbcl-cl-jpeg)
         ("cl-tga" ,sbcl-cl-tga)
         ("png-read" ,sbcl-png-read)
         ("pngload" ,sbcl-pngload)
         ("retrospectiff" ,sbcl-retrospectiff)
         ("skippy" ,sbcl-skippy)
         ("zpng" ,sbcl-zpng)))
      (arguments
       '(#:asd-files '("opticl.asd")))
      (home-page "https://github.com/slyrus/opticl")
      (synopsis "Image processing library for Common Lisp")
      (description
       "Opticl is a Common Lisp library for representing, processing, loading,
and saving 2-dimensional pixel-based images.")
      (license license:bsd-2))))

(define-public cl-opticl
  (sbcl-package->cl-source-package sbcl-opticl))

(define-public ecl-opticl
  (sbcl-package->ecl-package sbcl-opticl))

(define-public sbcl-mcclim
  (let ((commit "27b4d7a667c9b3faa74cabcb57706b888314fff7")
        (revision "0"))
    (package
      (name "sbcl-mcclim")
      (version (git-version "0.9.7" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/mcclim/mcclim")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0jijfgkwas6xnpp5wiii6slcx9pgsalngacb8zm29x6pamx2193h"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)
         ("pkg-config" ,pkg-config)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("babel" ,sbcl-babel)
         ("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("cl-freetype2" ,sbcl-cl-freetype2)
         ("cl-pdf" ,sbcl-cl-pdf)
         ("cffi" ,sbcl-cffi)
         ("cl-unicode" ,sbcl-cl-unicode)
         ("cl-vectors" ,sbcl-cl-vectors)
         ("closer-mop" ,sbcl-closer-mop)
         ("clx" ,sbcl-clx)
         ("flexi-streams" ,sbcl-flexi-streams)
         ("flexichain" ,sbcl-flexichain)
         ("font-dejavu" ,font-dejavu)
         ("fontconfig" ,fontconfig)
         ("freetype" ,freetype)
         ("harfbuzz" ,harfbuzz)
         ("log4cl" ,sbcl-log4cl)
         ("opticl" ,sbcl-opticl)
         ("spatial-trees" ,sbcl-spatial-trees)
         ("swank" ,sbcl-slime-swank)
         ("trivial-features" ,sbcl-trivial-features)
         ("trivial-garbage" ,sbcl-trivial-garbage)
         ("trivial-gray-streams" ,sbcl-trivial-gray-streams)
         ("zpb-ttf" ,sbcl-zpb-ttf)))
      (arguments
       '(#:asd-systems '("mcclim"
                         "clim-examples")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               ;; mcclim-truetype uses DejaVu as default font and
               ;; sets the path at build time.
               (substitute* "Extensions/fonts/fontconfig.lisp"
                 (("/usr/share/fonts/truetype/dejavu/")
                  (string-append (assoc-ref inputs "font-dejavu")
                                 "/share/fonts/truetype/")))
               (substitute* "Extensions/fontconfig/src/functions.lisp"
                 (("libfontconfig\\.so")
                  (string-append (assoc-ref inputs "fontconfig")
                                 "/lib/libfontconfig.so")))
               (substitute* "Extensions/harfbuzz/src/functions.lisp"
                 (("libharfbuzz\\.so")
                  (string-append (assoc-ref inputs "harfbuzz")
                                 "/lib/libharfbuzz.so")))
               #t))
           (add-after 'unpack 'fix-build
             (lambda _
               ;; The cffi-grovel system does not get loaded automatically,
               ;; so we load it explicitly.
               (substitute* "Extensions/fontconfig/mcclim-fontconfig.asd"
                 (("\\(asdf:defsystem #:mcclim-fontconfig" all)
                  (string-append "(asdf:load-system :cffi-grovel)\n" all)))
               (substitute* "Extensions/harfbuzz/mcclim-harfbuzz.asd"
                 (("\\(asdf:defsystem #:mcclim-harfbuzz" all)
                  (string-append "(asdf:load-system :cffi-grovel)\n" all)))
               #t)))))
      (home-page "https://common-lisp.net/project/mcclim/")
      (synopsis "Common Lisp GUI toolkit")
      (description
       "McCLIM is an implementation of the @emph{Common Lisp Interface Manager
specification}, a toolkit for writing GUIs in Common Lisp.")
      (license license:lgpl2.1+))))

(define-public cl-mcclim
  (sbcl-package->cl-source-package sbcl-mcclim))

(define-public ecl-mcclim
  (sbcl-package->ecl-package sbcl-mcclim))

(define-public sbcl-cl-inflector
  (let ((commit "f1ab16919ccce3bd82a0042677d9616dde2034fe")
        (revision "1"))
    (package
      (name "sbcl-cl-inflector")
      (version (git-version "0.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/AccelerationNet/cl-inflector")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1xwwlhik1la4fp984qnx2dqq24v012qv4x0y49sngfpwg7n0ya7y"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("lisp-unit2" ,sbcl-lisp-unit2)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-ppcre" ,sbcl-cl-ppcre)))
      (home-page "https://github.com/AccelerationNet/cl-inflector")
      (synopsis "Library to pluralize/singularize English and Portuguese words")
      (description
       "This is a common lisp library to easily pluralize and singularize
English and Portuguese words.  This is a port of the ruby ActiveSupport
Inflector module.")
      (license license:expat))))

(define-public cl-inflector
  (sbcl-package->cl-source-package sbcl-cl-inflector))

(define-public ecl-cl-inflector
  (sbcl-package->ecl-package sbcl-cl-inflector))

(define-public sbcl-qbase64
  (package
    (name "sbcl-qbase64")
    (version "0.3.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/chaitanyagupta/qbase64")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1dir0s70ca3hagxv9x15zq4p4ajgl7jrcgqsza2n2y7iqbxh0dwi"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("metabang-bind" ,sbcl-metabang-bind)
       ("trivial-gray-streams" ,sbcl-trivial-gray-streams)))
    (native-inputs
     `(("fiveam" ,sbcl-fiveam)))
    (home-page "https://github.com/chaitanyagupta/qbase64")
    (synopsis "Base64 encoder and decoder for Common Lisp")
    (description "@code{qbase64} provides a fast and flexible base64 encoder
and decoder for Common Lisp.")
    (license license:bsd-3)))

(define-public cl-qbase64
  (sbcl-package->cl-source-package sbcl-qbase64))

(define-public ecl-qbase64
  (sbcl-package->ecl-package sbcl-qbase64))

(define-public sbcl-lw-compat
  ;; No release since 2013.
  (let ((commit "aabfe28c6c1a4949f9d7b3cb30319367c9fd1c0d"))
    (package
      (name "sbcl-lw-compat")
      (version (git-version "1.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/pcostanza/lw-compat/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "131rq5k2mlv9bfhmafiv6nfsivl4cxx13d9wr06v5jrqnckh4aav"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/pcostanza/lw-compat/")
      (synopsis "LispWorks utilities ported to other Common Lisp implementations")
      (description "This package contains a few utility functions from the
LispWorks library that are used in software such as ContextL.")
      (license license:expat))))

(define-public cl-lw-compat
  (sbcl-package->cl-source-package sbcl-lw-compat))

(define-public ecl-lw-compat
  (sbcl-package->ecl-package sbcl-lw-compat))

(define-public sbcl-contextl
  ;; No release since 2013.
  (let ((commit "5d18a71a85824f6c25a9f35a21052f967b8b6bb9"))
    (package
      (name "sbcl-contextl")
      (version (git-version "1.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/pcostanza/contextl/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0gk1izx6l6g48nypmnm9r6mzjx0jixqjj2kc6klf8a88rr5xd226"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("closer-mop" ,sbcl-closer-mop)
         ("lw-compat" ,sbcl-lw-compat)))
      (home-page "https://github.com/pcostanza/contextl")
      (synopsis "Context-oriented programming for Common Lisp")
      (description "ContextL is a CLOS extension for Context-Oriented
Programming (COP).

Find overview of ContextL's features in an overview paper:
@url{http://www.p-cos.net/documents/contextl-soa.pdf}.  See also this general
overview article about COP which also contains some ContextL examples:
@url{http://www.jot.fm/issues/issue_2008_03/article4/}.")
      (license license:expat))))

(define-public cl-contextl
  (sbcl-package->cl-source-package sbcl-contextl))

(define-public ecl-contextl
  (sbcl-package->ecl-package sbcl-contextl))

(define-public sbcl-hu.dwim.common-lisp
  (package
    (name "sbcl-hu.dwim.common-lisp")
    (version "2015-07-09")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "http://beta.quicklisp.org/archive/hu.dwim.common-lisp/"
             version "/hu.dwim.common-lisp-"
             (string-replace-substring version "-" "")
             "-darcs.tgz"))
       (sha256
        (base32 "13cxrvh55rw080mvfir7s7k735l9rcfh3khxp97qfwd5rz0gadb9"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("hu.dwim.asdf" ,sbcl-hu.dwim.asdf)))
    (home-page "http://dwim.hu/")
    (synopsis "Redefine some standard Common Lisp names")
    (description "This library is a redefinition of the standard Common Lisp
package that includes a number of renames and shadows. ")
    (license license:public-domain)))

(define-public cl-hu.dwim.common-lisp
  (sbcl-package->cl-source-package sbcl-hu.dwim.common-lisp))

(define-public ecl-hu.dwim.common-lisp
  (sbcl-package->ecl-package sbcl-hu.dwim.common-lisp))

(define-public sbcl-hu.dwim.common
  (package
    (name "sbcl-hu.dwim.common")
    (version "2015-07-09")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "http://beta.quicklisp.org/archive/hu.dwim.common/"
             version "/hu.dwim.common-"
             (string-replace-substring version "-" "")
             "-darcs.tgz"))
       (sha256
        (base32 "12l1rr6w9m99w0b5gc6hv58ainjfhbc588kz6vwshn4gqsxyzbhp"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("hu.dwim.asdf" ,sbcl-hu.dwim.asdf)))
    (inputs
     `(("alexandria" ,sbcl-alexandria)
       ("anaphora" ,sbcl-anaphora)
       ("closer-mop" ,sbcl-closer-mop)
       ("hu.dwim.common-lisp" ,sbcl-hu.dwim.common-lisp)
       ("iterate" ,sbcl-iterate)
       ("metabang-bind" ,sbcl-metabang-bind)))
    (home-page "http://dwim.hu/")
    (synopsis "Common Lisp library shared by other hu.dwim systems")
    (description "This package contains a support library for other
hu.dwim systems.")
    (license license:public-domain)))

(define-public cl-hu.dwim.common
  (sbcl-package->cl-source-package sbcl-hu.dwim.common))

(define-public ecl-hu.dwim.common
  (sbcl-package->ecl-package sbcl-hu.dwim.common))

(define-public sbcl-hu.dwim.defclass-star
  (package
    (name "sbcl-hu.dwim.defclass-star")
    (version "2015-07-09")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "http://beta.quicklisp.org/archive/hu.dwim.defclass-star/"
             version "/hu.dwim.defclass-star-"
             (string-replace-substring version "-" "")
             "-darcs.tgz"))
       (sha256
        (base32 "032982lyp0hm0ssxlyh572whi2hr4j1nqkyqlllaj373v0dbs3vs"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(;; These 2 inputs are only needed tests which are disabled, see below.
       ;; ("hu.dwim.common" ,sbcl-hu.dwim.common)
       ;; Need cl- package for the :hu.dwim.stefil+hu.dwim.def+swank system.
       ;; ("hu.dwim.stefil" ,cl-hu.dwim.stefil)
       ("hu.dwim.asdf" ,sbcl-hu.dwim.asdf)))
    (arguments
     `(#:test-asd-file "hu.dwim.defclass-star.test.asd"
       ;; Tests require a circular dependency: hu.dwim.stefil -> hu.dwim.def
       ;; -> hu.dwim.util -> hu.dwim.defclass-star.
       #:tests? #f))
    (home-page "http://dwim.hu/?_x=dfxn&_f=mRIMfonK")
    (synopsis "Simplify definitions with defclass* and friends in Common Lisp")
    (description "@code{defclass-star} provides defclass* and defcondition* to
simplify class and condition declarations.  Features include:

@itemize
@item Automatically export all or select slots at compile time.
@item Define the @code{:initarg} and @code{:accessor} automatically.
@item Specify a name transformer for both the @code{:initarg} and
@code{:accessor}, etc.
@item Specify the @code{:initform} as second slot value.
@end itemize

See
@url{https://common-lisp.net/project/defclass-star/configuration.lisp.html}
for an example.")
    (license license:public-domain)))

(define-public cl-hu.dwim.defclass-star
  (sbcl-package->cl-source-package sbcl-hu.dwim.defclass-star))

(define-public ecl-hu.dwim.defclass-star
  (sbcl-package->ecl-package sbcl-hu.dwim.defclass-star))

(define-public sbcl-livesupport
  (let ((commit "71e6e412df9f3759ad8378fabb203913d82e228a")
	(revision "1"))
    (package
      (name "sbcl-livesupport")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/cbaggers/livesupport")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1rvnl0mncylbx63608pz5llss7y92j7z3ydambk9mcnjg2mjaapg"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/cbaggers/livesupport")
      (synopsis "Some helpers that make livecoding a little easier")
      (description "This package provides a macro commonly used in livecoding to
enable continuing when errors are raised.  Simply wrap around a chunk of code
and it provides a restart called @code{continue} which ignores the error and
carrys on from the end of the body.")
      (license license:bsd-2))))

(define-public cl-livesupport
  (sbcl-package->cl-source-package sbcl-livesupport))

(define-public ecl-livesupport
  (sbcl-package->ecl-package sbcl-livesupport))

(define-public sbcl-envy
  (let ((commit "956321b2852d58ba71c6fe621f5c2924178e9f88")
	(revision "1"))
    (package
      (name "sbcl-envy")
      (version (git-version "0.1" revision commit))
      (home-page "https://github.com/fukamachi/envy")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "17iwrfxcdinjbb2h6l09qf40s7xkbhrpmnljlwpjy8l8rll8h3vg"))))
      (build-system asdf-build-system/sbcl)
      ;; (native-inputs ; Only for tests.
      ;;  `(("prove" ,sbcl-prove)
      ;;    ("osicat" ,sbcl-osicat)))
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-tests
             (lambda _
               (substitute* "envy-test.asd"
                 (("cl-test-more") "prove"))
               #t)))
         ;; Tests fail with
         ;;   Component ENVY-ASD::ENVY-TEST not found, required by #<SYSTEM "envy">
         ;; like xsubseq.  Why?
         #:tests? #f))
      (synopsis "Common Lisp configuration switcher inspired by Perl's Config::ENV.")
      (description "Envy is a configuration manager for various applications.
Envy uses an environment variable to determine a configuration to use.  This
can separate configuration system from an implementation.")
      (license license:bsd-2))))

(define-public cl-envy
  (sbcl-package->cl-source-package sbcl-envy))

(define-public ecl-envy
  (sbcl-package->ecl-package sbcl-envy))

(define-public sbcl-mito
  (let ((commit "d3b9e375ef364a65692da2185085a08c969ac88a")
	(revision "1"))
    (package
      (name "sbcl-mito")
      (version (git-version "0.1" revision commit))
      (home-page "https://github.com/fukamachi/mito")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "08mncgzjnbbsf1a6am3l73iw4lyfvz5ldjg5g84awfaxml4p73mb"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("cl-reexport" ,sbcl-cl-reexport)
         ("closer-mop" ,sbcl-closer-mop)
         ("dbi" ,sbcl-dbi)
         ("dissect" ,sbcl-dissect)
         ("esrap" ,sbcl-esrap)
         ("local-time" ,sbcl-local-time)
         ("optima" ,sbcl-optima)
         ("sxql" ,sbcl-sxql)
         ("uuid" ,sbcl-uuid)))
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'remove-non-functional-tests
             (lambda _
               (substitute* "mito-test.asd"
                 (("\\(:test-file \"db/mysql\"\\)") "")
                 (("\\(:test-file \"db/postgres\"\\)") "")
                 (("\\(:test-file \"dao\"\\)") "")
                 ;; TODO: migration/sqlite3 should work, re-enable once
                 ;; upstream has fixed it:
                 ;; https://github.com/fukamachi/mito/issues/70
                 (("\\(:test-file \"migration/sqlite3\"\\)") "")
                 (("\\(:test-file \"migration/mysql\"\\)") "")
                 (("\\(:test-file \"migration/postgres\"\\)") "")
                 (("\\(:test-file \"postgres-types\"\\)") "")
                 (("\\(:test-file \"mixin\"\\)") ""))
               #t)))
         ;; TODO: While all enabled tests pass, the phase fails with:
         ;; Component MITO-ASD::MITO-TEST not found, required by #<SYSTEM "mito">
         #:tests? #f))
      (synopsis "ORM for Common Lisp with migrations and relationships support")
      (description "Mito is yet another object relational mapper, and it aims
to be a successor of Integral.

@itemize
@item Support MySQL, PostgreSQL and SQLite3.
@item Add id (serial/uuid primary key), created_at and updated_at by default
like Ruby's ActiveRecord.
@item Migrations.
@item Database schema versioning.
@end itemize\n")
      (license license:llgpl))))

(define-public cl-mito
  (sbcl-package->cl-source-package sbcl-mito))

(define-public ecl-mito
  (sbcl-package->ecl-package sbcl-mito))

(define-public sbcl-kebab
  (let ((commit "e7f77644c4e46131e7b8039d191d35fe6211f31b")
        (revision "1"))
    (package
      (name "sbcl-kebab")
      (version (git-version "0.1" revision commit))
      (home-page "https://github.com/pocket7878/kebab")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0j5haabnvj0vz0rx9mwyfsb3qzpga9nickbjw8xs6vypkdzlqv1b"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cl-ppcre" ,sbcl-cl-ppcre)
         ("alexandria" ,sbcl-alexandria)
         ("cl-interpol" ,sbcl-cl-interpol)
         ("split-sequence" ,sbcl-split-sequence)))
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (arguments
       ;; Tests passes but the phase fails with
       ;; Component KEBAB-ASD::KEBAB-TEST not found, required by #<SYSTEM "kebab">.
       `(#:tests? #f))
      (synopsis "Common Lisp case converter")
      (description "This Common Lisp library converts strings, symbols and
keywords between any of the following typographical cases: PascalCase,
camelCase, snake_case, kebab-case (lisp-case).")
      (license license:llgpl))))

(define-public cl-kebab
  (sbcl-package->cl-source-package sbcl-kebab))

(define-public ecl-kebab
  (sbcl-package->ecl-package sbcl-kebab))

(define-public sbcl-datafly
  (let ((commit "adece27fcbc4b5ea39ad1a105048b6b7166e3b0d")
        (revision "1"))
    (package
      (name "sbcl-datafly")
      (version (git-version "0.1" revision commit))
      (home-page "https://github.com/fukamachi/datafly")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "16b78kzmglp2a4nxlxxl7rpf5zaibsgagn0p3c56fsxvx0c4hszv"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("iterate" ,sbcl-iterate)
         ("optima" ,sbcl-optima)
         ("trivial-types" ,sbcl-trivial-types)
         ("closer-mop" ,sbcl-closer-mop)
         ("cl-syntax" ,sbcl-cl-syntax)
         ("sxql" ,sbcl-sxql)
         ("dbi" ,sbcl-dbi)
         ("babel" ,sbcl-babel)
         ("local-time" ,sbcl-local-time)
         ("function-cache" ,sbcl-function-cache)
         ("jonathan" ,sbcl-jonathan)
         ("kebab" ,sbcl-kebab)
         ("log4cl" ,sbcl-log4cl)))
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (arguments
       ;; TODO: Tests fail with
       ;; While evaluating the form starting at line 22, column 0
       ;;   of #P"/tmp/guix-build-sbcl-datafly-0.1-1.adece27.drv-0/source/t/datafly.lisp":
       ;; Unhandled SQLITE:SQLITE-ERROR in thread #<SB-THREAD:THREAD "main thread" RUNNING
       ;; {10009F8083}>:
       ;;   Error when binding parameter 1 to value NIL.
       ;; Code RANGE: column index out of range.
       `(#:tests? #f))
      (synopsis "Lightweight database library for Common Lisp")
      (description "Datafly is a lightweight database library for Common Lisp.")
      (license license:bsd-3))))

(define-public cl-datafly
  (sbcl-package->cl-source-package sbcl-datafly))

(define-public ecl-datafly
  (sbcl-package->ecl-package sbcl-datafly))

(define-public sbcl-do-urlencode
  (let ((commit "199846441dad5dfac5478b8dee4b4e20d107af6a")
        (revision "1"))
    (package
      (name "sbcl-do-urlencode")
      (version (git-version "0.0.0" revision commit))
      (home-page "https://github.com/drdo/do-urlencode")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0k2i3d4k9cpci235mwfm0c5a4yqfkijr716bjv7cdlpzx88lazm9"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("babel" ,sbcl-babel)))
      (synopsis "Percent Encoding (aka URL Encoding) Common Lisp library")
      (description "This library provides trivial percent encoding and
decoding functions for URLs.")
      (license license:isc))))

(define-public cl-do-urlencode
  (sbcl-package->cl-source-package sbcl-do-urlencode))

(define-public ecl-do-urlencode
  (sbcl-package->ecl-package sbcl-do-urlencode))

(define-public sbcl-cl-emb
  (let ((commit "fd8652174d048d4525a81f38cdf42f4fa519f840")
        (revision "1"))
    (package
      (name "sbcl-cl-emb")
      (version (git-version "0.4.3" revision commit))
      (home-page "https://common-lisp.net/project/cl-emb/")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/38a938c2/cl-emb")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1xcm31n7afh5316lwz8iqbjx7kn5lw0l11arg8mhdmkx42aj4gkk"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cl-ppcre" ,sbcl-cl-ppcre)))
      (synopsis "Templating system for Common Lisp")
      (description "A mixture of features from eRuby and HTML::Template.  You
could name it \"Yet Another LSP\" (LispServer Pages) but it's a bit more than
that and not limited to a certain server or text format.")
      (license license:llgpl))))

(define-public cl-emb
  (sbcl-package->cl-source-package sbcl-cl-emb))

(define-public ecl-cl-emb
  (sbcl-package->ecl-package sbcl-cl-emb))

(define-public sbcl-cl-project
  (let ((commit "151107014e534fc4666222d57fec2cc8549c8814")
        (revision "1"))
    (package
      (name "sbcl-cl-project")
      (version (git-version "0.3.1" revision commit))
      (home-page "https://github.com/fukamachi/cl-project")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1rmh6s1ncv8s2yrr14ja9wisgg745sq6xibqwb341ikdicxdp26y"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cl-emb" ,sbcl-cl-emb)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("local-time" ,sbcl-local-time)
         ("prove" ,sbcl-prove)))
      (arguments
       ;; Tests depend on caveman, which in turns depends on cl-project.
       '(#:tests? #f
         #:asd-files '("cl-project.asd")))
      (synopsis "Generate a skeleton for modern Common Lisp projects")
      (description "This library provides a modern project skeleton generator.
In contract with other generators, CL-Project generates one package per file
and encourages unit testing by generating a system for unit testing, so you
can begin writing unit tests as soon as the project is generated.")
      (license license:llgpl))))

(define-public cl-project
  (sbcl-package->cl-source-package sbcl-cl-project))

(define-public ecl-cl-project
  (sbcl-package->ecl-package sbcl-cl-project))

(define-public sbcl-caveman
  (let ((commit "faa5f7e3b364fd7e7096af9a7bb06728b8d80441") ; No release since 2012
        (revision "1"))
    (package
      (name "sbcl-caveman")
      (version (git-version "2.4.0" revision commit))
      (home-page "http://8arrow.org/caveman/")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/caveman/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0kh0gx05pczk8f7r9qdi4zn1p3d0a2prps27k7jpgvc1dxkl8qhq"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("ningle" ,cl-ningle)
         ("lack" ,sbcl-lack)
         ("cl-project" ,sbcl-cl-project)
         ("dbi" ,sbcl-dbi)
         ("cl-syntax" ,sbcl-cl-syntax)
         ("myway" ,sbcl-myway)
         ("quri" ,sbcl-quri)))
      (native-inputs
       `(("usocket" ,sbcl-usocket)
         ("dexador" ,sbcl-dexador)))
      (arguments
       `(#:asd-files '("caveman2.asd")
         #:asd-systems '("caveman2")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'remove-v1
             (lambda _
               (delete-file-recursively "v1")
               (for-each delete-file
                         '("README.v1.markdown" "caveman.asd" "caveman-test.asd")))))
         ;; TODO: Tests fail with:
         ;; writing /gnu/store/...-sbcl-caveman-2.4.0-1.faa5f7e/share/common-lisp/sbcl-source/caveman2/v2/t/tmp/myapp573/tests/myapp573.lisp
         ;; While evaluating the form starting at line 38, column 0
         ;;   of #P"/tmp/guix-build-sbcl-caveman-2.4.0-1.faa5f7e.drv-0/source/v2/t/caveman.lisp":
         ;; Unhandled ASDF/FIND-COMPONENT:MISSING-COMPONENT in thread #<SB-THREAD:THREAD "main thread" RUNNING
         ;;                                                              {10009F8083}>:
         ;;   Component "myapp573" not found
         #:tests? #f))
      (synopsis "Lightweight web application framework in Common Lisp")
      (description "Caveman is intended to be a collection of common parts for
web applications.  Caveman2 has three design goals:

@itemize
@item Be extensible.
@item Be practical.
@item Don't force anything.
@end itemize\n")
      (license license:llgpl))))

(define-public cl-caveman
  (package
    (inherit
     (sbcl-package->cl-source-package sbcl-caveman))
    (propagated-inputs
     `(("ningle" ,cl-ningle)))))

(define-public ecl-caveman
  (sbcl-package->ecl-package sbcl-caveman))

(define-public sbcl-lambda-fiddle
  (let ((commit "d16bba55acf6065b412f64ab8fdff679a4a32b1e") ;; no tagged branch
	(revision "1"))
    (package
      (name "sbcl-lambda-fiddle")
      (version (git-version "1.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Shinmera/lambda-fiddle")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1zarj1pqjqmk95kdx1axkgpwy2wq3canczk7f9z5hvaw5an6gand"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/Shinmera/lambda-fiddle")
      (synopsis "Collection of utilities to process lambda-lists")
      (description "This collection of utilities is useful in contexts where
you want a macro that uses lambda-lists in some fashion but need more precise
processing.")
      (license license:zlib))))

(define-public cl-lambda-fiddle
  (sbcl-package->cl-source-package sbcl-lambda-fiddle))

(define-public ecl-lambda-fiddle
  (sbcl-package->ecl-package sbcl-lambda-fiddle))

(define-public sbcl-xmls
  (let ((commit "18546f0850b1338e03997ffd1696add1cb1800d1") ;; no tagged branch
	(revision "1"))
    (package
      (name "sbcl-xmls")
      (version (git-version "3.0.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/rpgoldman/xmls")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1lmvfml2ldbb1wkhm25jqqk2bhwsz52hhcgljbnzj1xr8xhc3anp"))))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/rpgoldman/xmls")
      (synopsis "Non-validating XML parser for Common Lisp")
      (description "Xmls is a self-contained, easily embedded parser that
recognizes a useful subset of the XML spec.  It provides a simple mapping from
XML to Lisp structures or s-expressions and back.")
      (license license:bsd-2))))

(define-public cl-xmls
  (sbcl-package->cl-source-package sbcl-xmls))

(define-public ecl-xmls
  (sbcl-package->ecl-package sbcl-xmls))

(define-public sbcl-geco
  (package
    (name "sbcl-geco")
    (version "2.1.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gpwwjr/GECO")
             (commit (string-append "v" version))))
       (file-name (git-file-name "geco" version))
       (sha256
        (base32 "1rc8a4mk40hjx5qy980hjylv6xxqdbq38hg8c4w30y93abfd519s"))))
    (build-system asdf-build-system/sbcl)
    (home-page "http://hiwaay.net/~gpw/geco/geco.html")
    (synopsis "Genetic algorithm toolkit for Common Lisp")
    (description
     "GECO (Genetic Evolution through Combination of Objects) is an extensible,
object-oriented framework for prototyping genetic algorithms in Common Lisp.")
    (license license:lgpl2.1+)))

(define-public cl-geco
  (sbcl-package->cl-source-package sbcl-geco))

(define-public ecl-geco
  (sbcl-package->ecl-package sbcl-geco))

(define-public sbcl-html-entities
  (let ((commit "4af018048e891f41d77e7d680ed3aeb639e1eedb"))
    (package
      (name "sbcl-html-entities")
      (version (git-version "0.02" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/BnMcGn/html-entities/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1b2yl6lf6vis17y4n5s505p7ica96bdafcl6vydy1hg50fy33nfr"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("ppcre" ,sbcl-cl-ppcre)))
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (home-page "https://github.com/BnMcGn/html-entities/")
      (synopsis "Encode and decode entities in HTML with Common Lisp")
      (description "Html-entities is a Common Lisp library that lets you
encode and decode entities in HTML.")
      (license license:expat))))

(define-public cl-html-entities
  (sbcl-package->cl-source-package sbcl-html-entities))

(define-public ecl-html-entities
  (sbcl-package->ecl-package sbcl-html-entities))

(define-public sbcl-quicksearch
  (let ((commit "fb02ecf7c876ec580ab18c7d2c8c7814c06af599"))
    (package
      (name "sbcl-quicksearch")
      (version (git-version "0.01.04" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/tkych/quicksearch/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "16k19zjkhh7r64vjq371k5jwjs7cdfjz83flh561n4h4v1z89fps"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("iterate" ,sbcl-iterate)
         ("alexandria" ,sbcl-alexandria)
         ("anaphora" ,sbcl-anaphora)
         ("ppcre" ,sbcl-cl-ppcre)
         ("drakma" ,sbcl-drakma)
         ("html-entities" ,sbcl-html-entities)
         ("yason" ,sbcl-yason)
         ("flexi-streams" ,sbcl-flexi-streams)
         ("do-urlencode" ,sbcl-do-urlencode)))
      (home-page "https://github.com/tkych/quicksearch/")
      (synopsis "Search Engine Interface for Common Lisp packages")
      (description "Quicksearch is a search-engine-interface for Common Lisp.
The goal of Quicksearch is to find the Common Lisp library quickly.  For
example, if you will find the library about json, just type @code{(qs:?
'json)} at REPL.

The function @code{quicksearch} searches for Common Lisp projects in
Quicklisp, Cliki, GitHub and BitBucket, then outputs results in REPL.  The
function @code{?} is abbreviation wrapper for @code{quicksearch}.")
      (license license:expat))))

(define-public cl-quicksearch
  (sbcl-package->cl-source-package sbcl-quicksearch))

(define-public ecl-quicksearch
  (sbcl-package->ecl-package sbcl-quicksearch))

(define-public sbcl-agutil
  (let ((commit "df188d754d472da9faa1601a48f1f37bb7b34d68"))
    (package
      (name "sbcl-agutil")
      (version (git-version "0.0.1" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/alex-gutev/agutil/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1xpnyzksk2xld64b6lw6rw0gn5zxlb77jwna59sd4yl7kxhxlfpf"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("trivia" ,sbcl-trivia)))
      (home-page "https://github.com/alex-gutev/agutil/")
      (synopsis "Collection of Common Lisp utilities")
      (description "A collection of Common Lisp utility functions and macros
mostly not found in other utility packages.")
      (license license:expat))))

(define-public cl-agutil
  (sbcl-package->cl-source-package sbcl-agutil))

(define-public ecl-agutil
  (sbcl-package->ecl-package sbcl-agutil))

(define-public sbcl-custom-hash-table
  (let ((commit "f26983133940f5edf826ebbc8077acc04816ddfa"))
    (package
      (name "sbcl-custom-hash-table")
      (version (git-version "0.3" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/metawilm/cl-custom-hash-table")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1k4mvrpbqqds2fwjxp1bxmrfmr8ch4dkwhnkbw559knbqshvrlj5"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       '(#:asd-files '("cl-custom-hash-table.asd")
         #:asd-systems '("cl-custom-hash-table")))
      (home-page "https://github.com/metawilm/cl-custom-hash-table")
      (synopsis "Custom hash tables for Common Lisp")
      (description "This library allows creation of hash tables with arbitrary
@code{test}/@code{hash} functions, in addition to the @code{test} functions
allowed by the standard (@code{EQ}, @code{EQL}, @code{EQUAL} and
@code{EQUALP}), even in implementations that don't support this functionality
directly.")
      (license license:expat))))

(define-public cl-custom-hash-table
  (sbcl-package->cl-source-package sbcl-custom-hash-table))

(define-public ecl-custom-hash-table
  (sbcl-package->ecl-package sbcl-custom-hash-table))

(define-public sbcl-collectors
  (let ((commit "13acef25d8422d1d82e067b1861e513587c166ee"))
    (package
      (name "sbcl-collectors")
      (version (git-version "0.1" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/AccelerationNet/collectors")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1si68n1j6rpns8jw6ksqjpb937pdl30v7xza8rld7j5vh0jhy2yi"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("closer-mop" ,sbcl-closer-mop)
         ("symbol-munger" ,sbcl-symbol-munger)))
      (native-inputs
       `(("lisp-unit2" ,sbcl-lisp-unit2)))
      (home-page "https://github.com/AccelerationNet/collectors/")
      (synopsis "Common lisp library providing collector macros")
      (description "A small collection of common lisp macros to make
collecting values easier.")
      (license license:bsd-3))))

(define-public cl-collectors
  (sbcl-package->cl-source-package sbcl-collectors))

(define-public ecl-collectors
  (sbcl-package->ecl-package sbcl-collectors))

(define-public sbcl-cl-environments
  (let ((commit "0b22154c5afefef23d1eba9a4fae11d73580ef41")) ; No version in 2 years.
    (package
      (name "sbcl-cl-environments")
      (version (git-version "0.2.3" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/alex-gutev/cl-environments")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "18r3wfarr7lgn78m6c66r0r9aazirv07gy7xgvqkl9pmrz1bc47m"))))
      (build-system asdf-build-system/sbcl)
      (propagated-inputs
       `(("alexandria" ,cl-alexandria)
         ("anaphora" ,cl-anaphora)
         ("collectors" ,cl-collectors)
         ("optima" ,cl-optima)))
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (home-page "https://github.com/alex-gutev/cl-environments")
      (synopsis "Implements the Common Lisp standard environment access API")
      (description "This library provides a uniform API, as specified in Common
Lisp the Language 2, for accessing information about variable and function
bindings from implementation-defined lexical environment objects.  All major
Common Lisp implementations are supported, even those which don't support the
CLTL2 environment access API.")
      (license license:expat))))

(define-public cl-environments
  (sbcl-package->cl-source-package sbcl-cl-environments))

(define-public ecl-environments
  (sbcl-package->ecl-package sbcl-cl-environments))

(define-public sbcl-static-dispatch
  (package
    (name "sbcl-static-dispatch")
    (version "0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/alex-gutev/static-dispatch")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wp5yz8liqqic3yifqf33qhccd755pd7ycvsq1j4i7k3f1wm18i0"))))
    (build-system asdf-build-system/sbcl)
    (inputs
     `(("agutil" ,sbcl-agutil)
       ("alexandria" ,sbcl-alexandria)
       ("anaphora" ,sbcl-anaphora)
       ("arrows" ,sbcl-arrows)
       ("closer-mop" ,sbcl-closer-mop)
       ("iterate" ,sbcl-iterate)
       ("trivia" ,sbcl-trivia)))
    (propagated-inputs
     ;; FIXME: `sbcl-cl-environments' input fails with
     ;;
     ;; compiling #<CL-SOURCE-FILE "collectors" "collectors">
     ;; Unhandled SB-INT:SIMPLE-FILE-ERROR in thread #<SB-THREAD:THREAD "main thread" RUNNING
     ;; {1008238213}>:
     ;; Error opening #P"/.../cl-environments/src/common/package-tmp5GEXGEG5.fasl":
     ;; Permission denied
     `(("cl-environments" ,cl-environments)))
    (native-inputs
     `(("prove" ,sbcl-prove)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         ;; Use `arrows' instead of cl-arrows which is abandoned and unlicensed.
         ;; https://github.com/nightfly19/cl-arrows/issues/5
         (add-after 'unpack 'use-arrows-instead-of-cl-arrows
           (lambda _
             (for-each
              (lambda (file)
                (substitute* file
                  ((":cl-arrows") ":arrows")))
              '("static-dispatch.asd"
                "src/package.lisp"
                "test/methods.lisp"
                "test/test.lisp")))))))
    (home-page "https://github.com/alex-gutev/static-dispatch")
    (synopsis "Static generic function dispatch for Common Lisp")
    (description "Static dispatch is a Common Lisp library, inspired by
@code{inlined-generic-function}, which allows standard Common Lisp generic
function dispatch to be performed statically (at compile time) rather than
dynamically (runtime).  This is similar to what is known as \"overloading\" in
languages such as C++ and Java.

The purpose of static dispatch is to provide an optimization in cases where
the usual dynamic dispatch is too slow, and the dynamic features of generic
functions, such as adding/removing methods at runtime are not required.  An
example of such a case is a generic equality comparison function.  Currently
generic functions are considered far too slow to implement generic arithmetic
and comparison operations when used heavily in numeric code.")
    (license license:expat)))

(define-public cl-static-dispatch
  (sbcl-package->cl-source-package sbcl-static-dispatch))

(define-public ecl-static-dispatch
  (sbcl-package->ecl-package sbcl-static-dispatch))

(define-public sbcl-generic-cl
  ;; Latest commit includes a necessary fix for our Guix build.
  (let ((commit "8e5a81487ee3c13fe5ffdc8bdda161d476639535"))
    (package
      (name "sbcl-generic-cl")
      (version (git-version "0.7.1" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/alex-gutev/generic-cl")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "11w0g79s4wmc78vmfng437rmsgnp5qn246zcyr540fp5nw0ad6ix"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("agutil" ,sbcl-agutil)
         ("alexandria" ,sbcl-alexandria)
         ("anaphora" ,sbcl-anaphora)
         ("arrows" ,sbcl-arrows)
         ("cl-custom-hash-table" ,sbcl-custom-hash-table)
         ("trivia" ,sbcl-trivia)))
      (propagated-inputs
       ;; FIXME: Same error as for `sbcl-static-dispatch'.
       `(("static-dispatch" ,cl-static-dispatch)))
      (native-inputs
       `(("prove" ,sbcl-prove)))
      (arguments
       ;; Tests fail because SBCL head size is not high enough.
       ;; https://github.com/alex-gutev/generic-cl/issues/6
       `(#:tests? #f))
      (home-page "https://alex-gutev.github.io/generic-cl/")
      (synopsis "Generic function interface to standard Common Lisp functions")
      (description "@code{generic-cl} provides a generic function wrapper over
various functions in the Common Lisp standard, such as equality predicates and
sequence operations.  The goal of this wrapper is to provide a standard
interface to common operations, such as testing for the equality of two
objects, which is extensible to user-defined types.")
      (license license:expat))))

(define-public cl-generic-cl
  (sbcl-package->cl-source-package sbcl-generic-cl))

(define-public ecl-generic-cl
  (sbcl-package->ecl-package sbcl-generic-cl))

(define-public sbcl-defpackage-plus
  (let ((revision "0")
        (commit "5492e27e0bdb7b75fa5177ea4388519dc7a75f11"))
    (package
      (name "sbcl-defpackage-plus")
      (version (git-version "1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/rpav/defpackage-plus")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0lzljvf343xb6mlh6lni2i27hpm5qd376522mk6hr2pa20vd6rdq"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)))
      (home-page "https://github.com/rpav/defpackage-plus")
      (synopsis "Extensible @code{DEFPACKAGE} variant with version support")
      (description
       "@code{DEFPACKAGE-PLUS} is an extensible @code{DEFPACKAGE} variant with
predictable cross-platform behavior and some utilities useful for versioning.")
      (license license:bsd-2))))

(define-public cl-defpackage-plus
  (sbcl-package->cl-source-package sbcl-defpackage-plus))

(define-public ecl-defpackage-plus
  (sbcl-package->ecl-package sbcl-defpackage-plus))

(define-public sbcl-deploy
  ;; tagged branch is outdated
  (let ((revision "1")
        (commit "59fd49719ef651a8fc11750bcfb337f132cff75f"))
    (package
      (name "sbcl-deploy")
      (version (git-version "1.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Shinmera/deploy")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1vl2116z4kw2pd3qd3n6mmg8g0mnwxr9dgddk86g7j1bis1z8k9a"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cffi" ,sbcl-cffi)
         ("documentation-utils" ,sbcl-documentation-utils)))
      (arguments
       '(#:asd-files '("deploy.asd")))
      (home-page "https://shinmera.github.io/deploy/")
      (synopsis "Deployment tools for standalone Common Lisp application")
      (description
       "This is a system to help you easily and quickly deploy standalone
common lisp applications as binaries.  Specifically it is geared towards
applications with foreign library dependencies that run some kind of GUI.")
      (license license:artistic2.0))))

(define-public cl-deploy
  (sbcl-package->cl-source-package sbcl-deploy))

(define-public ecl-deploy
  (sbcl-package->ecl-package sbcl-deploy))

(define-public sbcl-deeds
  ;; taged branch is outdated
  (let ((revision "1")
        (commit "f5df54eac79b58a34030e0eb8acf3952c788410d"))
    (package
      (name "sbcl-deeds")
      (version (git-version "1.1.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Shinmera/deeds")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "062cnb2dwli6pw3zvv46jfxyxdzcbzwsck5pa6nw03qf1j1hyg3k"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("closer-mop" ,sbcl-closer-mop)
         ("form-fiddle" ,sbcl-form-fiddle)
         ("lambda-fiddle" ,sbcl-lambda-fiddle)))
      (home-page "https://github.com/Shinmera/deeds")
      (synopsis "Extensible Event Delivery System")
      (description
       "@code{deeds} allows for efficient event delivery to multiple handlers
with a complex event filtering system.")
      (license license:zlib))))

(define-public cl-deeds
  (sbcl-package->cl-source-package sbcl-deeds))

(define-public ecl-deeds
  (sbcl-package->ecl-package sbcl-deeds))

(define-public sbcl-make-hash
  ;; no tagged branch
  (let ((revision "1")
        (commit "ae0909cd8e697520a1085fac6f54ac2b448ebd21"))
    (package
      (name "sbcl-make-hash")
      (version (git-version "1.0.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/genovese/make-hash")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1qa4mcmb3pv44py0j129dd8hjx09c2akpnds53b69151mgwv5qz8"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/genovese/make-hash")
      (synopsis "Common Lisp package for flexible hash table creation")
      (description
       "This is a Common Lisp package for hash table creation with flexible,
extensible initializers.")
      (license license:bsd-3))))

(define-public cl-make-hash
  (sbcl-package->cl-source-package sbcl-make-hash))

(define-public ecl-make-hash
  (sbcl-package->ecl-package sbcl-make-hash))

(define-public sbcl-claw-support
  (package
    (name "sbcl-claw-support")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/borodust/claw-support")
             (commit "9a15c8bed04585f45e6a461bcda1b475144dbd0b")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1my2ka7h72ipx5n3b465g6kjkasrhsvhqlijwcg6dhlzs5yygl23"))))
    (build-system asdf-build-system/sbcl)
    (home-page "https://github.com/borodust/claw-support")
    (synopsis "Support routines for claw")
    (description
     "This package provides support routines for the @code{claw} Common Lisp
package.")
    (license license:expat)))

(define-public cl-claw-support
  (sbcl-package->cl-source-package sbcl-claw-support))

(define-public ecl-claw-support
  (sbcl-package->ecl-package sbcl-claw-support))

(define-public sbcl-array-operations
  (let ((commit "75cbc3b1adb2e3ce2109489753d0f290b071e81b")
        (revision "0"))
    (package
      (name "sbcl-array-operations")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/bendudson/array-operations")
               (commit commit)))
         (file-name (git-file-name "array-operations" version))
         (sha256
          (base32 "0ip49hhq32w80qsc7jmspyda5r2rsszvw0mk2r3341cld78sz9ya"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("alexandria" ,sbcl-alexandria)
         ("clunit2" ,sbcl-clunit2)))
      (inputs
       `(("let-plus" ,sbcl-let-plus)))
      (synopsis "Simple array operations library for Common Lisp")
      (description
       "This library is a collection of functions and macros for manipulating
Common Lisp arrays and performing numerical calculations with them.")
      (home-page "https://github.com/bendudson/array-operations")
      (license license:expat))))

(define-public cl-array-operations
  (sbcl-package->cl-source-package sbcl-array-operations))

(define-public ecl-array-operations
  (sbcl-package->ecl-package sbcl-array-operations))

(define-public sbcl-clml
  (let ((commit "95505b54c8c7b4b27f500c3be97fa5732f4b51a8")
        (revision "0"))
    (package
      (name "sbcl-clml")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/mmaul/clml")
               (commit commit)))
         (file-name (git-file-name "clml" version))
         (sha256
          (base32 "006pii59nmpc61n7p7h8ha5vjg6x0dya327i58z0rnvxs249h345"))
         ;; TODO: Remove this when the patch has been merged upstream.
         (patches (search-patches "sbcl-clml-fix-types.patch"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandia" ,sbcl-alexandria)
         ("array-operations" ,sbcl-array-operations)
         ("cl-fad" ,sbcl-cl-fad)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("drakma" ,sbcl-drakma)
         ("introspect-environment" ,sbcl-introspect-environment)
         ("iterate" ,sbcl-iterate)
         ("lparallel" ,sbcl-lparallel)
         ("parse-number" ,sbcl-parse-number)
         ("split-sequence" ,sbcl-split-sequence)
         ("trivial-garbage" ,sbcl-trivial-garbage)))
      (synopsis "Common Lisp machine learning library")
      (description
       "CLML (Common Lisp Machine Learning) is a high performance and large
scale statistical machine learning package")
      (home-page "https://mmaul.github.io/clml/")
      (license license:llgpl))))

(define-public cl-clml
  (sbcl-package->cl-source-package sbcl-clml))

(define-public sbcl-utm-ups
  (let ((commit "780f1d8ab6290ad2be0f40e2cddc2535fa6fe979")
        (revision "0"))
    (package
      (name "sbcl-utm-ups")
      (version (git-version "1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/glv2/utm-ups")
               (commit commit)))
         (file-name (git-file-name "utm-ups" version))
         (sha256
          (base32 "0l3kr2m56skf5cx3kkkdcis7msmidcsixx9fqjapkcjsj8x67aqq"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (synopsis
       "Convert coordinates between latitude/longitude and UTM or UPS")
      (description
       "This a Common Lisp library to convert geographic coordinates between
latitude/longitude and UTM (Universal Transverse Mercator) or UPS (Universal
Polar Stereographic).")
      (home-page "https://github.com/glv2/utm-ups")
      (license license:gpl3+))))

(define-public cl-utm-ups
  (sbcl-package->cl-source-package sbcl-utm-ups))

(define-public ecl-utm-ups
  (sbcl-package->ecl-package sbcl-utm-ups))

(define-public sbcl-mgrs
  (let ((commit "00455460407b7e5509d1be3da09bf6152956761f")
        (revision "0"))
    (package
      (name "sbcl-mgrs")
      (version (git-version "1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/glv2/mgrs")
               (commit commit)))
         (file-name (git-file-name "mgrs" version))
         (sha256
          (base32 "0ckvn4hg3wwivzavhfashb6fap4a1q10l8krhbng8bdb54ac10sz"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("utm-ups" ,sbcl-utm-ups)))
      (synopsis
       "Convert coordinates between latitude/longitude and MGRS")
      (description
       "This a Common Lisp library to convert geographic coordinates between
latitude/longitude and MGRS.")
      (home-page "https://github.com/glv2/mgrs")
      (license license:gpl3+))))

(define-public cl-mgrs
  (sbcl-package->cl-source-package sbcl-mgrs))

(define-public ecl-mgrs
  (sbcl-package->ecl-package sbcl-mgrs))

(define-public sbcl-maidenhead
  (let ((commit "b756d235c27b5d6798867aa240318af1a8f35d6d")
        (revision "0"))
    (package
      (name "sbcl-maidenhead")
      (version (git-version "1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/glv2/maidenhead")
               (commit commit)))
         (file-name (git-file-name "maidenhead" version))
         (sha256
          (base32 "02p990zprhjvifmsfk8yh3frvz6xyw26ikzxvzglqdixbal36nr3"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (synopsis
       "Convert coordinates between latitude/longitude and Maidenhead")
      (description
       "This a Common Lisp library to convert geographic coordinates between
latitude/longitude and Maidenhead locator system.")
      (home-page "https://github.com/glv2/maidenhead")
      (license license:gpl3+))))

(define-public cl-maidenhead
  (sbcl-package->cl-source-package sbcl-maidenhead))

(define-public ecl-maidenhead
  (sbcl-package->ecl-package sbcl-maidenhead))

(define-public sbcl-olc
  (let ((commit "517e27fa57d9a119b00a29c4b6b31e553deff309")
        (revision "0"))
    (package
      (name "sbcl-olc")
      (version (git-version "1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/glv2/olc")
               (commit commit)))
         (file-name (git-file-name "olc" version))
         (sha256
          (base32 "1lnfhp6z6kc8l605zp4siyjiw74y1h4bdq3jfizi084v505wxhgr"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (synopsis
       "Convert coordinates between latitude/longitude and Open Location Code")
      (description
       "This a Common Lisp library to convert geographic coordinates between
latitude/longitude and Open Location Code.")
      (home-page "https://github.com/glv2/olc")
      (license license:gpl3+))))

(define-public cl-olc
  (sbcl-package->cl-source-package sbcl-olc))

(define-public ecl-olc
  (sbcl-package->ecl-package sbcl-olc))

(define-public sbcl-regex
  (let ((commit "fbc9a9f313b9edc1788f33d4b23a29151635ae22"))
    (package
      (name "sbcl-regex")
      (version (git-version "1" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/michaelw/regex/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0wq5wlafrxv13wg28hg5b10sc48b88swsvznpy2zg7x37m4nmm6a"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/michaelw/regex/")
      (synopsis "Regular expression engine for Common Lisp")
      (description
       "This Common Lisp package provides a regular expression engine.")
      (license license:bsd-2))))

(define-public cl-regex
  (sbcl-package->cl-source-package sbcl-regex))

(define-public ecl-regex
  (sbcl-package->ecl-package sbcl-regex))

(define-public sbcl-clawk
  (let ((commit "3a91634df686417114044a98c063cbe76bfac7b6"))
    (package
      (name "sbcl-clawk")
      (version (git-version "4" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/sharplispers/clawk")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1ph3xjqilvinvgr9q3w47zxqyz1sqnq030nlx7kgkkv8j3bnqk7a"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("sbcl-regex" ,sbcl-regex)))
      (home-page "https://github.com/sharplispers/clawk")
      (synopsis "Common Lisp AWK")
      (description
       "CLAWK is an AWK implementation embedded into Common Lisp.")
      (license license:bsd-2))))

(define-public cl-clawk
  (sbcl-package->cl-source-package sbcl-clawk))

(define-public ecl-clawk
  (sbcl-package->ecl-package sbcl-clawk))

(define-public sbcl-check-it
  (let ((commit "b79c9103665be3976915b56b570038f03486e62f"))
    (package
      (name "sbcl-check-it")
      (version (git-version "0.1.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/DalekBaldwin/check-it/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1kbjwpniffdpv003igmlz5r0vy65m7wpfnhg54fhwirp1227hgg7"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)
         ("closer-mop" ,sbcl-closer-mop)
         ("optima" ,sbcl-optima)))
      (native-inputs
       `(("stefil" ,sbcl-stefil)))
      (home-page "https://github.com/arclanguage/Clamp")
      (synopsis "Randomized specification-based testing for Common Lisp")
      (description
       "This is a randomized property-based testing library for Common Lisp.
Rather than being a full-fledged general test framework in its own right, it's
designed to embed randomized tests in whatever framework you like.")
      (license license:llgpl))))

(define-public cl-check-it
  (sbcl-package->cl-source-package sbcl-check-it))

(define-public ecl-check-it
  (sbcl-package->ecl-package sbcl-check-it))

(define-public sbcl-clamp
  (let ((commit "02b8f3953e5753cc61a719807c82f3795cd28fe1"))
    (package
      (name "sbcl-clamp")
      (version (git-version "0.3" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/arclanguage/Clamp")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0fdr9nqfmmpxm6hvjdxi1jkclya9xlnrw1yc3cn1m4ww3f50p31m"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("iterate" ,sbcl-iterate)
         ("cl-syntax" ,sbcl-cl-syntax)))
      (native-inputs
       `(("cl-unit" ,sbcl-clunit)
         ("check-it" ,sbcl-check-it)))
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-build
             (lambda _
               (substitute* "clamp.asd"
                 (("\\(:file \"read\"     :depends-on \\(\"aliases\"\\)\\)")
                  "(:file \"read\"     :depends-on (\"aliases\" \"base\"))"))
               #t)))))
      (home-page "https://github.com/arclanguage/Clamp")
      (synopsis "Common Lisp with Arc macros and procedures")
      (description
       "Clamp is an attempt to bring the powerful, but verbose, language of
Common Lisp up to the terseness of Arc.

There are two parts to Clamp.  There is the core of Clamp, which implements
the utilities of Arc that are easily converted from Arc to Common Lisp.  The
other part is the \"experimental\" part.  It contains features of Arc that are
not so easy to copy (ssyntax, argument destructuring, etc.).")
      (license license:artistic2.0))))

(define-public cl-clamp
  (sbcl-package->cl-source-package sbcl-clamp))

(define-public ecl-clamp
  (sbcl-package->ecl-package sbcl-clamp))

(define-public sbcl-trivial-shell
  (let ((commit "e02ec191b34b52deca5d1c4ee99d4fa13b8772e0"))
    (package
      (name "sbcl-trivial-shell")
      (version (git-version "0.2.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/gwkkwg/trivial-shell")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "08mpkl5ij5sjfsyn8pq2kvsvpvyvr7ha1r8g1224fa667b8k2q85"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("lift" ,sbcl-lift)))
      (home-page "http://common-lisp.net/project/trivial-shell/")
      (synopsis "Common Lisp access to the shell")
      (description
       "A simple Common-Lisp interface to the underlying operating system.
It's independent of the implementation and operating system.")
      (license license:expat))))

(define-public cl-trivial-shell
  (sbcl-package->cl-source-package sbcl-trivial-shell))

(define-public ecl-trivial-shell
  (sbcl-package->ecl-package sbcl-trivial-shell))

(define-public sbcl-clesh
  (let ((commit "44e96e04a72e5bc006dc4eb02ce8962348dd4a11"))
    (package
      (name "sbcl-clesh")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Neronus/Clesh")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "012ry02djnqyvvs61wbbqj3saz621w2l9gczrywdxhi5p4ycx318"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("trivial-shell" ,sbcl-trivial-shell)
         ("named-readtables" ,sbcl-named-readtables)))
      (home-page "https://github.com/Neronus/Clesh")
      (synopsis "Embed shell code in Common Lisp")
      (description
       "This is a very short and simple program, written in Common Lisp, that
extends Common Lisp to embed shell code in a manner similar to Perl's
backtick.  It has been forked from SHELISP.")
      (license license:bsd-2))))

(define-public cl-clesh
  (sbcl-package->cl-source-package sbcl-clesh))

(define-public ecl-clesh
  (sbcl-package->ecl-package sbcl-clesh))

(define-public sbcl-trivial-download
  (let ((commit "d2472061d86b1cf3d32f388daacd4e32a13af699"))
    (package
      (name "sbcl-trivial-download")
      (version (git-version "0.3" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/eudoxia0/trivial-download/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "06f46zr3gp3wlm2kgxna24qd2gpr1v89x9fynh1x5vrw6c6hqjcv"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("drakma" ,sbcl-drakma)))
      (home-page "https://github.com/eudoxia0/trivial-download/")
      (synopsis "Download files from Common Lisp")
      (description
       "@code{trivial-download} allows you to download files from the Internet
from Common Lisp.  It provides a progress bar.")
      (license license:bsd-2))))

(define-public cl-trivial-download
  (sbcl-package->cl-source-package sbcl-trivial-download))

(define-public ecl-trivial-download
  (sbcl-package->ecl-package sbcl-trivial-download))

(define-public sbcl-gtwiwtg
  (package
    (name "sbcl-gtwiwtg")
    (version "0.1.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/cbeo/gtwiwtg/")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0lkraw0dwh4is4x5sp5rjrw6f93m0gr9849abrbi12s25ws7jbw4"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("osicat" ,sbcl-osicat)
       ("prove" ,sbcl-prove)))
    (home-page "https://github.com/cbeo/gtwiwtg/")
    (synopsis "Naive generators for Common Lisp")
    (description
     "The GTWIWTG library (Generators The Way I Want Them Generated --
technically not generators, but iterators) is meant to be small, explorable,
and understandable.")
    (license license:gpl3)))

(define-public cl-gtwiwtg
  (sbcl-package->cl-source-package sbcl-gtwiwtg))

(define-public ecl-gtwiwtg
  (sbcl-package->ecl-package sbcl-gtwiwtg))

(define-public sbcl-cl-progress-bar
  (let ((commit "9374170858663c8fe829e9fb5a29bd2cb48d95ae"))
    (package
      (name "sbcl-cl-progress-bar")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/sirherrbatka/cl-progress-bar/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1ldb4qhmx431n3lsq71ynwb9ybazbfqd55icjbhi06mj52ngndir"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("bordeaux-threads" ,sbcl-bordeaux-threads)
         ("documentation-utils-extensions" ,sbcl-documentation-utils-extensions)))
      (home-page "https://github.com/sirherrbatka/cl-progress-bar/")
      (synopsis "Progress bars in Common Lisp")
      (description
       "This library provides almost the same code as used inside Quicklisp
for drawning progress bars")
      (license license:expat))))

(define-public cl-progress-bar
  (sbcl-package->cl-source-package sbcl-cl-progress-bar))

(define-public ecl-cl-progress-bar
  (sbcl-package->ecl-package sbcl-cl-progress-bar))

(define-public sbcl-repl-utilities
  (let ((commit "e0de9c92e774f77cab1a4cd92e2ac922ac3a807e"))
    (package
      (name "sbcl-repl-utilities")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/m-n/repl-utilities/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1r5icmw3ha5y77kvzqni3a9bcd66d9pz5mjsbw04xg3jk0d15cgz"))))
      (build-system asdf-build-system/sbcl)
      (home-page "https://github.com/m-n/repl-utilities")
      (synopsis "Ease common tasks at the Common Lisp REPL")
      (description
       "@code{repl-utilities} is a set of utilities which ease life at the
REPL.  It includes three sorts of features: introspective procedures,
miscellaneous utility functions, and, pulling them together, methods to
conveniently keep these symbols and optionally additional symbols available in
whichever package you switch to.")
      (license license:bsd-2))))

(define-public cl-repl-utilities
  (sbcl-package->cl-source-package sbcl-repl-utilities))

(define-public ecl-repl-utilities
  (sbcl-package->ecl-package sbcl-repl-utilities))

(define-public sbcl-supertrace
  (let ((commit "66d22c3ff131ecd1c8048dfced1d62ed6024ecb0"))
    (package
      (name "sbcl-supertrace")
      (version (git-version "0.1.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fukamachi/supertrace")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0n369n6b7y1m49biccnnr7svymjdsk8sksrkqrn3mj21vgv7s7bg"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("cffi-grovel" ,sbcl-cffi)
         ("rove" ,sbcl-rove)
         ("cl-ppcre" ,sbcl-cl-ppcre)
         ("bordeaux-threads" ,sbcl-bordeaux-threads)))
      (inputs
       `(("cffi" ,sbcl-cffi)))
      (home-page "https://github.com/fukamachi/supertrace")
      (synopsis "Improved Common Lisp tracing for debugging and profiling")
      (description
       "Supertrace provides a superior Common Lisp @code{trace} functionality
for debugging and profiling real world applications.")
      (license license:bsd-2))))

(define-public cl-supertrace
  (sbcl-package->cl-source-package sbcl-supertrace))

(define-public ecl-supertrace
  (sbcl-package->ecl-package sbcl-supertrace))

(define-public sbcl-trivial-benchmark
  (let ((commit "42d76733dd2e873471c6f1e27d39113293f7dd5c"))
    (package
      (name "sbcl-trivial-benchmark")
      (version (git-version "2.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Shinmera/trivial-benchmark/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0fbzqbpm2ixz85555krl36kbbbjyn699vdj6k383khi3g9y629fa"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("alexandria" ,sbcl-alexandria)))
      (home-page "http://shinmera.github.io/trivial-benchmark/")
      (synopsis "Easy to use benchmarking system for Common Lisp")
      (description
       "Trivial-Benchmark runs a block of code many times and outputs some
statistical data for it.  On SBCL this includes the data from @code{time}, for
all other implementations just the @code{real-time} and @code{run-time} data.
However, you can extend the system by adding your own @code{metrics} to it, or
even by adding additional statistical @code{compute}ations. ")
      (license license:zlib))))

(define-public cl-trivial-benchmark
  (sbcl-package->cl-source-package sbcl-trivial-benchmark))

(define-public ecl-trivial-benchmark
  (sbcl-package->ecl-package sbcl-trivial-benchmark))

(define-public sbcl-glyphs
  (let ((commit "1ff5714e8c1dca327bc604dfe3e3d1f4b7755373"))
    (package
      (name "sbcl-glyphs")
      (version (git-version "0.0.0" "1" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ahungry/glyphs/")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "17kai1anbkk5dj5sbrsin2fc019cmcbglb900db60v38myj0y0wf"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("cl-ppcre" ,sbcl-cl-ppcre)
         ("parenscript" ,sbcl-parenscript)
         ("named-readtables" ,sbcl-named-readtables)))
      (home-page "https://github.com/ahungry/glyphs/")
      (synopsis "Reduce Common Lisp verbosity")
      (description
       "This library is a little experiment in reducing verbosity in Common
Lisp, inspired by BODOL (@url{https://github.com/bodil/BODOL}).")
      (license license:gpl3))))

(define-public cl-glyphs
  (sbcl-package->cl-source-package sbcl-glyphs))

(define-public ecl-glyphs
  (sbcl-package->ecl-package sbcl-glyphs))

(define-public sbcl-zs3
  (package
   (name "sbcl-zs3")
   (version "1.3.3")
   (source
    (origin
     (method git-fetch)
     (uri
      (git-reference
       (url "https://github.com/xach/zs3")
       (commit (string-append "release-" version))))
     (file-name (git-file-name "zs3" version))
     (sha256
      (base32 "186v95wgsj2hkxdw2jl9x1w4fddjclp7arp0rrd9vf5ly8h8sbf3"))))
   (build-system asdf-build-system/sbcl)
   (inputs
    `(("drakma" ,sbcl-drakma)
      ("alexandria" ,sbcl-alexandria)
      ("cxml" ,sbcl-cxml)
      ("ironclad" ,sbcl-ironclad)
      ("puri" ,sbcl-puri)
      ("cl-base64" ,sbcl-cl-base64)))
   (synopsis "Work with Amazon S3 and Amazon CloudFront from Common Lisp")
   (description "This is ZS3, a library for working with Amazon's Simple Storage
Service (S3) and CloudFront service from Common Lisp.")
   (home-page "https://github.com/xach/zs3")
   (license license:bsd-2)))

(define-public cl-zs3
  (sbcl-package->cl-source-package sbcl-zs3))

(define-public ecl-zs3
  (sbcl-package->ecl-package sbcl-zs3))

(define-public sbcl-simple-neural-network
  (package
    (name "sbcl-simple-neural-network")
    (version "3.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/glv2/simple-neural-network")
             (commit (string-append "v" version))))
       (file-name (git-file-name "simple-neural-network" version))
       (sha256
        (base32 "1jj1c90fr5clwka0jv32hv6xp1bkdlpa6x5jh19an13rhx8ll4zr"))))
    (build-system asdf-build-system/sbcl)
    (native-inputs
     `(("chipz" ,sbcl-chipz)
       ("fiveam" ,sbcl-fiveam)))
    (inputs
     `(("cl-store" ,sbcl-cl-store)
       ("lparallel" ,sbcl-lparallel)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'check 'remove-test-data
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (for-each delete-file (find-files out "\\.gz$"))))))))
    (synopsis "Simple neural network in Common Lisp")
    (description
     "@code{simple-neural-network} is a Common Lisp library for creating,
training and using basic neural networks.  The networks created by this
library are feedforward neural networks trained using backpropagation.")
    (home-page "https://github.com/glv2/simple-neural-network")
    (license license:gpl3+)))

(define-public cl-simple-neural-network
  (sbcl-package->cl-source-package sbcl-simple-neural-network))

(define-public ecl-simple-neural-network
  (sbcl-package->ecl-package sbcl-simple-neural-network))

(define-public sbcl-zstd
  (let ((commit "d144582c581aaa52bac24d6686af27fa3e781e06")
        (revision "1"))
    (package
      (name "sbcl-zstd")
      (version (git-version "1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/glv2/cl-zstd")
               (commit commit)))
         (file-name (git-file-name "cl-zstd" version))
         (sha256
          (base32 "1774jy8hzbi6nih3sq6vchk66f7g8w86dwgpbvljyfzcnkcaz6ql"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       `(("fiveam" ,sbcl-fiveam)))
      (inputs
       `(("cffi" ,sbcl-cffi)
         ("cl-octet-streams" ,sbcl-cl-octet-streams)
         ("zstd-lib" ,zstd "lib")))
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'fix-paths
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* "src/libzstd.lisp"
                 (("libzstd\\.so")
                  (string-append (assoc-ref inputs "zstd-lib")
                                 "/lib/libzstd.so")))
               #t)))))
      (synopsis "Common Lisp library for Zstandard (de)compression")
      (description
       "This Common Lisp library provides functions for Zstandard
compression/decompression using bindings to the libzstd C library.")
      (home-page "https://github.com/glv2/cl-zstd")
      (license license:gpl3+))))

(define-public cl-zstd
  (sbcl-package->cl-source-package sbcl-zstd))

(define-public ecl-zstd
  (sbcl-package->ecl-package sbcl-zstd))
