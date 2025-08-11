(define-module (markdown)
  #:use-module (commonmark)
  #:use-module (haunt post)
  #:use-module (haunt reader)
  #:use-module (highlight)
  #:use-module (sxml transform)
  #:export (commonmark-reader*))

(define (sxml-identity . args) args)

(define %commonmark-rules
  `((code . ,highlight-code)
    (*text* . ,(lambda (tag str) str))
    (*default* . ,sxml-identity)))

(define (post-process-commonmark sxml)
  (pre-post-order sxml %commonmark-rules))

(define commonmark-reader*
  (make-reader (make-file-extension-matcher "md")
               (lambda (file)
                 (call-with-input-file file
                   (lambda (port)
                     (values (read-metadata-headers port)
                             (post-process-commonmark
                              (commonmark->sxml port))))))))