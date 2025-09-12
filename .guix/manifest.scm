(use-modules (gnu packages guile-xyz)
             (gnu packages guile)
             (gnu packages version-control)
             (gnu packages web)
             (gnu packages base)
             (guix profiles)
             (guile-syntax-highlight-git))

(packages->manifest
 (list
   haunt
   hut
   guile-3.0
   guile-algorithms
   guile-colorized
   guile-readline
   glibc-locales
   guile-syntax-highlight-git))