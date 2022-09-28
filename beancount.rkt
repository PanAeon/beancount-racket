#lang racket

(require "parser.rkt")
;(define (read-syntax path port)
;  (define src-lines (port->lines port))
  ;(define src-datums (format-datums '~a src-lines))
;  (define src-datums (format-datums ''(handle1 ~a) src-lines))
;  (define module-datum `(module beancount-mod br
;                          ,@src-datums))
;  (datum->syntax #f module-datum))
;(provide read-syntax)

(require syntax/strip-context)
 
(provide (rename-out [literal-read read]
                     [literal-read-syntax read-syntax]))
 
(define (literal-read in)
  (syntax->datum
   (literal-read-syntax #f in)))
 
(define (literal-read-syntax src in)
  (with-syntax ([str (readsyntax src in)])
;  (with-syntax ([str (port->string in)])
    (strip-context
     #'(module anything racket
         (provide data)
         (define data 'str)))))

; (handle-args ,@src-datums)


;(define-macro (beancount-module-begin HANDLE-ARGS-EXPR)
;  #'(#%module-begin
;     (display (first HANDLE-ARGS-EXPR))))

;(provide (rename-out [beancount-module-begin #%module-begin]))



;(define (handle-args . args)
;  (for/fold ([stack-acc empty])
;            ([arg (in-list args)]
;             #:unless (void? arg))
;    (cond
;      [(number? arg) (cons arg stack-acc)]
;      [(or (equal? * arg) (equal? + arg))
;       (define op-result
;         (arg (first stack-acc) (second stack-acc)))
;       (cons op-result (drop stack-acc 2))])))
;(provide handle-args)
;
;(provide + *)
