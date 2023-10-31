(use-modules (haunt asset)
             (haunt site)
             (haunt builder assets)
             (haunt builder blog)
             (haunt builder atom)
             (haunt reader commonmark)
             (theme))


(site #:title "Filip's Little Blog"
      #:domain "filip.lajszczak.dev"
      #:default-metadata
      '((author . "Filip Łajszczak")
        (email  . "filip@lajszczak.dev"))
      #:readers (list commonmark-reader)
      #:builders (list (blog #:theme little-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       (static-directory "static")))
