(use-modules (haunt asset)
             (haunt site)
             (haunt builder assets)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder rss)
             (haunt reader commonmark)
             (theme))


(site #:title "Some opinions, held with varying degrees of certainty."
      #:domain "filip.lajszczak.dev"
      #:default-metadata
      '((author . "Filip Łajszczak")
        (email  . "filip@lajszczak.dev"))
      #:readers (list commonmark-reader)
      #:builders (list (blog #:theme little-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       (rss-feed)
                       (static-directory "static")))
