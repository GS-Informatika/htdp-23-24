;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 03-auxiliary-functions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Při praci s rekurzí jsme se již několikrát setkali s
;; tím, že jsme v rekurzivním kroku prováděli operaci
;; danou naší vlastní funkcí, která rekurzivní
;; krok zjednodušila.

;; Obecně je více problémů které tento přístup přímo vyžadují.

;; Modelový příklad: Nadesignujme funkci která seřadí list čísel

;; Začněme podle našeho receptu:

;; 1) Signatura, hlavička a účel funkce

; List-of-Number -> List-of-Number
; Seřadí list čísel
#; (define (sort> alon)
     ...)

;; 2) Ukázky použití
(check-expect (sort> '()) '())
(check-expect (sort> (list 1 2 3)) (list 3 2 1))
(check-expect (sort> (list 5 2 7)) (list 7 5 2))
(check-expect (sort> (list 9 8 -7)) (list 9 8 -7))

;; Poznámka: mohli jsme také zvoli rostoucí seřazení - první prvek v listu by pak byl
;; vždy nejmenší.

;; 3) Překlad definice dat na template
#; (define (sort> alon)
     (cond [(empty? alon) ...]
           [else (... (first alon) ...
                      ... (sort> (rest alon)) ...)]))

;; 4) Implementace

#; (define (sort> alon)
     (cond [(empty? alon) '()] ; Jednoduché - podle ukázky použití!
           [else (... (first alon) ... ;; Ale co zde!?
                      ... (sort> (rest alon)) ...)]))

;; Víme, že
#; (sort> (rest alon))
;; nám vrátí srřazený zbytek listu. Nyní máme navíc číslo
#; (first alon)
;; Abychom ze seřazeného listu a dalšího čísla vytvořili seřazený list,
;; musíme toto další číslo vložit na správné místo do listu!

;; Problém seřazení čísel nám vytvořil jiný problém, který potřebujeme
;; vyřešit!

;; Musíme napsat pomocnou funkci, která tento nový problém řeší.

;; Signatura, hlavička a účel:

; Number List-of-Number -> List-of-Number
; Vloží číslo n do sestupně seřazeného listu alon tak, aby zůstal seřazený
#;(define (insert n alon)
    ...)

;; Funkci zatím nemáme implementovanou, ale můžeme ji zatím použít pro definici sort
(define (sort> alon)
  (cond [(empty? alon) '()]
        [else (insert (first alon) (sort> (rest alon)))]))

;; A nyní ji můžeme implementovat.

;; Nejprve opět ukázky použití

(check-expect (insert 1 '()) (list 1))
(check-expect (insert 2 (list 1)) (list 2 1))
(check-expect (insert 1 (list 2)) (list 2 1))
(check-expect (insert 1 (list 3 -2)) (list 3 1 -2))

;; Template podle definice dat
#;(define (insert n alon)
    (cond [(empty? alon) ...]
          [(cons? alon) (... (first alon) ...
                             ... (insert n (rest alon)) ...)]))

;; Pomocí ukázek použití doplníme template
(define (insert n alon)
  (cond [(empty? alon) (cons n '())]
        [(cons? alon) (if (> n (first alon))
                          ; n je větší než první číslo v listu
                          ; a patří tedy na začátek listu
                          (cons n alon)
                          ; n není větší než první číslo v listu
                          ; a je třeba jej vložit někam do zbytku listu
                          (cons (first alon)
                                (insert n (rest alon))))]))

;; Diskuze - jaká je složitost tohoto algoritmu?
;; Kolik kroků musí udělat pro seřazení listu o 3 prvcích?
;; Kolik kroků musí udělat pro seřazení listu o 6 prvcích?
