(define-module (theme)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-19)
  #:use-module (algorithms)
  #:use-module (haunt builder blog)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:export (little-theme
            tag-collection-url))

(register-metadata-parser!
 'style
 (lambda (str)
   (map string-trim-both (string-split str #\,))))

(define (littlify-sxml sxml)
  (define (convert-to-tr pair)
    (list
      'tr '(@ (class "border-bottom-thin border-top-thin"))
      (list 'td (car pair)) (list 'td (cadr pair))))

  (let ((pairs (chunks-of sxml 2)))
    (list
      'table '(@ (class "borders-custom"))
      (map convert-to-tr pairs))))

(define* (anchor content #:optional (uri content))
  `(a (@ (href ,uri)) ,content))

(define (needs-mathjax? body)
  "Check if body contains a div with data-needs-mathjax attribute"
  (and (pair? body)
       (pair? (car body))
       (eq? (caar body) 'div)
       (let ((attrs (and (pair? (cdar body)) (pair? (cadar body)) (cadar body))))
         (and attrs (assq-ref (cdr attrs) 'data-needs-mathjax)))))

(define (little-layout site title body)
  (let ((include-mathjax (needs-mathjax? body)))
    `((doctype html)
       (head
         (meta (@ (charset "utf-8")))
         (meta (@ (name "viewport")
                 (content "width=device-width, initial-scale=1")))
         (title ,(string-append title " — " (site-title site)))
         ;; css
         (link (@ (rel "stylesheet")
                 (href "/static/css/style.css")))
         ;; mathjax
         ,@(if include-mathjax
             `((script (@ (type "text/javascript"))
                 "window.MathJax = {
                    tex: {
                      inlineMath: [['$', '$']],
                      displayMath: [['$$', '$$']]
                    },
                    chtml: {
                      fontURL: '/static/fonts/mathjax'
                    }
                  };")
               (script (@ (type "text/javascript")
                         (src "/static/scripts/tex-mml-chtml.js"))))
             '()))
       (body
         (div (@ (class "container"))
           (header
             (h1 (a (@ (href "/")
                      (style "text-decoration: none; color: black;"))
                   ,(site-title site)))
             (p (@ (class "author")) "by Filip Łajszczak")
             ())
           ,body
           (br)
           ,(footer))))))

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

(define (post-styles post)
  "Return list of styles for POST, or the empty list if no styles are specified."
  (or (post-ref post 'style) '()))

(define (transform-post-sxml post)
  (let ([transformer
          (if (member "little" (post-styles post))
            littlify-sxml
            identity)])
    (transformer (post-sxml post))))

(define (tag-collection-url tag)
  "Generate URL for TAG collection page"
  (string-append "/tags/" tag ".html"))

(define (tag->link tag)
  "Convert TAG to an SXML link"
  (anchor tag (tag-collection-url tag)))

(define (intersperse-with separator items)
  "Intersperse ITEMS with SEPARATOR"
  (if (null? items)
      '()
      (fold-right (lambda (item acc)
                    (if (null? acc)
                        (list item)
                        (cons item (cons separator acc))))
                  '()
                  items)))

(define (render-tag-links post)
  "Generate tag links for POST"
  (let ((tags (post-tags post)))
    (if (null? tags)
        '()
        `((p (@ (class "tags"))
             "Tags: "
             ,@(intersperse-with " | " (map tag->link tags)))))))

(define (render-tag-cloud posts)
  "Generate tag links with post counts from POSTS"
  (map (lambda (tag-count-pair)
         (let ((tag (car tag-count-pair))
               (count (length (cdr tag-count-pair))))
           `(span ,(anchor tag (tag-collection-url tag))
                  " (" ,count ")")))
       (posts/group-by-tag posts)))

(define (little-post-template post)
  (let ((needs-math? (member "math" (post-styles post))))
    `((div (@ (class "post-content")
              ,@(if needs-math? `((data-needs-mathjax "true")) '()))
        (h2 ,(post-ref post 'title))
        (p (@ (class "author")) ,(date->string (post-date post) "~1 ~H:~M"))
        ,@(render-tag-links post)
        (div ,(transform-post-sxml post))))))

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
     (h3 "Tags")
     (p ,@(intersperse-with " | " (render-tag-cloud posts)))))

(define little-theme
  (theme #:name "Little"
    #:layout little-layout
    #:post-template little-post-template
    #:collection-template little-collection-template))
