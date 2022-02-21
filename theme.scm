(define-module (theme)
  #:use-module (srfi srfi-19)
  #:use-module (haunt builder blog)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:export (terminal-theme))

(define* (anchor content #:optional (uri content))
  `(a (@ (href ,uri)) ,content))

(define (terminal-layout site title body)
  `((doctype html)
    (head
     (meta (@ (charset "utf-8")))
     (meta (@ (name "viewport")
              (content "width=device-width, initial-scale=1")))
     (title ,(string-append title " — " (site-title site))))
     ;; css
     (link (@ (rel "stylesheet")
              (href "static/css/terminal.min.css")))
     (body (@ (class "terminal"))
           (div (@ (class "container"))
                ,body
                ,(footer)))))

(define (footer)
  `((hr)
    (p "Made with "
       ,(anchor "Haunt" "https://dthompson.us/projects/haunt.html")
       ", a static site generator written in "
       ,(anchor "Guile Scheme" "https://www.gnu.org/software/guile/")
       ", and " ,(anchor "terminal.css" "https://terminalcss.xyz/"))

    (p "Built on "
       ,(anchor "GNU Guix" "https://sr.ht/~dhruvin/builds.sr.ht-guix/")
       " on " ,(anchor "Sourcehut builds" "https://man.sr.ht/builds.sr.ht/")
       " and hosted on "
       ,(anchor "Sourcehut pages" "https://srht.site/"))

    ;; Source is available on [sourcehut](https://git.sr.ht/~filiplajszczak/filip.lajszczak.dev) and
    ;; [gitlab](https://gitlab.com/filiplajszczak/filip.lajszczak.dev). Patches are welcome.
    ))

(define (terminal-post-template post)
  `((h2 ,(post-ref post 'title))
    (p "by " ,(post-ref post 'author)
        ", " ,(date->string (post-date post) "~1 ~H:~M"))
    (div ,(post-sxml post))
    ))

(define (terminal-collection-template site title posts prefix)
  (define (post-uri post)
    (string-append (or prefix "") "/"
                   (site-post-slug site post) ".html"))

  `((h3 ,title)
    (ul
     ,@(map (lambda (post)
              `(li
                (a (@ (href ,(post-uri post)))
                   ,(date->string (post-date post) "~1")
                   " — "
                   ,(post-ref post 'title))))
            posts))))

(define terminal-theme
  (theme #:name "Terminal"
         #:layout terminal-layout
         #:post-template terminal-post-template
         #:collection-template terminal-collection-template))
