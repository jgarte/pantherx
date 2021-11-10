;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2020 Alex ter Weele <alex.ter.weele@gmail.com>
;;; Copyright © 2020 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2020, 2021 Michael Rohleder <mike@rohleder.de>
;;; Copyright © 2020 Giacomo Leidi <goodoldpaul@autistici.org>
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

(define-module (gnu packages matrix)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages check)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages monitoring)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages xml)
  #:use-module (guix build-system python)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages))

(define-public python-matrix-client
  (package
    (name "python-matrix-client")
    (version "0.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "matrix-client" version))
       (sha256
        (base32
         "1mgjd0ymf9mvqjkvgx3xjhxap7rzdmpa21wfy0cxbw2xcswcrqyw"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-requests" ,python-requests)))
    (native-inputs
     `(("python-pytest" ,python-pytest)
       ("python-pytest-runner" ,python-pytest-runner)
       ("python-responses" ,python-responses)))
    (home-page
     "https://github.com/matrix-org/matrix-python-sdk")
    (synopsis "Client-Server SDK for Matrix")
    (description "This package provides client-server SDK for Matrix.")
    (license license:asl2.0)))

(define-public python-matrix-synapse-ldap3
  (package
    (name "python-matrix-synapse-ldap3")
    (version "0.1.4")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "matrix-synapse-ldap3" version))
       (sha256
        (base32
         "01bms89sl16nyh9f141idsz4mnhxvjrc3gj721wxh1fhikps0djx"))))
    (build-system python-build-system)
    (arguments
     ;; tests require synapse, creating a circular dependency.
     '(#:tests? #f))
    (propagated-inputs
     `(("python-twisted" ,python-twisted)
       ("python-ldap3" ,python-ldap3)
       ("python-service-identity" ,python-service-identity)))
    (home-page "https://github.com/matrix-org/matrix-synapse-ldap3")
    (synopsis "LDAP3 auth provider for Synapse")
    (description
     "This package allows Synapse to use LDAP as a password provider.
This lets users log in to Synapse with their username and password from
an LDAP server.")
    (license license:asl2.0)))

(define-public synapse
  (package
    (name "synapse")
    (version "1.29.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "matrix-synapse" version))
              (sha256
               (base32
                "0if2yhpz8psg0661401mvxznldbfhk2j9rhbs25jdaqm9jsv6907"))))
    (build-system python-build-system)
    ;; TODO Run tests with ‘PYTHONPATH=. trial3 tests’.
    (propagated-inputs
     `(("python-simplejson" ,python-simplejson) ; not attested but required
       ;; requirements (synapse/python_dependencies.py)
       ("python-jsonschema" ,python-jsonschema)
       ("python-frozendict" ,python-frozendict)
       ("python-unpaddedbase64" ,python-unpaddedbase64)
       ("python-canonicaljson" ,python-canonicaljson)
       ("python-signedjson" ,python-signedjson)
       ("python-pynacl" ,python-pynacl)
       ("python-idna" ,python-idna)
       ("python-service-identity" ,python-service-identity)
       ("python-twisted" ,python-twisted)
       ("python-treq" ,python-treq)
       ("python-pyopenssl" ,python-pyopenssl)
       ("python-pyyaml" ,python-pyyaml)
       ("python-pyasn1" ,python-pyasn1)
       ("python-pyasn1-modules" ,python-pyasn1-modules)
       ("python-daemonize" ,python-daemonize)
       ("python-bcrypt" ,python-bcrypt)
       ("python-pillow" ,python-pillow)
       ("python-sortedcontainers" ,python-sortedcontainers)
       ("python-pymacaroons" ,python-pymacaroons)
       ("python-msgpack" ,python-msgpack)
       ("python-phonenumbers" ,python-phonenumbers)
       ("python-six" ,python-six)
       ("python-prometheus-client" ,python-prometheus-client)
       ("python-attrs" ,python-attrs)
       ("python-netaddr" ,python-netaddr)
       ("python-jinja2" ,python-jinja2)
       ("python-bleach" ,python-bleach)
       ("python-typing-extensions" ,python-typing-extensions)
       ;; conditional requirements (synapse/python_dependencies.py)
       ;;("python-hiredis" ,python-hiredis)
       ("python-matrix-synapse-ldap3" ,python-matrix-synapse-ldap3)
       ("python-psycopg2" ,python-psycopg2)
       ("python-jinja2" ,python-jinja2)
       ("python-txacme" ,python-txacme)
       ("python-pysaml2" ,python-pysaml2)
       ("python-lxml" ,python-lxml)
       ("python-packaging" ,python-packaging)
       ;; sentry-sdk, jaeger-client, and opentracing could be included, but
       ;; all are monitoring aids and not essential.
       ("python-pyjwt" ,python-pyjwt)))
    (native-inputs
     `(("python-mock" ,python-mock)
       ("python-parameterized" ,python-parameterized)))
    (home-page "https://github.com/matrix-org/synapse")
    (synopsis "Matrix reference homeserver")
    (description "Synapse is a reference \"homeserver\" implementation of
Matrix from the core development team at matrix.org, written in
Python/Twisted.  It is intended to showcase the concept of Matrix and let
folks see the spec in the context of a codebase and let you run your own
homeserver and generally help bootstrap the ecosystem.")
    (license license:asl2.0)))

(define-public python-matrix-nio
  (package
    (name "python-matrix-nio")
    (version "0.18.7")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "matrix-nio" version))
       (sha256
        (base32 "0cw4y6dx8n8hynxqlzzkj8p34nfbc2xryvmkr5yhmja31y4rks4k"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'check 'install-tests
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (copy-recursively (string-append
                                (assoc-ref inputs "tests") "/tests")
                               "tests")
             #t))
         (replace 'check
           (lambda* (#:key tests? inputs outputs #:allow-other-keys)
             (when tests?
               (add-installed-pythonpath inputs outputs)
               ;; FIXME: two tests fail, for unknown reasons
               (invoke "python" "-m" "pytest" "-vv" "tests" "-k"
                       (string-append
                        "not test_upload_binary_file_object "
                        "and not test_connect_wrapper"))))))))
    (native-inputs
     `(("python-pytest" ,python-pytest-6)
       ("python-hyperframe" ,python-hyperframe)
       ("python-hypothesis" ,python-hypothesis-6.23)
       ("python-hpack" ,python-hpack)
       ("python-faker" ,python-faker)
       ("python-pytest-aiohttp" ,python-pytest-aiohttp)
       ("python-aioresponses" ,python-aioresponses)
       ("python-pytest-benchmark" ,python-pytest-benchmark)
       ("python-toml" ,python-toml)
       ("tests"
        ;; The release on pypi comes without tests.  We can't build from this
        ;; checkout, though, because installation requires an invocation of
        ;; poetry.
        ,(origin
           (method git-fetch)
           (uri (git-reference
                 (url "https://github.com/poljar/matrix-nio.git")
                 (commit version)))
           (file-name (git-file-name name version))
           (sha256
            (base32
             "152prkndk53pfxm4in4xak4hwzyaxlbp6wv2zbk2xpzgyy9bvn3s"))))))
    (propagated-inputs
     `(("python-aiofiles" ,python-aiofiles)
       ("python-aiohttp" ,python-aiohttp)
       ("python-aiohttp-socks" ,python-aiohttp-socks)
       ("python-atomicwrites" ,python-atomicwrites-1.4)
       ("python-cachetools" ,python-cachetools)
       ("python-future" ,python-future)
       ("python-h11" ,python-h11)
       ("python-h2" ,python-h2)
       ("python-jsonschema" ,python-jsonschema)
       ("python-logbook" ,python-logbook)
       ("python-olm" ,python-olm)
       ("python-peewee" ,python-peewee)
       ("python-pycryptodome" ,python-pycryptodome)
       ("python-unpaddedbase64" ,python-unpaddedbase64)))
    (home-page "https://github.com/poljar/matrix-nio")
    (synopsis
     "Python Matrix client library, designed according to sans I/O principles")
    (description
     "Matrix nio is a multilayered Matrix client library.  The underlying base
layer doesn't do any network IO on its own, but on top of that is a full
fledged batteries-included asyncio layer using aiohttp.")
    (license license:isc)))

(define-public pantalaimon
  (package
    (name "pantalaimon")
    (version "0.10.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/matrix-org/pantalaimon")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "153d8083lj3qqirbv5q1d3igzd61a5kyzfk7xmv29sd3jbs8ysm9"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'downgrade-appdirs-requirement
           (lambda _
             (substitute* "setup.py"
               ;; FIXME: Remove this once appdirs is updated.
               ;; Upgrading python-appdirs requires rebuilting 3000+ packages,
               ;; when 1.4.4 is a simple maintenance fix from 1.4.3.
               (("appdirs >= 1.4.4") "appdirs >= 1.4.3"))))
         (replace 'check
           (lambda* (#:key tests? inputs outputs #:allow-other-keys)
             (when tests?
               (add-installed-pythonpath inputs outputs)
               (invoke "pytest" "-vv" "tests")))))))
    (native-inputs
     `(("python-pytest" ,python-pytest)
       ("python-faker" ,python-faker)
       ("python-pytest-aiohttp" ,python-pytest-aiohttp)
       ("python-aioresponses" ,python-aioresponses)))
    (propagated-inputs
     `(("python-aiohttp" ,python-aiohttp)
       ("python-appdirs" ,python-appdirs)
       ("python-attrs" ,python-attrs)
       ("python-cachetools" ,python-cachetools)
       ("python-click" ,python-click)
       ("python-janus" ,python-janus)
       ("python-keyring" ,python-keyring)
       ("python-logbook" ,python-logbook)
       ("python-matrix-nio" ,python-matrix-nio)
       ("python-peewee" ,python-peewee)
       ("python-prompt-toolkit" ,python-prompt-toolkit)))
    (home-page "https://github.com/matrix-org/pantalaimon")
    (synopsis "Matrix proxy daemon that adds E2E encryption capabilities")
    (description
     "Pantalaimon is an end-to-end encryption aware Matrix reverse proxy
daemon.  Pantalaimon acts as a good man in the middle that handles the
encryption for you.  Messages are transparently encrypted and decrypted for
clients inside of pantalaimon.")
    (license license:asl2.0)))
