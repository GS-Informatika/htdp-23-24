;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 14-bst) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Binary search trees

;; Binární (vyhledávací) stromy mají jednoduchou strukturu

(define-struct bst [value left right])
; [BST T] je jedno z
; - 'EMPTY
#; (make-bst T [BST T] [BST T])

;; Pravidlo pro tvorbu BST je pak takové, že strom musí být vždy seřazený
;; podle nějaké řadící funkce tak, že všechny elementy v levé větvi
;; jsou "menší" a všechny elementy v pravé větvi jsou "větší"
;; Této vlastnosti se říká BST Invariant


(define bst1 (make-bst 10
                       (make-bst 5
                                 (make-bst 2 'EMPTY 'EMPTY)
                                 (make-bst 7
                                           (make-bst 6 'EMPTY 'EMPTY)
                                           (make-bst 8 'EMPTY 'EMPTY)))
                       (make-bst 12
                                 (make-bst 11 'EMPTY 'EMPTY)
                                 (make-bst 15 'EMPTY 'EMPTY))))


;; Hledání v prvku takovém stromu je pak "rychlé",
;; při každém kroku zahazujeme polovinu stromu!

; [BST T] (T T -> Boolean) (T T -> Boolean) T -> [Maybe T]
(check-expect (bst-contains? bst1 = > 11) 11)
(check-expect (bst-contains? bst1 = > 16) #false)
(define (bst-contains? bst eq larger value)
  (cond [(and (symbol? bst) (symbol=? bst 'EMPTY)) #false]
        [(eq (bst-value bst) value) (bst-value bst)]
        [(larger (bst-value bst) value) (bst-contains? (bst-left bst) eq larger value)]
        [else (bst-contains? (bst-right bst) eq larger value)]))


;; Cvičení
;; Vytvořte funkci is-numeric-bst? která pro [BST Number] určí,
;; jestli je splněn BST invariant




;; Cvičení
;; Vytvořte strukturu Person která obsahuje pole name a age.
;; Vytvořte ukázku [BST Person]. Vhodně abstrahujte funkci is-numeric-bst?
;; a ověřte že je pro vaši ukázku [BST Person] splňen invariant BST.
;; Napište specializaci pro bst-contains?




