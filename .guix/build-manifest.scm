(use-modules (gnu packages guile-xyz)
             (gnu packages guile)
             (gnu packages version-control)
             (gnu packages web)
             (guile-syntax-highlight-git))

(packages->manifest
 (list haunt hut guile-3.0 guile-algorithms guile-syntax-highlight-git))