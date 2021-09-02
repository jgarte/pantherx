;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015, 2016, 2017, 2018, 2019, 2020, 2021 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2016 Chris Marusich <cmmarusich@gmail.com>
;;; Copyright © 2020 Jan (janneke) Nieuwenhuizen <janneke@gnu.org>
;;; Copyright © 2020, 2021 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2021 raid5atemyhomework <raid5atemyhomework@protonmail.com>
;;; Copyright © 2020 Christine Lemmer-Webber <cwebber@dustycloud.org>
;;; Copyright © 2020, 2021 Brice Waegeneire <brice@waegenei.re>
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

(define-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (guix monads)
  #:use-module (guix store)
  #:use-module (guix records)
  #:use-module (guix profiles)
  #:use-module (guix discovery)
  #:use-module (guix combinators)
  #:use-module (guix channels)
  #:use-module (guix describe)
  #:use-module (guix sets)
  #:use-module (guix ui)
  #:use-module (guix diagnostics)
  #:autoload   (guix openpgp) (openpgp-format-fingerprint)
  #:use-module (guix modules)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages hurd)
  #:use-module (gnu system setuid)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-9 gnu)
  #:use-module (srfi srfi-26)
  #:use-module (srfi srfi-34)
  #:use-module (srfi srfi-35)
  #:use-module (ice-9 vlist)
  #:use-module (ice-9 match)
  #:autoload   (ice-9 pretty-print) (pretty-print)
  #:export (service-extension
            service-extension?
            service-extension-target
            service-extension-compute

            service-type
            service-type?
            service-type-name
            service-type-extensions
            service-type-compose
            service-type-extend
            service-type-default-value
            service-type-description
            service-type-location

            %service-type-path
            fold-service-types
            lookup-service-types

            service
            service?
            service-kind
            service-value
            service-parameters                    ;deprecated

            simple-service
            modify-services
            service-back-edges
            instantiate-missing-services
            fold-services

            service-error?
            missing-value-service-error?
            missing-value-service-error-type
            missing-value-service-error-location
            missing-target-service-error?
            missing-target-service-error-service
            missing-target-service-error-target-type
            ambiguous-target-service-error?
            ambiguous-target-service-error-service
            ambiguous-target-service-error-target-type

            system-service-type
            provenance-service-type
            sexp->system-provenance
            system-provenance
            boot-service-type
            cleanup-service-type
            activation-service-type
            activation-service->script
            %linux-bare-metal-service
            %hurd-rc-script
            %hurd-startup-service
            special-files-service-type
            extra-special-file
            etc-service-type
            etc-directory
            setuid-program-service-type
            profile-service-type
            firmware-service-type
            gc-root-service-type
            linux-builder-service-type
            linux-builder-configuration
            linux-builder-configuration?
            linux-builder-configuration-kernel
            linux-builder-configuration-modules
            linux-loadable-module-service-type

            %boot-service
            %activation-service
            etc-service)
  #:re-export (;; Note: Re-export 'delete' to allow for proper syntax matching
               ;; in 'modify-services' forms.  See
               ;; <https://debbugs.gnu.org/cgi/bugreport.cgi?bug=26805#16>.
               delete))

;;; Comment:
;;;
;;; This module defines a broad notion of "service types" and "services."
;;;
;;; A service type describe how its instances extend instances of other
;;; service types.  For instance, some services extend the instance of
;;; ACCOUNT-SERVICE-TYPE by providing it with accounts and groups to create;
;;; others extend SHEPHERD-ROOT-SERVICE-TYPE by passing it instances of
;;; <shepherd-service>.
;;;
;;; When applicable, the service type defines how it can itself be extended,
;;; by providing one procedure to compose extensions, and one procedure to
;;; extend itself.
;;;
;;; A notable service type is SYSTEM-SERVICE-TYPE, which has a single
;;; instance, which is the root of the service DAG.  Its value is the
;;; derivation that produces the 'system' directory as returned by
;;; 'operating-system-derivation'.
;;;
;;; The 'fold-services' procedure can be passed a list of procedures, which it
;;; "folds" by propagating extensions down the graph; it returns the root
;;; service after the applying all its extensions.
;;;
;;; Code:

(define-record-type <service-extension>
  (service-extension target compute)
  service-extension?
  (target  service-extension-target)              ;<service-type>
  (compute service-extension-compute))            ;params -> params

(define &no-default-value
  ;; Value used to denote service types that have no associated default value.
  '(no default value))

(define-record-type* <service-type> service-type make-service-type
  service-type?
  (name       service-type-name)                  ;symbol (for debugging)

  ;; Things extended by services of this type.
  (extensions service-type-extensions)            ;list of <service-extensions>

  ;; Given a list of extensions, "compose" them.
  (compose    service-type-compose                ;list of Any -> Any
              (default #f))

  ;; Extend the services' own parameters with the extension composition.
  (extend     service-type-extend                 ;list of Any -> parameters
              (default #f))

  ;; Optional default value for instances of this type.
  (default-value service-type-default-value       ;Any
                 (default &no-default-value))

  ;; Meta-data.
  (description  service-type-description          ;string
                (default #f))
  (location     service-type-location             ;<location>
                (default (and=> (current-source-location)
                                source-properties->location))
                (innate)))

(define (write-service-type type port)
  (format port "#<service-type ~a ~a>"
          (service-type-name type)
          (number->string (object-address type) 16)))

(set-record-type-printer! <service-type> write-service-type)

(define %distro-root-directory
  ;; Absolute file name of the module hierarchy.
  (dirname (search-path %load-path "guix.scm")))

(define %service-type-path
  ;; Search path for service types.
  (make-parameter `((,%distro-root-directory . "gnu/services")
                    (,%distro-root-directory . "gnu/system"))))

(define (all-service-modules)
  "Return the default set of service modules."
  (cons (resolve-interface '(gnu services))
        (all-modules (%service-type-path)
                     #:warn warn-about-load-error)))

(define* (fold-service-types proc seed
                             #:optional
                             (modules (all-service-modules)))
  "For each service type exported by one of MODULES, call (PROC RESULT).  SEED
is used as the initial value of RESULT."
  (fold-module-public-variables (lambda (object result)
                                  (if (service-type? object)
                                      (proc object result)
                                      result))
                                seed
                                modules))

(define lookup-service-types
  (let ((table
         (delay (fold-service-types (lambda (type result)
                                      (vhash-consq (service-type-name type)
                                                   type result))
                                    vlist-null))))
    (lambda (name)
      "Return the list of services with the given NAME (a symbol)."
      (vhash-foldq* cons '() name (force table)))))

;; Services of a given type.
(define-record-type <service>
  (make-service type value)
  service?
  (type       service-kind)
  (value      service-value))

(define-syntax service
  (syntax-rules ()
    "Return a service instance of TYPE.  The service value is VALUE or, if
omitted, TYPE's default value."
    ((_ type value)
     (make-service type value))
    ((_ type)
     (%service-with-default-value (current-source-location)
                                  type))))

(define (%service-with-default-value location type)
  "Return a instance of service type TYPE with its default value, if any.  If
TYPE does not have a default value, an error is raised."
  ;; TODO: Currently this is a run-time error but with a little bit macrology
  ;; we could turn it into an expansion-time error.
  (let ((default (service-type-default-value type)))
    (if (eq? default &no-default-value)
        (let ((location (source-properties->location location)))
          (raise
           (make-compound-condition
            (condition
             (&missing-value-service-error (type type) (location location)))
            (formatted-message (G_ "~a: no value specified \
for service of type '~a'")
                               (location->string location)
                               (service-type-name type)))))
        (service type default))))

(define-condition-type &service-error &error
  service-error?)

(define-condition-type &missing-value-service-error &service-error
  missing-value-service-error?
  (type     missing-value-service-error-type)
  (location missing-value-service-error-location))



;;;
;;; Helpers.
;;;

(define service-parameters
  ;; Deprecated alias.
  service-value)

(define (simple-service name target value)
  "Return a service that extends TARGET with VALUE.  This works by creating a
singleton service type NAME, of which the returned service is an instance."
  (let* ((extension (service-extension target identity))
         (type      (service-type (name name)
                                  (extensions (list extension)))))
    (service type value)))

(define-syntax %modify-service
  (syntax-rules (=> delete)
    ((_ svc (delete kind) clauses ...)
     (if (eq? (service-kind svc) kind)
         #f
         (%modify-service svc clauses ...)))
    ((_ service)
     service)
    ((_ svc (kind param => exp ...) clauses ...)
     (if (eq? (service-kind svc) kind)
         (let ((param (service-value svc)))
           (service (service-kind svc)
                    (begin exp ...)))
         (%modify-service svc clauses ...)))))

(define-syntax modify-services
  (syntax-rules ()
    "Modify the services listed in SERVICES according to CLAUSES and return
the resulting list of services.  Each clause must have the form:

  (TYPE VARIABLE => BODY)

where TYPE is a service type, such as 'guix-service-type', and VARIABLE is an
identifier that is bound within BODY to the value of the service of that
TYPE.  Consider this example:

  (modify-services %base-services
    (guix-service-type config =>
                       (guix-configuration
                        (inherit config)
                        (use-substitutes? #f)
                        (extra-options '(\"--gc-keep-derivations\"))))
    (mingetty-service-type config =>
                           (mingetty-configuration
                            (inherit config)
                            (motd (plain-file \"motd\" \"Hi there!\"))))
    (delete udev-service-type))

It changes the configuration of the GUIX-SERVICE-TYPE instance, and that of
all the MINGETTY-SERVICE-TYPE instances, and it deletes instances of the
UDEV-SERVICE-TYPE.

This is a shorthand for (filter-map (lambda (svc) ...) %base-services)."
    ((_ services clauses ...)
     (filter-map (lambda (service)
                   (%modify-service service clauses ...))
                 services))))


;;;
;;; Core services.
;;;

(define (system-derivation entries mextensions)
  "Return as a monadic value the derivation of the 'system' directory
containing the given entries."
  (mlet %store-monad ((extensions (mapm/accumulate-builds identity
                                                          mextensions)))
    (lower-object
     (file-union "system"
                 (append entries (concatenate extensions))))))

(define system-service-type
  ;; This is the ultimate service type, the root of the service DAG.  The
  ;; service of this type is extended by monadic name/item pairs.  These items
  ;; end up in the "system directory" as returned by
  ;; 'operating-system-derivation'.
  (service-type (name 'system)
                (extensions '())
                (compose identity)
                (extend system-derivation)
                (description
                 "Build the operating system top-level directory, which in
turn refers to everything the operating system needs: its kernel, initrd,
system profile, boot script, and so on.")))

(define (compute-boot-script _ gexps)
  ;; Reverse GEXPS so that extensions appear in the boot script in the right
  ;; order.  That is, user extensions would come first, and extensions added
  ;; by 'essential-services' (e.g., running shepherd) are guaranteed to come
  ;; last.
  (gexp->file "boot"
              ;; Clean up and activate the system, then spawn shepherd.
              #~(begin #$@(reverse gexps))))

(define (boot-script-entry mboot)
  "Return, as a monadic value, an entry for the boot script in the system
directory."
  (mlet %store-monad ((boot mboot))
    (return `(("boot" ,boot)))))

(define boot-service-type
  ;; The service of this type is extended by being passed gexps.  It
  ;; aggregates them in a single script, as a monadic value, which becomes its
  ;; value.
  (service-type (name 'boot)
                (extensions
                 (list (service-extension system-service-type
                                          boot-script-entry)))
                (compose identity)
                (extend compute-boot-script)
                (description
                 "Produce the operating system's boot script, which is spawned
by the initrd once the root file system is mounted.")))

(define %boot-service
  ;; The service that produces the boot script.
  (service boot-service-type #t))


;;;
;;; Provenance tracking.
;;;

(define (object->pretty-string obj)
  "Like 'object->string', but using 'pretty-print'."
  (call-with-output-string
    (lambda (port)
      (pretty-print obj port))))

(define (channel->code channel)
  "Return code to build CHANNEL, ready to be dropped in a 'channels.scm'
file."
  ;; Since the 'introduction' field is backward-incompatible, and since it's
  ;; optional when using the "official" 'guix channel, include it if and only
  ;; if we're referring to a different channel.
  (let ((intro (and (not (equal? (list channel) %default-channels))
                    (channel-introduction channel))))
    `(channel (name ',(channel-name channel))
              (url ,(channel-url channel))
              (branch ,(channel-branch channel))
              (commit ,(channel-commit channel))
              ,@(if intro
                    `((introduction
                       (make-channel-introduction
                        ,(channel-introduction-first-signed-commit intro)
                        (openpgp-fingerprint
                         ,(openpgp-format-fingerprint
                           (channel-introduction-first-commit-signer
                            intro))))))
                    '()))))

(define (channel->sexp channel)
  "Return an sexp describing CHANNEL.  The sexp is _not_ code and is meant to
be parsed by tools; it's potentially more future-proof than code."
  ;; TODO: Add CHANNEL's introduction.  Currently we can't do that because
  ;; older 'guix system describe' expect exactly name/url/branch/commit
  ;; without any additional fields.
  `(channel (name ,(channel-name channel))
            (url ,(channel-url channel))
            (branch ,(channel-branch channel))
            (commit ,(channel-commit channel))))

(define (sexp->channel sexp)
  "Return the channel corresponding to SEXP, an sexp as found in the
\"provenance\" file produced by 'provenance-service-type'."
  (match sexp
    (('channel ('name name)
               ('url url)
               ('branch branch)
               ('commit commit)
               rest ...)
     ;; XXX: In the future REST may include a channel introduction.
     (channel (name name) (url url)
              (branch branch) (commit commit)))))

(define (provenance-file channels config-file)
  "Return a 'provenance' file describing CHANNELS, a list of channels, and
CONFIG-FILE, which can be either #f or a <local-file> containing the OS
configuration being used."
  (scheme-file "provenance"
               #~(provenance
                  (version 0)
                  (channels #+@(if channels
                                   (map channel->sexp channels)
                                   '()))
                  (configuration-file #+config-file))))

(define (provenance-entry config-file)
  "Return system entries describing the operating system provenance: the
channels in use and CONFIG-FILE, if it is true."
  (define profile
    (current-profile))

  (define channels
    (and=> profile profile-channels))

  (mbegin %store-monad
    (let ((config-file (cond ((string? config-file)
                              ;; CONFIG-FILE has been passed typically via
                              ;; 'guix system reconfigure CONFIG-FILE' so we
                              ;; can assume it's valid: tell 'local-file' to
                              ;; not emit a warning.
                              (local-file (assume-valid-file-name config-file)
                                          "configuration.scm"))
                             ((not config-file)
                              #f)
                             (else
                              config-file))))
      (return `(("provenance" ,(provenance-file channels config-file))
                ,@(if channels
                      `(("channels.scm"
                         ,(plain-file "channels.scm"
                                      (object->pretty-string
                                       `(list
                                         ,@(map channel->code channels))))))
                      '())
                ,@(if config-file
                      `(("configuration.scm" ,config-file))
                      '()))))))

(define provenance-service-type
  (service-type (name 'provenance)
                (extensions
                 (list (service-extension system-service-type
                                          provenance-entry)))
                (default-value #f)                ;the OS config file
                (description
                 "Store provenance information about the system in the system
itself: the channels used when building the system, and its configuration
file, when available.")))

(define (sexp->system-provenance sexp)
  "Parse SEXP, an s-expression read from /run/current-system/provenance or
similar, and return two values: the list of channels listed therein, and the
OS configuration file or #f."
  (match sexp
    (('provenance ('version 0)
                  ('channels channels ...)
                  ('configuration-file config-file))
     (values (map sexp->channel channels)
             config-file))
    (_
     (values '() #f))))

(define (system-provenance system)
  "Given SYSTEM, the file name of a system generation, return two values: the
list of channels SYSTEM is built from, and its configuration file.  If that
information is missing, return the empty list (for channels) and possibly
#false (for the configuration file)."
  (catch 'system-error
    (lambda ()
      (sexp->system-provenance
       (call-with-input-file (string-append system "/provenance")
         read)))
    (lambda _
      (values '() #f))))

;;;
;;; Cleanup.
;;;

(define (cleanup-gexp _)
  "Return a gexp to clean up /tmp and similar places upon boot."
  (with-imported-modules '((guix build utils))
    #~(begin
        (use-modules (guix build utils))

        ;; Clean out /tmp and /var/run.
        ;;
        ;; XXX This needs to happen before service activations, so it
        ;; has to be here, but this also implicitly assumes that /tmp
        ;; and /var/run are on the root partition.
        (letrec-syntax ((fail-safe (syntax-rules ()
                                     ((_ exp rest ...)
                                      (begin
                                        (catch 'system-error
                                          (lambda () exp)
                                          (const #f))
                                        (fail-safe rest ...)))
                                     ((_)
                                      #t))))
          ;; Ignore I/O errors so the system can boot.
          (fail-safe
           ;; Remove stale Shadow lock files as they would lead to
           ;; failures of 'useradd' & co.
           (delete-file "/etc/group.lock")
           (delete-file "/etc/passwd.lock")
           (delete-file "/etc/.pwd.lock")         ;from 'lckpwdf'

           ;; Force file names to be decoded as UTF-8.  See
           ;; <https://bugs.gnu.org/26353>.
           (setenv "GUIX_LOCPATH"
                   #+(file-append glibc-utf8-locales "/lib/locale"))
           (setlocale LC_CTYPE "en_US.utf8")
           (delete-file-recursively "/tmp")
           (delete-file-recursively "/var/run")

           (mkdir "/tmp")
           (chmod "/tmp" #o1777)
           (mkdir "/var/run")
           (chmod "/var/run" #o755)
           (delete-file-recursively "/run/udev/watch.old"))))))

(define cleanup-service-type
  ;; Service that cleans things up in /tmp and similar.
  (service-type (name 'cleanup)
                (extensions
                 (list (service-extension boot-service-type
                                          cleanup-gexp)))
                (description
                 "Delete files from @file{/tmp}, @file{/var/run}, and other
temporary locations at boot time.")))

(define* (activation-service->script service)
  "Return as a monadic value the activation script for SERVICE, a service of
ACTIVATION-SCRIPT-TYPE."
  (activation-script (service-value service)))

(define (activation-script gexps)
  "Return the system's activation script, which evaluates GEXPS."
  (define actions
    (map (cut program-file "activate-service.scm" <>) gexps))

  (program-file "activate.scm"
                (with-imported-modules (source-module-closure
                                        '((gnu build activation)
                                          (guix build utils)))
                  #~(begin
                      (use-modules (gnu build activation)
                                   (guix build utils))

                      ;; Make sure the user accounting database exists.  If it
                      ;; does not exist, 'setutxent' does not create it and
                      ;; thus there is no accounting at all.
                      (close-port (open-file "/var/run/utmpx" "a0"))

                      ;; Same for 'wtmp', which is populated by mingetty et
                      ;; al.
                      (mkdir-p "/var/log")
                      (close-port (open-file "/var/log/wtmp" "a0"))

                      ;; Set up /run/current-system.  Among other things this
                      ;; sets up locales, which the activation snippets
                      ;; executed below may expect.
                      (activate-current-system)

                      ;; Run the services' activation snippets.
                      ;; TODO: Use 'load-compiled'.
                      (for-each primitive-load '#$actions)))))

(define (gexps->activation-gexp gexps)
  "Return a gexp that runs the activation script containing GEXPS."
  #~(primitive-load #$(activation-script gexps)))

(define (activation-profile-entry gexps)
  "Return, as a monadic value, an entry for the activation script in the
system directory."
  (mlet %store-monad ((activate (lower-object (activation-script gexps))))
    (return `(("activate" ,activate)))))

(define (second-argument a b) b)

(define activation-service-type
  (service-type (name 'activate)
                (extensions
                 (list (service-extension boot-service-type
                                          gexps->activation-gexp)
                       (service-extension system-service-type
                                          activation-profile-entry)))
                (compose identity)
                (extend second-argument)
                (description
                 "Run @dfn{activation} code at boot time and upon
@command{guix system reconfigure} completion.")))

(define %activation-service
  ;; The activation service produces the activation script from the gexps it
  ;; receives.
  (service activation-service-type #t))

(define %modprobe-wrapper
  ;; Wrapper for the 'modprobe' command that knows where modules live.
  ;;
  ;; This wrapper is typically invoked by the Linux kernel ('call_modprobe',
  ;; in kernel/kmod.c), a situation where the 'LINUX_MODULE_DIRECTORY'
  ;; environment variable is not set---hence the need for this wrapper.
  (let ((modprobe "/run/current-system/profile/bin/modprobe"))
    (program-file "modprobe"
                  #~(begin
                      (setenv "LINUX_MODULE_DIRECTORY"
                              "/run/booted-system/kernel/lib/modules")
                      ;; FIXME: Remove this crutch when the patch #40422,
                      ;; updating to kmod 27 is merged.
                      (setenv "MODPROBE_OPTIONS"
                              "-C /etc/modprobe.d")
                      (apply execl #$modprobe
                             (cons #$modprobe (cdr (command-line))))))))

(define %linux-kernel-activation
  ;; Activation of the Linux kernel running on the bare metal (as opposed to
  ;; running in a container.)
  #~(begin
      ;; Tell the kernel to use our 'modprobe' command.
      (activate-modprobe #$%modprobe-wrapper)

      ;; Let users debug their own processes!
      (activate-ptrace-attach)))

(define %linux-bare-metal-service
  ;; The service that does things that are needed on the "bare metal", but not
  ;; necessary or impossible in a container.
  (simple-service 'linux-bare-metal
                  activation-service-type
                  %linux-kernel-activation))

(define %hurd-rc-script
  ;; The RC script to be started upon boot.
  (program-file "rc"
                (with-imported-modules (source-module-closure
                                        '((guix build utils)
                                          (gnu build hurd-boot)
                                          (guix build syscalls)))
                  #~(begin
                      (use-modules (guix build utils)
                                   (gnu build hurd-boot)
                                   (guix build syscalls)
                                   (ice-9 match)
                                   (system repl repl)
                                   (srfi srfi-1)
                                   (srfi srfi-26))
                      (boot-hurd-system)))))

(define (hurd-rc-entry rc)
  "Return, as a monadic value, an entry for the RC script in the system
directory."
  (mlet %store-monad ((rc (lower-object rc)))
    (return `(("rc" ,rc)))))

(define hurd-startup-service-type
  ;; The service that creates the initial SYSTEM/rc startup file.
  (service-type (name 'startup)
                (extensions
                 (list (service-extension system-service-type hurd-rc-entry)))
                (default-value %hurd-rc-script)))

(define %hurd-startup-service
  ;; The service that produces the RC script.
  (service hurd-startup-service-type %hurd-rc-script))

(define special-files-service-type
  ;; Service to install "special files" such as /bin/sh and /usr/bin/env.
  (service-type
   (name 'special-files)
   (extensions
    (list (service-extension activation-service-type
                             (lambda (files)
                               #~(activate-special-files '#$files)))))
   (compose concatenate)
   (extend append)
   (description
    "Add special files to the root file system---e.g.,
@file{/usr/bin/env}.")))

(define (extra-special-file file target)
  "Use TARGET as the \"special file\" FILE.  For example, TARGET might be
  (file-append coreutils \"/bin/env\")
and FILE could be \"/usr/bin/env\"."
  (simple-service (string->symbol (string-append "special-file-" file))
                  special-files-service-type
                  `((,file ,target))))

(define (etc-directory service)
  "Return the directory for SERVICE, a service of type ETC-SERVICE-TYPE."
  (files->etc-directory (service-value service)))

(define (files->etc-directory files)
  (define (assert-no-duplicates files)
    (let loop ((files files)
               (seen (set)))
      (match files
        (() #t)
        (((file _) rest ...)
         (when (set-contains? seen file)
           (raise (formatted-message (G_ "duplicate '~a' entry for /etc")
                                     file)))
         (loop rest (set-insert file seen))))))

  ;; Detect duplicates early instead of letting them through, eventually
  ;; leading to a build failure of "etc.drv".
  (assert-no-duplicates files)

  (file-union "etc" files))

(define (etc-entry files)
  "Return an entry for the /etc directory consisting of FILES in the system
directory."
  (with-monad %store-monad
    (return `(("etc" ,(files->etc-directory files))))))

(define etc-service-type
  (service-type (name 'etc)
                (extensions
                 (list
                  (service-extension activation-service-type
                                     (lambda (files)
                                       (let ((etc
                                              (files->etc-directory files)))
                                         #~(activate-etc #$etc))))
                  (service-extension system-service-type etc-entry)))
                (compose concatenate)
                (extend append)
                (description "Populate the @file{/etc} directory.")))

(define (etc-service files)
  "Return a new service of ETC-SERVICE-TYPE that populates /etc with FILES.
FILES must be a list of name/file-like object pairs."
  (service etc-service-type files))

(define (setuid-program->activation-gexp programs)
  "Return an activation gexp for setuid-program from PROGRAMS."
  (let ((programs (map (lambda (program)
                         ;; FIXME This is really ugly, I didn't managed to use
                         ;; "inherit"
                         (let ((program-name (setuid-program-program program))
                               (setuid?      (setuid-program-setuid? program))
                               (setgid?      (setuid-program-setgid? program))
                               (user         (setuid-program-user program))
                               (group        (setuid-program-group program)) )
                           #~(setuid-program
                              (setuid? #$setuid?)
                              (setgid? #$setgid?)
                              (user    #$user)
                              (group   #$group)
                              (program #$program-name))))
                       programs)))
    (with-imported-modules (source-module-closure
                            '((gnu system setuid)))
      #~(begin
          (use-modules (gnu system setuid))

          (activate-setuid-programs (list #$@programs))))))

(define setuid-program-service-type
  (service-type (name 'setuid-program)
                (extensions
                 (list (service-extension activation-service-type
                                          setuid-program->activation-gexp)))
                (compose concatenate)
                (extend (lambda (config extensions)
                          (append config extensions)))
                (description
                 "Populate @file{/run/setuid-programs} with the specified
executables, making them setuid-root.")))

(define (packages->profile-entry packages)
  "Return a system entry for the profile containing PACKAGES."
  ;; XXX: 'mlet' is needed here for one reason: to get the proper
  ;; '%current-target' and '%current-target-system' bindings when
  ;; 'packages->manifest' is called, and thus when the 'package-inputs'
  ;; etc. procedures are called on PACKAGES.  That way, conditionals in those
  ;; inputs see the "correct" value of these two parameters.  See
  ;; <https://issues.guix.gnu.org/44952>.
  (mlet %store-monad ((_ (current-target-system)))
    (return `(("profile" ,(profile
                           (content (packages->manifest
                                     (delete-duplicates packages eq?)))))))))

(define profile-service-type
  ;; The service that populates the system's profile---i.e.,
  ;; /run/current-system/profile.  It is extended by package lists.
  (service-type (name 'profile)
                (extensions
                 (list (service-extension system-service-type
                                          packages->profile-entry)))
                (compose concatenate)
                (extend append)
                (description
                 "This is the @dfn{system profile}, available as
@file{/run/current-system/profile}.  It contains packages that the sysadmin
wants to be globally available to all the system users.")))

(define (firmware->activation-gexp firmware)
  "Return a gexp to make the packages listed in FIRMWARE loadable by the
kernel."
  (let ((directory (directory-union "firmware" firmware)))
    ;; Tell the kernel where firmware is.
    #~(activate-firmware (string-append #$directory "/lib/firmware"))))

(define firmware-service-type
  ;; The service that collects firmware.
  (service-type (name 'firmware)
                (extensions
                 (list (service-extension activation-service-type
                                          firmware->activation-gexp)))
                (compose concatenate)
                (extend append)
                (description
                 "Make ``firmware'' files loadable by the operating system
kernel.  Firmware may then be uploaded to some of the machine's devices, such
as Wifi cards.")))

(define (gc-roots->system-entry roots)
  "Return an entry in the system's output containing symlinks to ROOTS."
  (mlet %store-monad ((entry (gexp->derivation
                              "gc-roots"
                              #~(let ((roots '#$roots))
                                  (mkdir #$output)
                                  (chdir #$output)
                                  (for-each symlink
                                            roots
                                            (map number->string
                                                 (iota (length roots))))))))
    (return (if (null? roots)
                '()
                `(("gc-roots" ,entry))))))

(define gc-root-service-type
  ;; A service to associate extra garbage-collector roots to the system.  This
  ;; is a simple hack that guarantees that the system retains references to
  ;; the given list of roots.  Roots must be "lowerable" objects like
  ;; packages, or derivations.
  (service-type (name 'gc-roots)
                (extensions
                 (list (service-extension system-service-type
                                          gc-roots->system-entry)))
                (compose concatenate)
                (extend append)
                (description
                 "Register garbage-collector roots---i.e., store items that
will not be reclaimed by the garbage collector.")
                (default-value '())))

;; Configuration for the Linux kernel builder.
(define-record-type* <linux-builder-configuration>
  linux-builder-configuration
  make-linux-builder-configuration
  linux-builder-configuration?
  this-linux-builder-configuration

  (kernel   linux-builder-configuration-kernel)                   ; package
  (modules  linux-builder-configuration-modules  (default '())))  ; list of packages

(define (package-for-kernel target-kernel module-package)
  "Return a package like MODULE-PACKAGE, adapted for TARGET-KERNEL, if
possible (that is if there's a LINUX keyword argument in the build system)."
  (package
    (inherit module-package)
    (arguments
     (substitute-keyword-arguments (package-arguments module-package)
       ((#:linux kernel #f)
        target-kernel)))))

(define (linux-builder-configuration->system-entry config)
  "Return the kernel entry of the 'system' directory."
  (let* ((kernel  (linux-builder-configuration-kernel config))
         (modules (linux-builder-configuration-modules config))
         (kernel  (profile
                    (content (packages->manifest
                              (cons kernel
                                    (map (lambda (module)
                                           (cond
                                             ((package? module)
                                              (package-for-kernel kernel module))
                                             ;; support (,package "kernel-module-output")
                                             ((and (list? module) (package? (car module)))
                                              (cons (package-for-kernel kernel
                                                                        (car module))
                                                    (cdr module)))
                                             (else
                                              module)))
                                         modules))))
                    (hooks (list linux-module-database)))))
    (with-monad %store-monad
      (return `(("kernel" ,kernel))))))

(define linux-builder-service-type
  (service-type (name 'linux-builder)
                (extensions
                  (list (service-extension system-service-type
                                           linux-builder-configuration->system-entry)))
                (default-value '())
                (compose identity)
                (extend (lambda (config modifiers)
                          (if (null? modifiers)
                              config
                              ((apply compose modifiers) config))))
                (description "Builds the linux-libre kernel profile, containing
the kernel itself and any linux-loadable kernel modules.  This can be extended
with a function that accepts the current configuration and returns a new
configuration.")))

(define (linux-loadable-module-builder-modifier modules)
  "Extends linux-builder-service-type by appending the given MODULES to the
configuration of linux-builder-service-type."
  (lambda (config)
    (linux-builder-configuration
      (inherit config)
      (modules (append (linux-builder-configuration-modules config)
                       modules)))))

(define linux-loadable-module-service-type
  (service-type (name 'linux-loadable-modules)
                (extensions
                  (list (service-extension linux-builder-service-type
                                           linux-loadable-module-builder-modifier)))
                (default-value '())
                (compose concatenate)
                (extend append)
                (description "Adds packages and package outputs as modules
included in the booted linux-libre profile.  Other services can extend this
service type to add particular modules to the set of linux-loadable modules.")))



;;;
;;; Service folding.
;;;

(define-condition-type &missing-target-service-error &service-error
  missing-target-service-error?
  (service      missing-target-service-error-service)
  (target-type  missing-target-service-error-target-type))

(define-condition-type &ambiguous-target-service-error &service-error
  ambiguous-target-service-error?
  (service      ambiguous-target-service-error-service)
  (target-type  ambiguous-target-service-error-target-type))

(define (missing-target-error service target-type)
  (raise
   (condition (&missing-target-service-error
               (service service)
               (target-type target-type))
              (&message
               (message
                (format #f (G_ "no target of type '~a' for service '~a'")
                        (service-type-name target-type)
                        (service-type-name
                         (service-kind service))))))))

(define (service-back-edges services)
  "Return a procedure that, when passed a <service>, returns the list of
<service> objects that depend on it."
  (define (add-edges service edges)
    (define (add-edge extension edges)
      (let ((target-type (service-extension-target extension)))
        (match (filter (lambda (service)
                         (eq? (service-kind service) target-type))
                       services)
          ((target)
           (vhash-consq target service edges))
          (()
           (missing-target-error service target-type))
          (x
           (raise
            (condition (&ambiguous-target-service-error
                        (service service)
                        (target-type target-type))
                       (&message
                        (message
                         (format #f
                                 (G_ "more than one target service of type '~a'")
                                 (service-type-name target-type))))))))))

    (fold add-edge edges (service-type-extensions (service-kind service))))

  (let ((edges (fold add-edges vlist-null services)))
    (lambda (node)
      (reverse (vhash-foldq* cons '() node edges)))))

(define (instantiate-missing-services services)
  "Return SERVICES, a list, augmented with any services targeted by extensions
and missing from SERVICES.  Only service types with a default value can be
instantiated; other missing services lead to a
'&missing-target-service-error'."
  (define (adjust-service-list svc result instances)
    (fold2 (lambda (extension result instances)
             (define target-type
               (service-extension-target extension))

             (match (vhash-assq target-type instances)
               (#f
                (let ((default (service-type-default-value target-type)))
                  (if (eq? &no-default-value default)
                      (missing-target-error svc target-type)
                      (let ((new (service target-type)))
                        (values (cons new result)
                                (vhash-consq target-type new instances))))))
               (_
                (values result instances))))
           result
           instances
           (service-type-extensions (service-kind svc))))

  (let loop ((services services))
    (define instances
      (fold (lambda (service result)
              (vhash-consq (service-kind service) service
                           result))
            vlist-null services))

    (define adjusted
      (fold2 adjust-service-list
             services instances
             services))

    ;; If we instantiated services, they might in turn depend on missing
    ;; services.  Loop until we've reached fixed point.
    (if (= (length adjusted) (vlist-length instances))
        adjusted
        (loop adjusted))))

(define* (fold-services services
                        #:key (target-type system-service-type))
  "Fold SERVICES by propagating their extensions down to the root of type
TARGET-TYPE; return the root service adjusted accordingly."
  (define dependents
    (service-back-edges services))

  (define (matching-extension target)
    (let ((target (service-kind target)))
      (match-lambda
        (($ <service-extension> type)
         (eq? type target)))))

  (define (apply-extension target)
    (lambda (service)
      (match (find (matching-extension target)
                   (service-type-extensions (service-kind service)))
        (($ <service-extension> _ compute)
         (compute (service-value service))))))

  (match (filter (lambda (service)
                   (eq? (service-kind service) target-type))
                 services)
    ((sink)
     ;; Use the state monad to keep track of already-visited services in the
     ;; graph and to memoize their value once folded.
     (run-with-state
         (let loop ((sink sink))
           (mlet %state-monad ((visited (current-state)))
             (match (vhash-assq sink visited)
               (#f
                (mlet* %state-monad
                    ((dependents (mapm %state-monad loop (dependents sink)))
                     (visited    (current-state))
                     (extensions -> (map (apply-extension sink) dependents))
                     (extend     -> (service-type-extend (service-kind sink)))
                     (compose    -> (service-type-compose (service-kind sink)))
                     (params     -> (service-value sink))
                     (service
                      ->
                      ;; Distinguish COMPOSE and EXTEND because PARAMS typically
                      ;; has a different type than the elements of EXTENSIONS.
                      (if extend
                          (service (service-kind sink)
                                   (extend params (compose extensions)))
                          sink)))
                  (mbegin %state-monad
                    (set-current-state (vhash-consq sink service visited))
                    (return service))))
               ((_ . service)                     ;SINK was already visited
                (return service)))))
       vlist-null))
    (()
     (raise
      (make-compound-condition
       (condition (&missing-target-service-error
                   (service #f)
                   (target-type target-type)))
       (formatted-message (G_ "service of type '~a' not found")
                          (service-type-name target-type)))))
    (x
     (raise
      (condition (&ambiguous-target-service-error
                  (service #f)
                  (target-type target-type))
                 (&message
                  (message
                   (format #f
                           (G_ "more than one target service of type '~a'")
                           (service-type-name target-type)))))))))

;;; services.scm ends here.
