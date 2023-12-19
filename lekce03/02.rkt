;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |02|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;; Predikáty

;; Výraz
#;(string->number "abc")
;; nám vrátil indikátor, že data nejsou vhodná pro tuto operaci.

;; V některých případech ale tento indikátor nedostaneme, místo toho
;; program signalizuje chybu (error) a aplikace "spadne".
;; Výraz který signalizuje chybu pak nemá výsledek, nelze redukovat!
#;(string-length 1)

;; Než tedy aplikujeme funkci na data, měli bychom si být jisti, že data
;; mají správný formát - splňují tzv. pre-conditions.

;; Predikáty jsou funkce vracející boolean, který značí jestli je hodnota
;; nějákého typu.

#;(number? 4)
#;(number? "pi")
#;(string? "pi")
#;(rational? pi) ; Zkuste uhodnout proč!?

;; Predikáty neurčují pouze datový typ - můžeme je použít i pro užší klasifikace
#;(odd? 4)
#;(even? 4)

;; Nazvěmě String "dlouhý" pokud má více než 20 znaků
(define (is-long? some-string)
  (> (string-length some-string) 20))
#;(is-long? "abcd")
#;(is-long? "abcdefghijklmnopqrstuvwxyz")

;; Predikáty vracejí boolean - můžeme je tedy přímo využívat pro větvení kódu!
(define (to-short-message message)
  (if (is-long? message)
      "Message to long!"
      message))