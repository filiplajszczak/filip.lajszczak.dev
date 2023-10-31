(define-module (theme)
  #:use-module (srfi srfi-1)

  #:use-module (srfi srfi-19)

  #:use-module (haunt builder blog)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:export (little-theme))

(define* (sliding lst size #:optional (step 1))
  (define (tail-call lst)
    (if (>= size (length lst))
      (list lst)
      (cons (take lst size)
        (tail-call (drop lst step)))))
  (if (>= step (length lst))
    (throw 'inconsistent-arguments "step has to be smaller then length of the list")
    (tail-call lst)))

(define (chunks-of lst k)
  (sliding lst k k))

(define (littlify-sxml sxml)
  (define (convert-to-tr pair)
    (list
      'tr '(@ (class "border-bottom-thin border-top-thin"))
      (list 'td (cdr (car pair))) (list 'td (cdr (cadr pair)))))

  (let ((pairs (chunks-of sxml 2)))
    (list
      'table '(@ (class "borders-custom"))
      (map convert-to-tr pairs))))

(define* (anchor content #:optional (uri content))
  `(a (@ (href ,uri)) ,content))

(define (little-layout site title body)
  `((doctype html)
     (head
       (meta (@ (charset "utf-8")))
       (meta (@ (name "viewport")
               (content "width=device-width, initial-scale=1")))
       (title ,(string-append title " — " (site-title site))))
     ;; css
     (link (@ (rel "stylesheet")
             (href "static/css/style.css")))
     (body
       (div (@ (class "container"))
         (header
           (h1 (a (@ (href "/")
                    (style "text-decoration: none; color: black;"))
                 ,(site-title site))))
         ,body
         ,(footer)))))

(define (footer)
  `((div (@ (class "footnotes"))
      (p "Made with "
        ,(anchor "Haunt" "https://dthompson.us/projects/haunt.html")
        ", a static site generator written in "
        ,(anchor "Guile Scheme" "https://www.gnu.org/software/guile/")
        ", and " ,(anchor "LaTeX.css" "https://latex.vercel.app/")
        ".")

      (p "Built on "
        ,(anchor "GNU Guix" "https://sr.ht/~dhruvin/builds.sr.ht-guix/")
        " on " ,(anchor "Sourcehut builds" "https://man.sr.ht/builds.sr.ht/")
        " and hosted on "
        ,(anchor "Sourcehut pages" "https://srht.site/")
        ".")

      (p "Source code is available on "
        ,(anchor "Sourcehut" "https://git.sr.ht/~filiplajszczak/filip-lajszczak-dev")
        ". Patches are welcome."))))

(define (tranformer post)
  (if (member
        "little"
        (cdr (assoc 'tags (post-metadata post))))
    littlify-sxml
    identity))

(define (little-post-template post)
  `((h2 ,(post-ref post 'title))
     (p (@ (class "author")) "by " ,(post-ref post 'author)
       (br) ,(date->string (post-date post) "~1 ~H:~M"))

     (div ,((tranformer post) (post-sxml post)))))

(define (little-collection-template site title posts prefix)
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
           posts))
     ))

(define little-theme
  (theme #:name "Little"
    #:layout little-layout
    #:post-template little-post-template
    #:collection-template little-collection-template))
