(define-module (guile-syntax-highlight-git)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages pkg-config))

(define-public guile-syntax-highlight-git
  (let ((commit "f89d15f91fdda4ba06beac2caa0c6f3679862d61"))
    (package
      (inherit guile-syntax-highlight)
      (name "guile-syntax-highlight-git")
      (version "0.3.0-git")
      (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://codeberg.org/filiplajszczak/guile-syntax-highlight.git")
                    (commit commit)))
              (file-name (git-file-name "guile-syntax-highlight" version))
              (sha256
               (base32
                "0g2a8nzpncw84br3h6a2fic559nw5jk05vp3rmbjj565m4yxb2hy"))))
      (arguments
       '(#:make-flags '("GUILE_AUTO_COMPILE=0")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'bootstrap
             (lambda _ (invoke "sh" "bootstrap"))))))
      (inputs (list guile-3.0))
      (native-inputs (list autoconf automake pkg-config)))))