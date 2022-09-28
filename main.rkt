#lang racket
 
(module reader racket
  (require "beancount.rkt")
  (provide (all-from-out "beancount.rkt")))

(module+ main
  (require "parser.rkt")
  (pretty-print (readsyntax "stdin" (current-input-port)) ))
