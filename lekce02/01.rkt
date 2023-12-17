;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |01|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; V minulé lekci jsme si ukázali základy používání jazyka BSL

;; Výrazy zapisujeme v prefixové notaci, uzávorkované
#;(* (+ 1 1) (+ 2 3))
#;(* 2 5)
#;10

;; Ukázali jsme si definici funkce
(define (add5 x)
  (+ x 5))

;; Definovat můžeme i konstanty
(define height 120)
(define width 120)
(define area (* height width))
