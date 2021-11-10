;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016 Matthew Jordan <matthewjordandevops@yandex.com>
;;; Copyright © 2016, 2017 Alex Griffin <a@ajgrf.com>
;;; Copyright © 2016 Christopher Baines <mail@cbaines.net>
;;; Copyright © 2017 Stefan Reichör <stefan@xsteve.at>
;;; Copyright © 2018, 2020 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Benjamin Slade <slade@jnanam.net>
;;; Copyright © 2019 Collin J. Doering <collin@rekahsoft.ca>
;;; Copyright © 2020 Michael Rohleder <mike@rohleder.de>
;;; Copyright © 2020 aecepoglu <aecepoglu@fastmail.fm>
;;; Copyright © 2020 Dion Mendel <guix@dm9.info>
;;; Copyright © 2021 Brice Waegeneire <brice@waegenei.re>
;;; Copyright © 2021 Alexandr Vityazev <avityazev@posteo.org>
;;; Copyright © 2021 Xinglu Chen <public@yoctocell.xyz>
;;; Copyright © 2021 Foo Chuan Wei <chuanwei.foo@hotmail.com>
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

(define-module (gnu packages shellutils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system go)
  #:use-module (guix build-system python)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages libunistring)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages vim))

(define-public boxes
  (package
    (name "boxes")
    (version "2.1.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ascii-boxes/boxes")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1bf5rnfiw04ffs1l17zhbg4wvq2vfn2qbz1xmd250xqj15lysw88"))))
    (build-system gnu-build-system)
    (arguments
     `(#:test-target "test"
       #:make-flags (list (string-append "GLOBALCONF="
                                         (assoc-ref %outputs "out")
                                         "/etc/boxes-config"))
       #:modules
       ((ice-9 match)
        ,@%gnu-build-system-modules)
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (for-each (match-lambda
                           ((source target)
                            (install-file source
                                          (string-append out "/" target))))
                         '(("out/boxes"    "bin/")
                           ("doc/boxes.1"  "share/man/man1/")
                           ("boxes-config" "etc/")))))))))
    (native-inputs
     `(("bison" ,bison)
       ("flex" ,flex)

       ;; For the tests.
       ("xxd" ,xxd)))
    (inputs
     `(("libunistring" ,libunistring)
       ("pcre2" ,pcre2)))
    (home-page "https://boxes.thomasjensen.com")
    (synopsis "Command line ASCII boxes")
    (description
     "This command-line filter program draws ASCII-art boxes around your input
text.")
    (license license:gpl2)))

(define-public zsh-autosuggestions
  (package
    (name "zsh-autosuggestions")
    (version "0.7.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/zsh-users/zsh-autosuggestions")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("ruby" ,ruby)
       ("ruby-byebug" ,ruby-byebug)
       ("ruby-pry" ,ruby-pry)
       ("ruby-rspec" ,ruby-rspec)
       ("ruby-rspec-wait" ,ruby-rspec-wait)
       ("tmux" ,tmux)
       ("zsh" ,zsh)))
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'patch-tests
           (lambda _
             ;; Failing tests since tmux-3.2a
             (delete-file "spec/options/buffer_max_size_spec.rb")))
         (delete 'configure)
         (replace 'check ; Tests use ruby's bundler; instead execute rspec directly.
           (lambda _
             (setenv "TMUX_TMPDIR" (getenv "TMPDIR"))
             (setenv "SHELL" (which "zsh"))
             (invoke "rspec")))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (zsh-plugins
                      (string-append out "/share/zsh/plugins/zsh-autosuggestions")))
               (invoke "make" "all")
               (install-file "zsh-autosuggestions.zsh" zsh-plugins)
               #t))))))
    (home-page "https://github.com/zsh-users/zsh-autosuggestions")
    (synopsis "Fish-like autosuggestions for zsh")
    (description
     "Fish-like fast/unobtrusive autosuggestions for zsh.  It suggests commands
as you type.")
    (license license:expat)))

(define-public zsh-syntax-highlighting
  (package
    (name "zsh-syntax-highlighting")
    (version "0.7.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/zsh-users/zsh-syntax-highlighting")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "039g3n59drk818ylcyvkciv8k9mf739cv6v4vis1h9fv9whbcmwl"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("zsh" ,zsh)))
    (arguments
     ;; FIXME: Tests fail when running test regexp
     ;; there is no pcre module in the Guix zsh package
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (add-after 'unpack 'patch-paths
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (substitute* "Makefile"
                 (("/usr/local") out)
                 (("share/\\$\\(NAME\\)") "share/zsh/plugins/$(NAME)")))))
         (add-after 'patch-paths 'make-writable
           (lambda _
             (for-each make-file-writable
                       '("docs/highlighters.md"
                         "README.md"))))
         (add-before 'build 'add-all-md
           (lambda _
             (invoke "make" "all")))
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests?
               (invoke "make" "test")
               (invoke "make" "perf")))))))
    (home-page "https://github.com/zsh-users/zsh-syntax-highlighting")
    (synopsis "Fish shell-like syntax highlighting for Zsh")
    (description
     "This package provides syntax highlighting for Zsh.  It enables
highlighting of commands whilst they are typed at a Zsh prompt into an
interactive terminal.  This helps in reviewing commands before running them,
particularly in catching syntax errors.")
    (license license:bsd-3)))

(define-public sh-z
  (package
    (name "sh-z")
    (version "1.11")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/rupa/z")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "13zbgkj6y0qhvn5jpkrqbd4jjxjr789k228iwma5hjfh1nx7ghyb"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; No tests provided
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'build)
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (man (string-append out "/share/man/man1"))
                    (bin (string-append out "/bin")))
               (install-file "z.sh" bin)
               (chmod (string-append bin "/z.sh") #o755)
               (install-file "z.1" man)
               #t))))))
    (synopsis "Jump about directories")
    (description
     "Tracks your most used directories, based on ``frecency''.  After a short
learning phase, z will take you to the most ``frecent'' directory that matches
all of the regexes given on the command line in order.")
    (home-page "https://github.com/rupa/z")
    (license license:expat)))

(define-public envstore
  (package
    (name "envstore")
    (version "2.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://finalrewind.org/projects/"
                           name "/" name "-" version ".tar.bz2"))
       (sha256
        (base32 "1x97lxad80m5blhdfanl5v2qzjwcgbij2i23701bn8mpyxsrqszi"))))
    (build-system gnu-build-system)
    (arguments
     `(#:test-target "test"
       #:make-flags (list "CC=gcc"
                          (string-append "PREFIX=" (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (home-page "https://finalrewind.org/projects/envstore/")
    (synopsis "Save and restore environment variables")
    (description "Envstore is a program for sharing environment variables
between various shells or commands.")
    (license license:wtfpl2)))

(define-public trash-cli
  (package
    (name "trash-cli")
    (version "0.17.1.14")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "trash-cli" version))
       (sha256
        (base32
         "01q0cl04ljf214z6s3g256gsxx3pqsgaf6ac1zh0vrq5bnhnr85h"))))
    (build-system python-build-system)
    (arguments
     `(#:python ,python-2
       #:tests? #f ; no tests
       #:phases
       (modify-phases %standard-phases
         (add-before 'build 'patch-path-constants
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((libc (assoc-ref inputs "libc"))
                   (coreutils (assoc-ref inputs "coreutils")))
               (substitute* "trashcli/list_mount_points.py"
                 (("\"/lib/libc.so.6\".*")
                  (string-append "\"" libc "/lib/libc.so.6\"\n"))
                 (("\"df\"")
                  (string-append "\"" coreutils "/bin/df\"")))))))))
    (inputs `(("coreutils" ,coreutils)))
    (home-page "https://github.com/andreafrancia/trash-cli")
    (synopsis "Trash can management tool")
    (description
     "trash-cli is a command line utility for interacting with the
FreeDesktop.org trash can used by GNOME, KDE, XFCE, and other common desktop
environments.  It can move files to the trash, and remove or list files that
are already there.")
    (license license:gpl2+)))

(define-public direnv
  (package
    (name "direnv")
    (version "2.28.0")
    (source
     (origin (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/direnv/direnv")
                   (commit (string-append "v" version))))
             (file-name (git-file-name name version))
             (sha256
              (base32
               "0yk53jn7wafklixclka17wyjjs2g5giigjr2bd0xzy10nrzwp7c9"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/direnv/direnv"
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'install-manpages
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (man (string-append out "/share/man/man1")))
               (mkdir-p man)
               (with-directory-excursion "src/github.com/direnv/direnv"
                 (install-file "man/direnv.1" man)
                 (install-file "man/direnv-stdlib.1" man)
                 (install-file "man/direnv.toml.1" man)))))
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests?
               (setenv "HOME" "/tmp")
               (with-directory-excursion "src/github.com/direnv/direnv"
                 ;; The following file needs to be writable so it can be
                 ;; modified by the testsuite.
                 (make-file-writable "test/scenarios/base/.envrc")
                 ;; We need to manually run test because make test
                 ;; tries to use go modules
                 (invoke "go" "test" "./...")
                 ;; Clean up from the tests, especially so that the extra
                 ;; direnv executable that's generated is removed.
                 (invoke "make" "clean")))
             #t)))))
    (native-inputs
     `(("go-github-com-burntsushi-toml" ,go-github-com-burntsushi-toml)
       ("go-github-com-direnv-go-dotenv" ,go-github-com-direnv-go-dotenv)
       ("go-github-com-mattn-go-isatty" ,go-github-com-mattn-go-isatty)
       ("go-golang-org-x-mod" ,go-golang-org-x-mod)
       ("which" ,which)))
    (home-page "https://direnv.net/")
    (synopsis "Environment switcher for the shell")
    (description
     "direnv can hook into the bash, zsh, tcsh, and fish shells to load
or unload environment variables depending on the current directory.  This
allows project-specific environment variables without using @file{~/.profile}.

Before each prompt, direnv checks for the existence of a @file{.envrc} file in
the current and parent directories.  This file is then used to alter the
environment variables of the current shell.")
    (license license:expat)))

(define-public fzy
  (package
    (name "fzy")
    (version "1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jhawthorn/fzy")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1gkzdvj73f71388jvym47075l9zw61v6l8wdv2lnc0mns6dxig0k"))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags (list "CC=gcc"
                          (string-append "PREFIX=" (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (home-page "https://github.com/jhawthorn/fzy")
    (synopsis "Fast fuzzy text selector for the terminal with an advanced
scoring algorithm")
    (description
     "Most other fuzzy matchers sort based on the length of a match.  fzy tries
to find the result the user intended.  It does this by favouring matches on
consecutive letters and starts of words.  This allows matching using acronyms
or different parts of the path.

fzy is designed to be used both as an editor plugin and on the command
line.  Rather than clearing the screen, fzy displays its interface directly
below the current cursor position, scrolling the screen if necessary.")
    (license license:expat)))

(define-public hstr
  (package
    (name "hstr")
    (version "2.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/dvorka/hstr")
                     (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1chmfdi1dwg3sarzd01nqa82g65q7wdr6hrnj96l75vikwsg986y"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'build 'adjust-ncurses-includes
           (lambda* (#:key make-flags outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (substitute* "src/include/hstr_curses.h"
                 (("ncursesw\\/curses.h") "ncurses.h"))
               (substitute* "src/include/hstr.h"
                 (("ncursesw\\/curses.h") "ncurses.h")))
             #t)))))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("ncurses" ,ncurses)
       ("readline" ,readline)))
    (synopsis "Navigate and search command history with shell history suggest box")
    (description "HSTR (HiSToRy) is a command-line utility that brings
improved Bash and Zsh command completion from the history.  It aims to make
completion easier and more efficient than with @kbd{Ctrl-R}.  It allows you to
easily view, navigate, and search your command history with suggestion boxes.
HSTR can also manage your command history (for instance you can remove
commands that are obsolete or contain a piece of sensitive information) or
bookmark your favourite commands.")
    (home-page "http://me.mindforger.com/projects/hh.html")
    (license license:asl2.0)))

(define-public shell-functools
  (package
    (name "shell-functools")
    (version "0.3.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/sharkdp/shell-functools")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0d6zzg7cxfrzwzh1wmpj7q85kz33sak6ac59ncsm6dlbin12h0hi"))))
    (build-system python-build-system)
    (home-page "https://github.com/sharkdp/shell-functools/")
    (synopsis "Functional programming tools for the shell")
    (description "This package provides higher order functions like map,
filter, foldl, sort_by and take_while as simple command-line tools. Following
the UNIX philosophy, these commands are designed to be composed via pipes. A
large collection of functions such as basename, replace, contains or is_dir
are provided as arguments to these commands.")
    (license license:expat)))

(define-public rig
  (package
    (name "rig")
    (version "1.11")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/rig/rig/"
                                  version "/rig-"
                                  version ".tar.gz"))
              (sha256
                (base32
                  "1f3snysjqqlpk2kgvm5p2icrj4lsdymccmn3igkc2f60smqckgq0"))))
    (build-system gnu-build-system)
    (arguments `(#:make-flags
                 (list (string-append "CXX=" ,(cxx-for-target))
                       (string-append "PREFIX=" %output))
                 #:phases
                 (modify-phases %standard-phases
                   (delete 'configure)
                   (add-after 'unpack 'fix-build
                     (lambda _
                       (substitute* "rig.cc"
                         (("^#include <string>")
                          "#include <cstring>"))
                       (substitute* "Makefile"
                         (("g\\+\\+")
                          "${CXX} -O2")
                         (("install -g 0 -m 755 -o 0 -s rig \\$\\(BINDIR\\)")
                          "install -m 755 -d $(DESTDIR)$(BINDIR)\n\t\
install -m 755 rig $(DESTDIR)$(BINDIR)/rig")
                         (("install -g 0 -m 644 -o 0 rig.6 \\$\\(MANDIR\\)/man6/rig.6")
                          "install -m 755 -d $(DESTDIR)$(MANDIR)/man6/\n\t\
install -m 644 rig.6 $(DESTDIR)$(MANDIR)/man6/rig.6")
                         (("install -g 0 -m 755 -o 0 -d \\$\\(DATADIR\\)")
                          "install -m 755 -d $(DESTDIR)$(DATADIR)")
                         (("install -g 0 -m 644 -o 0 data/\\*.idx \\$\\(DATADIR\\)")
                          "install -m 644 data/*.idx $(DESTDIR)$(DATADIR)")))))
                 #:tests? #f))
    (home-page "http://rig.sourceforge.net")
    (synopsis "Random identity generator")
    (description
      "RIG (Random Identity Generator) generates random, yet real-looking,
personal data.  It is useful if you need to feed a name to a Web site, BBS, or
real person, and are too lazy to think of one yourself.  Also, if the Web
site/BBS/person you are giving the information to tries to cross-check the
city, state, zip, or area code, it will check out.")
    (license license:gpl2+)))
