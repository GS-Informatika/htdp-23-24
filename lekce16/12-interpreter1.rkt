;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |12 - interpreter1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Příklad - interpreter booleovských výrazů

;; Stromová struktura lze využít při reprezentaci
;; defunkcionalizace (operace/funkce reprezentujeme
;; jako data)

;; Pro vyhodnocení booleovských výrazů nejprve potřebujeme
;; vytvořit defunkcionalizovanou reprezentaci, tedy
;; datové typy odpovídající operacím

; BooleanLiteral je:
; - 'T
; - 'F

(define-struct op-not [value])
; Not je struktura
#; (make-op-not BooleanLiteral)

(define-struct op-and [left right])
; And je struktura
#; (make-op-and BooleanLiteral  BooleanLiteral)

(define-struct op-or [left right])
; Or je struktura
#; (make-op-or BooleanLiteral BooleanLiteral)


; Expression je jedno z:
; - BooleanLiteral
; - Not
; - And
; - Or

(define expr1 (make-op-not (make-op-and 'T (make-op-or 'T 'F))))

; Any -> Boolean
; Určí jestli je hodnota typu BooleanLiteral
(define (boolean-literal? val)
  (and (symbol? val)
       (or (symbol=? 'T val)
           (symbol=? 'F val))))

; BooleanLiteral -> Boolean
(define (true-literal? val)
  (symbol=? 'T val))

; Expression -> BooleanLiteral
; Evaluuje výraz
(define (eval expr)
  (cond [(boolean-literal? expr) expr]
        [(op-or? expr) (eval-or expr)]
        [(op-and? expr) (eval-and expr)]
        [(op-not? expr) (eval-not expr)]
        ))

; Not -> BooleanLiteral
; Evaluuje Not expression
(check-expect (eval-not (make-op-not 'T)) 'F)
(check-expect (eval-not (make-op-not 'F)) 'T)
(define (eval-not expr)
  (if (true-literal? (eval (op-not-value expr)))
      'F
      'T))

; Or -> BooleanLiteral
; Evaluuje Or expression
(check-expect (eval-or (make-op-or 'T 'T)) 'T)
(check-expect (eval-or (make-op-or 'F 'T)) 'T)
(check-expect (eval-or (make-op-or 'T 'F)) 'T)
(check-expect (eval-or (make-op-or 'F 'F)) 'F)
(define (eval-or expr)
  (local (
          (define left (eval (op-or-left expr)))
          )
    (if (true-literal? left)
        left
        (eval (op-or-right expr)))))

; And -> BooleanLiteral
; Evaluuje And expression
(check-expect (eval-and (make-op-and 'T 'T)) 'T)
(check-expect (eval-and (make-op-and 'T 'F)) 'F)
(check-expect (eval-and (make-op-and 'F 'T)) 'F)
(check-expect (eval-and (make-op-and 'F 'F)) 'F)
(define (eval-and expr)
  (local (
          (define left (eval (op-and-left expr)))
          )
    (if (true-literal? left)
        (eval (op-and-right expr))
        left)))

(define res1 (eval expr1))

;; Nyní máme k dispozici jednoduchý interpreter výrazů.
;; Výrazy ale prvně musíme "zadat" v defunkcionalizované
;; formě. Potřebujeme parser. Napsat vlastní parser vyžaduje
;; generativní rekurzi, ke které se teprve dostaneme. Použijeme
;; tedy S-Expressions které nám Student Languages poskytují

;; PREDIKÁTY

; Symbol -> Boolean
(define (is-literal-true? smb)
  (or (symbol=? 'TRUE smb)
      (symbol=? 'T smb)))

; Symbol -> Boolean
(define (is-literal-false? smb)
  (or (symbol=? 'FALSE smb)
      (symbol=? 'F smb)))

; Any -> Boolean
(define (is-literal? smb)
  (and (symbol? smb)
       (or (is-literal-true? smb)
           (is-literal-false? smb))))

; Symbol -> Boolean
(define (is-unary-op? smb)
  (or (symbol=? 'NOT smb)
      (symbol=? '~ smb)))

; Symbol -> Boolean
(define (is-binary-op? smb)
  (or (symbol=? 'OR smb)
      (symbol=? 'AND smb)))

; Any -> Boolean
(define (is-op? smb)
  (and (list? smb)
       (not (empty? smb))
       (or (is-unary-op? (first smb))
           (is-binary-op? (first smb)))))

; Symbol -> Constructor
(define (name-to-cons name)
  (cond [(symbol=? name 'NOT) make-op-not]
        [(symbol=? name '~) make-op-not]
        [(symbol=? name 'OR) make-op-or]
        [(symbol=? name 'AND) make-op-and]))

;; PARSING

; Symbol -> BooleanLiteral
(define (parse-literal smb)
  (cond [(is-literal-true? smb) 'T]
        [(is-literal-false? smb) 'F]
        [else (error "Encountered wrong literal")]))

; S-Expression -> Expression
(define (parse-unary-op se)
  (local ((define op-name (first se))
          (define op-arg (parse (second se))))
    ((name-to-cons op-name) op-arg)))

; S-Expression -> Expression
(define (parse-binary-op se)
  (local ((define op-name (first se))
          (define op-arg1 (parse (second se)))
          (define op-arg2 (parse (third se))))
    ((name-to-cons op-name) op-arg1 op-arg2)))

; S-Expression -> Expression
(define (parse-op se)
  (cond [(is-unary-op? (first se)) (parse-unary-op se)]
        [(is-binary-op? (first se)) (parse-binary-op se)]))


; S-Expression -> Expression
; Vytvoří AST (abstract syntax tree) booleovského Expression
; z S-Expression
(check-expect (parse 'TRUE) 'T)
(check-expect (parse '(AND TRUE TRUE)) (make-op-and 'T 'T))
(check-expect (parse '(AND (OR (AND T (OR T F)) F) (OR F F)))
              (make-op-and (make-op-or
                            (make-op-and 'T
                                         (make-op-or 'T 'F))
                            'F)
                           (make-op-or 'F 'F)))
(check-error (parse '(SOMETHING T T)))
(define (parse se)
  (cond [(is-literal? se) (parse-literal se)]
        [(is-op? se) (parse-op se)]
        [else (error "Encountered wrong syntax")]))


(define expr2 (parse '(AND (~ T) (OR (NOT F) (NOT T)))))
(define res2 (eval expr2))

;; Cvičení
;; Vytvořte funkci ast->string, která z AST (Expression) vytvoří člověkem
;; čitelný string popisující logické operace. Operace vždy ozávorkujte.

#; (check-expect (ast->string expr1) "(NOT (TRUE AND (TRUE OR FALSE)))")
#; (check-expect (ast->string expr2) "((NOT TRUE) AND ((NOT FALSE) OR (NOT TRUE)))")
