#lang racket/base
(require parser-tools/lex
         parser-tools/yacc
         (prefix-in : parser-tools/lex-sre)
         racket/string
         syntax/readerr)

(provide beanp beanl readsyntax)
;;(rename-out [readsyntax read-syntax])
;; -----------------------------------------
;; Lexer
;; Token names and some lexer tests are taken from the python code: https://github.com/beancount/beancount
(define-tokens content-tokens
  (ID BOOL NUMBER FLAG STRING DATE ACCOUNT TAG LINK AMOUNT CURRENCY KEY))

(define-empty-tokens delim-tokens
  (EOF EOL INDENT COMMENT
       NONE
       PIPE ATAT AT LCURLCURL RCURLCURL LCURL RCURL COMMA TILDE PLUS MINUS SLASH LPAREN RPAREN HASH ASTERISK COLON NEG
       TXN BALANCE OPEN CLOSE COMMODITY PAD EVENT QUERY CUSTOM PRICE NOTE DOCUMENT PUSHTAG POPTAG PUSHMETA POPMETA OPTION PLUGIN INCLUDE
       WHITESPACE SPECIAL))

(define-lex-abbrevs
  (account-type (:: alphabetic (:* (:or digit "-" alphabetic))))
  (account-name (:: (:or alphabetic digit)(:* (:or digit "-" alphabetic))))
  (digit (:/ "0" "9"))
  (alnum (:/ #\A #\Z #\0 #\9)))

(define beanl
  (lexer-src-pos
   [(eof) 'EOF]
   [(:: #\newline (:+ blank)) 'INDENT]
   [(:: #\newline (:or #\* #\: #\# #\! #\& #\? #\% ) (:* (:~ #\newline))) 'EOL]
   [#\newline 'EOL]
   [(:+ blank) 'WHITESPACE]
   [(:: #\; (:* (:~ #\newline)) ) 'COMMENT]
   ["TRUE" (token-BOOL #t)]
   ["FALSE" (token-BOOL #f)]
   ["NULL" (token-NONE)]
   [(:= 1 (:/ #\A #\Z)) (token-CURRENCY lexeme)]
   [(:: (:/ #\A #\Z) (:* (:or (:/ #\A #\Z #\0 #\9) #\' #\. #\_ #\-)) (:/ #\A #\Z #\0 #\9)) (token-CURRENCY lexeme)]
   [(:: #\/  (:* (:or (:/ #\A #\Z #\0 #\9) #\' #\. #\_ #\-)) (:/ #\A #\Z)
        (:? (:: (:* (:or (:/ #\A #\Z #\0 #\9) #\' #\. #\_ #\-)) (:/ #\A #\Z #\0 #\9)))) (token-CURRENCY lexeme)]
   [(:or #\! #\& #\# #\? #\%) (token-FLAG lexeme)]
   ["|"            		'PIPE]
   ["@@"            	'ATAT]
   ["@"            		'AT]
   ["{{"            	'LCURLCURL]
   ["}}"            	'RCURLCURL]
   ["{"            		'LCURL]
   ["}"            		'RCURL]
   [","            		'COMMA]
   ["~"            		'TILDE]
   ["+"            		'PLUS]
   ["-"            		'MINUS]
   ["/"            		'SLASH]
   ["("            		'LPAREN]
   [")"            		'RPAREN]
   ["#"            		'HASH]
   ["*"            		'ASTERISK]
   [":"            		'COLON]
   [(:: #\' (:/ #\A #\Z)) (token-FLAG (substring lexeme 1))]
   ; keywords

   [ "txn" 'TXN]
   [ "balance" 'BALANCE]
   [ "open" 'OPEN]
   [ "close" 'CLOSE]
   [ "commodity" 'COMMODITY]
   [ "pad" 'PAD]
   [ "event" 'EVENT]
   [ "query" 'QUERY]
   [ "custom" 'CUSTOM]
   [ "price" 'PRICE]
   [ "note" 'NOTE]
   [ "document" 'DOCUMENT]
   [ "pushtag" 'PUSHTAG]
   [ "poptag" 'POPTAG]
   [ "pushmeta" 'PUSHMETA]
   [ "popmeta" 'POPMETA]
   [ "option" 'OPTION]
   [ "plugin" 'PLUGIN]
   [ "include" 'INCLUDE]

   [(:: (:>= 4 digit) (:or #\/ #\-) (:+ digit) (:or #\/ #\-) (:+ digit)) (token-DATE lexeme)]
   [(:: account-type (:+ (:: ":" account-name))) (token-ACCOUNT lexeme)]
   [(:seq #\" (:* (:~ #\")) #\")
    (token-STRING (substring lexeme 1 (sub1 (string-length lexeme))))]

   [(:: (:or (:+ digit) (:: digit (:+ (:or digit #\,)) digit)) (:? (:: #\. (:* digit)))) (token-NUMBER lexeme)]

   [(:: #\# (:+ (:or (:/ #\A #\Z #\a #\z #\0 #\9)  #\. #\_ #\-) )) (token-TAG (substring lexeme 1))]
   [(:: #\^ (:+ (:or (:/ #\A #\Z #\a #\z #\0 #\9)  #\. #\_ #\-) )) (token-LINK (substring lexeme 1))]
   [(:: (:/ #\a #\z) (:+ (:or (:/ #\A #\Z #\a #\z #\0 #\9) #\_ #\-) ) #\:) (token-KEY (substring lexeme 0 (sub1 (string-length lexeme))))]

   [(special) (token-SPECIAL lexeme)]))

; TODO single-character is also a currency
; TODO escape string
; TODO [Proper] Ignore lines starting with an asterisk, a colon, an hash, or a character

; return a list of tokens
(define (runl ip)
  (port-count-lines! ip)
  (define gen (λ () (beanl ip)))
  (let f ([x (gen)])
    (if (eq? 'EOF (position-token-token x))
        '()
        (cons x (f (gen))))))


(define (runtl ip)
  (map position-token-token (runl ip)))





; raco test parser.rkt
(module+ test
  (require rackunit)


  (check-equal? (runtl (open-input-string "brr:"))
                (list (token-KEY "brr")) "")

  (check-equal? (runtl (open-input-string "^foo.ar"))
                (list (token-LINK "foo.ar")) "")

  (check-equal? (runtl (open-input-string "#foo.bar"))
                (list (token-TAG "foo.bar")) "")

  (check-equal? (runtl (open-input-string "13,493"))
                (list (token-NUMBER "13,493")) "")

  (check-equal? (runtl (open-input-string "\"string\""))
                (list (token-STRING "string")) "")

  (check-equal? (runtl (open-input-string "1488-01-01"))
                (list (token-DATE "1488-01-01")) "")

  (check-equal? (runtl (open-input-string "1488/01/01"))
                (list (token-DATE "1488/01/01")) "")

  (check-equal? (runtl (open-input-string "include"))
                (list 'INCLUDE) "")

  (check-equal? (runtl (open-input-string "'A"))
                (list (token-FLAG "A")) "")

  (check-equal? (runtl (open-input-string "/NQH21_QNEG21C13100"))
                (list (token-CURRENCY "/NQH21_QNEG21C13100")) "")

  (check-equal? (runtl (open-input-string "NT.TO"))
                (list (token-CURRENCY "NT.TO")) "")

  (check-equal? (runtl (open-input-string "TRUE FALSE NULL"))
                (list (token-BOOL #t) 'WHITESPACE (token-BOOL #f) 'WHITESPACE 'NONE))


  (check-equal? (runtl (open-input-string ";foo:bar \nfoo:bar"))
                (list 'COMMENT 'EOL (token-ACCOUNT "foo:bar")) "comment stop before newline")

  (check-equal? (runtl (open-input-string "foo:bar"))
                (list (token-ACCOUNT "foo:bar")) "")

  (check-equal? (runtl (open-input-string "foo:bar 12.345\n"))
                (list (token-ACCOUNT "foo:bar") 'WHITESPACE (token-NUMBER "12.345") 'EOL)  "")

  (check-equal? (runtl (open-input-string "\n*   NT\nXZ"))
                (list 'EOL 'EOL (token-CURRENCY "XZ") ) "")


  (check-equal? (runtl (open-input-string 
        (string-join '(
                       "2014-07-05 *"
                       "  Equity:something"
                       ) "\n"))) (list
 (token-DATE "2014-07-05")
 'WHITESPACE
 'ASTERISK
 'INDENT
 (token-ACCOUNT "Equity:something")))

  (check-equal? (runtl (open-input-string 
        (string-join '(
          "2013-05-18 2014-01-02 2014/01/02"
          "Assets:US:Bank:Checking"
          "Liabilities:US:Bank:Credit"
          "Other:Bank"
          "USD HOOL TEST_D TEST_3 TEST-D TEST-3 NT.TO V P V12"
          "/NQH21 /NQH21_QNEG21C13100 /6A /6J8 ABC.TO /3.2"
          "\"Nice dinner at Mermaid Inn\""
          "\"\""
          "123 123.45 123.456789 -123 -123.456789"
          " #sometag123"
          "^sometag123"
          "somekey:"
          "% # 'V 'C") "\n")))
                (list
 (token-DATE "2013-05-18")
 'WHITESPACE
 (token-DATE "2014-01-02")
 'WHITESPACE
 (token-DATE "2014/01/02")
 'EOL
 (token-ACCOUNT "Assets:US:Bank:Checking")
 'EOL
 (token-ACCOUNT "Liabilities:US:Bank:Credit")
 'EOL
 (token-ACCOUNT "Other:Bank")
 'EOL
 (token-CURRENCY "USD")
 'WHITESPACE
 (token-CURRENCY "HOOL")
 'WHITESPACE
 (token-CURRENCY "TEST_D")
 'WHITESPACE
 (token-CURRENCY "TEST_3")
 'WHITESPACE
 (token-CURRENCY "TEST-D")
 'WHITESPACE
 (token-CURRENCY "TEST-3")
 'WHITESPACE
 (token-CURRENCY "NT.TO")
 'WHITESPACE
 (token-CURRENCY "V")
 'WHITESPACE
 (token-CURRENCY "P")
 'WHITESPACE
 (token-CURRENCY "V12")
 'EOL
 (token-CURRENCY "/NQH21")
 'WHITESPACE
 (token-CURRENCY "/NQH21_QNEG21C13100")
 'WHITESPACE
 (token-CURRENCY "/6A")
 'WHITESPACE
 (token-CURRENCY "/6J8")
 'WHITESPACE
 (token-CURRENCY "ABC.TO")
 'WHITESPACE
 'SLASH
 (token-NUMBER "3.2")
 'EOL
 (token-STRING "Nice dinner at Mermaid Inn")
 'EOL
 (token-STRING "")
 'EOL
 (token-NUMBER "123")
 'WHITESPACE
 (token-NUMBER "123.45")
 'WHITESPACE
 (token-NUMBER "123.456789")
 'WHITESPACE
 'MINUS
 (token-NUMBER "123")
 'WHITESPACE
 'MINUS
 (token-NUMBER "123.456789")
 'INDENT
 (token-TAG "sometag123")
 'EOL
 (token-LINK "sometag123")
 'EOL
 (token-KEY "somekey")
 'EOL) "")

  (check-equal? (runtl (open-input-string "4\n\n   NT"))
                (list (token-NUMBER "4") 'EOL 'INDENT (token-CURRENCY "NT") ) ""))


;; -----------------------------------------------------------------
;; Parser

(define (beanp source-name)
  (parser 
    (start s)
    (end EOF)
    (tokens content-tokens delim-tokens)
    (src-pos)
    (suppress)
    (precs 
          (left MINUS PLUS)
          (left ASTERISK SLASH)
          (left NEG))
    (error (lambda (tok-ok? tok-name tok-value start-pos end-pos)
         (raise-read-error
	       (format "Error Parsing beancount  at token: ~a with value: ~a" tok-name tok-value)
	       (file-path)
	       (position-line start-pos)
	       (position-col start-pos)
	       (position-offset start-pos)
	       (- (position-offset end-pos) (position-offset start-pos)))
     ))
    (grammar
      (s [(declaration-list) (reverse $1)])

      (<ws> [() #f]
            [(WHITESPACE) #f])

      (declaration-list [() null]
                        [(declaration-list COMMENT EOL) $1]
                        [(declaration-list EOL) $1]
                        [(declaration-list <ws> directive) (cons $3 $1)]
                        [(declaration-list <ws> entry) (cons $3 $1)])

      (directive [(pushtag) $1]
                 [(poptag) $1]
                 [(pushmeta) $1]
                 [(popmeta) $1]
                 [(option) $1]
                 [(include) $1]
                 [(plugin) $1])

      (pushtag [(PUSHTAG <ws> TAG <eol>) $3])
      (poptag [(POPTAG <ws> TAG <eol>) $3])
      (pushmeta [(PUSHMETA <ws> key-value-value <eol>) $3])
      (popmeta [(POPMETA <ws> KEY <eol>) $3])
      (option [(OPTION <ws> STRING <ws> STRING <eol>) (list 'Option $3 $5)])
      (include [(INCLUDE <ws> STRING <eol>) $3])
      (plugin [(PLUGIN <ws> STRING <eol>) $3])

      (entry [(transaction) $1]
             [(balance) $1]
             [(open) $1]
             [(close) $1]
             [(pad) $1]
             [(document) $1]
             [(note) $1]
             [(event) $1]
             [(price) $1]
             [(commodity) $1]
             [(query) $1]
             [(custom) $1])

      (open   [(DATE <ws> OPEN  <ws> ACCOUNT <ws> currency-list <ws> opt-booking key-value-list <eol>) (list 'Open $1 $5 (reverse $7) $9 (reverse $10))])
      (close  [(DATE <ws> CLOSE <ws> ACCOUNT key-value-list <eol>) (list 'CLOSE $1 $5 (reverse $6))])
      (pad    [(DATE <ws> PAD   <ws> ACCOUNT <ws> ACCOUNT key-value-list <eol>) (list 'PAD $1 $5 $7 (reverse $8))])
      (document   [(DATE <ws> DOCUMENT <ws> ACCOUNT <ws> filename <ws> tag-links key-value-list <eol>) (list 'DOCUMENT $1 $5 $7 $9 (reverse $10))])
      (note   [(DATE <ws> NOTE <ws> ACCOUNT <ws> STRING <ws> tag-links key-value-list <eol>) (list 'NOTE $1 $5 $7 $9 (reverse $10))])
      (event  [(DATE <ws> EVENT <ws> STRING <ws> STRING key-value-list <eol>) (list 'EVENT $1 $5 $7 (reverse $8))])
      (price  [(DATE <ws> PRICE <ws> CURRENCY <ws> amount key-value-list <eol>) (list 'PRICE $1 $5 $7 (reverse $8))])
      (commodity  [(DATE <ws> COMMODITY <ws> CURRENCY key-value-list <eol>) (list 'Commodity $1 $5 (reverse $6))])
      (query  [(DATE <ws> QUERY <ws> STRING <ws> STRING key-value-list <eol>) (list 'Query $1 $5 $7 (reverse $8))])
      (custom [(DATE <ws> CUSTOM <ws> STRING <ws> custom-value-list key-value-list <eol>) (list 'Custom $1 $5 (reverse $7) (reverse $8))])

      (<eol> [() null]
           [(EOL) null])

      (txn [(TXN) '*]
           [(FLAG) $1]
           [(ASTERISK) '*]
           [(HASH) '\#])

      (txn-strings [() null]
                   [(txn-strings STRING <ws>) (cons $2 $1)])

      (tag-links [() null]
                 [(tag-links LINK) (cons $2 $1)]
                 [(tag-links TAG) (cons $2 $1)])


      (transaction [(DATE <ws> txn <ws> txn-strings <ws> tag-links <ws> posting-or-kv-list <eol>) (list 'TX $1 $3 (reverse $5) (reverse $7) $9)])

      (posting 
        [(opt-flag <ws> ACCOUNT <ws> incomplete-amount <ws> cost-spec) (list 'POSTING $1 $3 $5 $7)]
        [(opt-flag <ws> ACCOUNT <ws> incomplete-amount <ws> cost-spec <ws> AT <ws> price-annotation) (list 'POSTING $1 $3 $5 $7 $11)]
        [(opt-flag <ws> ACCOUNT <ws> incomplete-amount <ws> cost-spec <ws> ATAT <ws> price-annotation) (list 'POSTING $1 $3 $5 $7 $11)]
        [(opt-flag <ws> ACCOUNT) (list 'POSTING $1 $3)]) ;; seems unnecessary?

      (balance [(DATE <ws> BALANCE <ws> ACCOUNT <ws> amount-tolerance key-value-list <eol>) (list 'Balance $1 $5 $7 $8)])

      (cost-spec [() null]
                 [(LCURL <ws> cost-comp-list <ws> RCURL) $2]
                 [(LCURLCURL <ws> cost-comp-list <ws> RCURLCURL) $2])

      (cost-comp-list [() null]
                      [(cost-comp) $1]
                      [(cost-comp-list COMMA <ws> cost-comp) (cons $4 $1)])
      (cost-comp [(compound-amount) $1]
                 [(DATE) $1]
                 [(STRING) $1]
                 [(ASTERISK) '*])

      (amount-tolerance [(number <ws> CURRENCY) (list $1 $3)])

      (currency-list [() null]
                     [(CURRENCY) (list $1)]
                     [(currency-list COMMA <ws> CURRENCY) (cons $4 $1)])

      
      (posting-or-kv-list [() null]
                          [(posting-or-kv-list INDENT tag-links ) (cons $3 $1)]
                          [(posting-or-kv-list INDENT KEY <ws> key-value-value) (cons (list $3 $5) $1)]
                          [(posting-or-kv-list INDENT posting ) (cons $3 $1)])

      (key-value-list [() null]
                      [(key-value-list INDENT KEY <ws> key-value-value) (cons (list $3 $5) $1)])

      (key-value-value [() null]
                       [(ACCOUNT) $1]
                       [(DATE) $1]
                       [(CURRENCY) $1]
                       [(TAG) (list 'TAG $1)]
                       [(BOOL) $1]
                       [(NONE) #f]
                       [(NUMBER) $1]
                       [(AMOUNT) $1]
                       [(STRING) $1])
      
      (custom-value-list [() null]
                      [(custom-value-list INDENT KEY <ws> custom-value-value) (cons (list $3 $5) $1)])

      (custom-value-value
                       [(STRING) $1]
                       [(DATE) $1]
                       [(BOOL) $1]
                       [(AMOUNT) $1]
                       [(NUMBER) $1]
                       [(ACCOUNT) $1])

      (number [(NUMBER <ws>) $1]
              [(NUMBER <ws> PLUS <ws> NUMBER) (list $1 '+ $5)]
              [(NUMBER <ws> MINUS <ws> NUMBER) (list $1 '- $5)]
              [(NUMBER <ws> ASTERISK <ws> NUMBER) (list $1 '* $5)]
              [(NUMBER <ws> SLASH <ws> NUMBER) (list $1 '/ $5)]
              [(MINUS  <ws> NUMBER) (prec NEG) (list  '- $3)]
              [(PLUS   <ws> NUMBER) (prec NEG) (list  '+ $3)]
              [(LPAREN <ws> NUMBER <ws> RPAREN) $3])

      (compound-amount [(maybe-number <ws> CURRENCY) (list $1 $3)]
                       [(number <ws> maybe-currency) (list $1 $3)]
                       [(maybe-number <ws> HASH <ws> maybe-number <ws> CURRENCY) (list $1 $5 $7)])

      (incomplete-amount [(maybe-number <ws> maybe-currency) (list $1 $3)])
      (amount [(number <ws> CURRENCY) (list $1 $3)])

      (price-annotation [(incomplete-amount) $1])
      (filename [(STRING) $1])

      (maybe-number [() null]
                    [(number) $1])

      (maybe-currency [() null]
                    [(CURRENCY) $1])

      (opt-booking [() null]
                   [(STRING) $1])
      (opt-flag [() null]
                [(FLAG) $1])
    )
  ))


(define (rs sn ip)
    (port-count-lines! ip)
    ((beanp sn) (lambda () (beanl ip))))
  
(define readsyntax
    (case-lambda ((sn) (rs sn (current-input-port)))
                 ((sn ip) (rs sn ip))))

(define (test-lines xs)
  (readsyntax "" (open-input-string (string-join xs "\n")))
  )

;; TODO: tags are not marked
;;(runtl (open-input-string "2020-04-06 open Liabilities:CreditCard:CapitalOne USD, EUR \"STRICT\"\n  foo: \"BAR\""))
;;(readsyntax "" (open-input-string 
;;                 "2020-04-06 open Liabilities:CreditCard:CapitalOne USD, EUR \"STRICT\"\n  foo: \"BAR\"\n  fooz:"))
#|(test-lines (list
  "2014-05-05 * \"Cafe Mogador\" \"Lamb tagine with wine\""
  "    Liabilities:CreditCard:CapitalOne         3739.45 USD"
  "    Expenses:Restaurant"))
|#

#|(test-lines (list 
              
"2020-01-01 * \"Opening Balance for checking account\" \"f\""
"  Assets:US:BofA:Checking                         3239.66 USD"
              ))|#

;; --------- Parser tests

(module+ test
  (require rackunit)
  (define (run s)
        (readsyntax "" (open-input-string s)))
  (define (ok s o)
    (check-equal? (run s) o))
  (define (no s xm)
    (with-handlers
        ([exn:fail?
          (λ (x)
            (check-regexp-match
             xm (exn-message x)))])
      (define o (run s))
      (check-true
       #f
       (format "expected error, got: ~v"
               o))))

  (ok "2020-03-04 open Liabilities:CreditCard:CapitalOne"
      '((Open "2020-03-04" "Liabilities:CreditCard:CapitalOne" () () ()))))
