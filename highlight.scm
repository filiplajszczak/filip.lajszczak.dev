(define-module (highlight)
  #:use-module (ice-9 match)
  #:use-module (sxml match)
  #:use-module (syntax-highlight)
  #:export (highlight-code))

;; Now using the fixed convenience procedures that resolve lexers
;; from their correct modules using resolve-interface
(define (maybe-highlight-code lang source)
  (let ((highlighted (highlight-by-language (symbol->string lang) source)))
    (if highlighted
        (highlights->sxml highlighted)
        source)))

(define (highlight-code . tree)
  (sxml-match tree
    ((code (@ (class ,class) . ,attrs) ,source)
     (let ((lang (string->symbol
                  (string-drop class (string-length "language-")))))
       `(code (@ ,@attrs)
             ,(maybe-highlight-code lang source))))
    (,other other)))