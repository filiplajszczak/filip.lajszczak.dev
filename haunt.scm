(use-modules (haunt asset)
             (haunt site)
             (haunt builder assets)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder rss)
             (haunt reader commonmark)
             (haunt post)
             (haunt artifact)
             (haunt html)
             (ice-9 match)
             (markdown)
             (theme))

(define (tag-pages-builder)
  "Build individual pages for each tag"
  (lambda (site posts)
    (map (match-lambda
           ((tag . tagged-posts)
            (serialized-artifact
             (string-append "tags/" tag ".html")
             ((theme-layout little-theme)
              site
              (string-append "Tag: " tag)
              ((theme-collection-template little-theme)
               site
               (string-append "Posts tagged '" tag "'")
               (posts/reverse-chronological tagged-posts)
               ""))
             sxml->html)))
         (posts/group-by-tag posts))))

(site #:title "Some opinions, held with varying degrees of certainty."
      #:domain "filip.lajszczak.dev"
      #:default-metadata
      '((author . "Filip Łajszczak")
        (email  . "filip@lajszczak.dev"))
      #:readers (list commonmark-reader*)
      #:builders (list (blog #:theme little-theme)
                       (tag-pages-builder)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       (rss-feed)
                       (static-directory "static")))
