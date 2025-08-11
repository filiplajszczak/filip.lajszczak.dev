(define-module (guile-syntax-highlight-git)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages texinfo))

(define-public guile-syntax-highlight-git
  (package
    (name "guile-syntax-highlight-git")
    (version "0.2.0-git")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.dthompson.us/guile-syntax-highlight/")
                    (commit "e40cc75f93aedf52d37c8b9e4f6be665e937e21d")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0iqspd8wdxizv0z3adxlxx6bzfx1376qzc4bwbwrdln4p7fc975m"))))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags '("GUILE_AUTO_COMPILE=0")))
    (native-inputs
     (list autoconf automake pkg-config texinfo))
    (inputs
     (list guile-3.0))
    (synopsis "General-purpose syntax highlighter for GNU Guile")
    (description "Guile-syntax-highlight is a general-purpose syntax
highlighting library for GNU Guile.  It can parse code written in various
programming languages into a simple s-expression that can be converted to
HTML (via SXML) or other formats for rendering.")
    (home-page "https://dthompson.us/projects/guile-syntax-highlight.html")
    (license lgpl3+)))