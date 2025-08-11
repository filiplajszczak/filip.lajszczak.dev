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
                    (url "https://codeberg.org/filiplajszczak/guile-syntax-highlight.git")
                    (commit "69009cbf719aa2faffb044d5a7ee384c9d8d55a1")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "15r6xq1j31139cgws1x10klpab16aqqna3p0wkc5ns4zgffyy2rd"))))
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