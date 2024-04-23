;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 20-binary-search) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Generativní rekurze dále umožňuje vyhledávání kořenů funkce

;; Předpokládejme, že máme funkci Number -> Number,
;; označme ji f(x).

;; Kořenem f(x) je taková hodnota x_0, že f(x_0) = 0

;; Nalezení takové hodnoty umíme pro lineární
;; a kvadratické funkce, případně pro speciální hodnoty
;; složitějších funkcí.

;; Obecné řešení tohoto problému je složitější.
;; Matematická analýza nám poskytuje "Bolzanova věta".
;; Tento přístup byl zobecněn na binární prohledávání.

;; Bolzanova věta je důsledkem "intermediate value theorem":
;; spojitá funkce na intervalu [a, b] nabývá všech
;; hodnot mezi [f(a), f(b)].

;; Bolzanova věta pak říká, že pokud
;; f(a)f(b) < 0, pak existuje alespoň jeden bod c, že
;; f(c) = 0.

;; Tato věta nám tedy dává podmínku pro existenci kořene.

;; Triviální řešení bude x_a které je maximálně o epsilon
;; vzdálené od kořene.
;; (epsilon malé číslo - jsme velmi blízko řešení, stačí
;; nám to - numerická metoda!)

;; K triviálnímu řešení se dostaneme tak, že budeme
;; dělit interval prohledávání na poloviny a aplikujeme
;; Bolzanovu větu.


(define epsilon 0.00001)


; [Number -> Number] Number Number -> Number
; Nalezne přibližný kořen funkce f
; Předpokládá že f je spojitá a
#; (or (<= (f left) 0 (f right))
       (<= (f right) 0 (f left)))
; Rozdělí interval na poloviny, kořen je v jednom
; z podintervalů - tom který splňuje podmínku výše
(define (root f left right)
  (cond [(<= (- right left) epsilon) left]
        [else (local ((define mid (/ (+ left right) 2))
                      (define f@mid (f mid))
                      (define f@left (f left))
                      (define f@right (f right)))
                (cond [(or (<= f@left 0 f@mid) (<= f@mid 0 f@left))
                       (root f left mid)]
                      [(or (<= f@right 0 f@mid) (<= f@mid 0 f@right))
                       (root f mid right)]))]))



;; Další numerické metody
;;  - Hledání kořene
;;    - Newtonova metoda
;;  - Výpočet integrálu:
;;    - Trapezoid rule
;;    - Simpsonovo pravidlo
;;  - Řešení diferenciálních rovnic
;;    - Eulerova metoda
;;    - Runge-Kutta metody
;;  - Hledání řešení soustav lineárních rovnic
;;    - Gaussova eliminace
;;  - Interpolace
;;    - Lagrangeova interpolace
