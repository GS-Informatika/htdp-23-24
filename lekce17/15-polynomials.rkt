;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 15-polynomials) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Polynomy a symbolické derivování

;; Polynomy a operace na nich můžeme interpretovat podobně jako
;; jsme interpretovali booleovské výrazy.

;; V případě polynomů rozlišujeme základní operace
;; 1) sčítání
;; 2) násobení

;; Data jsou pak
;; 1) Proměnná polynomu
;; 2) Konstanta (číslo)

(define-struct constant [value])
(define-struct variable [name])
(define-struct add [left right])
(define-struct mult [left right])
; Polynomial is one of
#; (make-constant Number)
#; (make-variable Symbol)
#; (make-add Polynomial Polynomial)
#; (make-mult Polynomial Polynomial)

;; Pro derivaci polynomů platí

; dc/dx = 0 ;; pro c konstantu nebo proměnnou jinou než x

; dx/dx = 1

; d(u + v)/dx = du/dx + dv/dx

; d(u * v)/dx = u * dv/dx + v du/dx


;; Cvičení - pomocí pravidel pro derivaci polynomů napište funkci
;; symbolic-differentiate, která zderivuje polynom podle pravidel
;; výše. Napište si vhodné pomocné funkce.




