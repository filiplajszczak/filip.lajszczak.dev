(use-modules (haunt asset)
             (haunt site)
             (haunt builder assets)
             (haunt builder blog)
             (haunt builder atom)
             (haunt reader commonmark)
             (theme))


(site #:title "Filip Łajszczak"
      #:domain "filip.lajszczak.dev"
      #:default-metadata
      '((author . "Filip Łajszczak")
        (email  . "filip@lajszczak.dev"))
      #:readers (list commonmark-reader)
      #:builders (list (blog #:theme terminal-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       (static-directory "static")))
