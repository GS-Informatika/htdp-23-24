;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |01|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ----- Rekurze na struktuře -----

;; Sebe-referující struktury vedou na zpracování rekurzí a tvorbu indukcí

;; Typ Nat - přirozená čísla a tail-rekurze

; Nat is one of
; - 0
; - (add1 Nat)

; Nat Nat -> Nat
; Sums two Nats
(define (nat-add a b)
  (cond [(zero? b) a]
        [else (add1 (nat-add a (sub1 b)))]))

; Nat Nat -> Nat
; Sums two Nats
(define (nat-add/tailrec a b)
  (cond [(zero? b) a]
        [else (nat-add/tailrec (add1 a) (sub1 b))]))

;; Tail-rekurzivní volání má lepší prostorovou složitost a překladače
;; jej umí dobře optimalizovat

;; Naopak u rekurze která není tail-recursive hrozí při velkém množství
;; rekurzivních kroků takzvaný "stack overflow" - již není kam ukládat další kroky
;; k provedení.


;; ----- Neprázdné listy -----

; ListOfNumbers is one of:
; - '()
; - (cons Number ListOfNumber)

;; Příklad - počet prvků v listu čísel

; ListOfNumber -> Number
; Určí počet prvků v listu
(check-expect (how-many '()) 0)
(check-expect (how-many (cons 1 (cons 2 (cons 3 '())))) 3)
(define (how-many lon)
  (cond [(empty? lon) 0]
        [(cons? lon) (add1 (how-many (rest lon)))]))

;; Cvičení - nadesignujte funkci, která sečte list čísel




;; Cvičení - nadesignujte funkci average, která určí průměr z listu čísel.
;; Diskutujte jak vypadá base-case




;; Řešením nedefinovaného chování pro base case v předchozím cvičení je
;; "zákaz prázdného listu"
;; Definujme datový typ pro neprázdný list - to uděláme tak, že "base case"
;; (nerekurzivní část datové definice) bude list s jedním prvkem!


; NonEmptyListOfNumbers is one of
; - (cons Number '())
; - (cons Number NonEmptyListOfNumbers)


;; Cvičení - opravte definici funkce pro průměr listu čísel




;; Neprázdné listy běžně požadujeme pro operace které nemají neutrální prvek
;; který by se dal použít namísto chybějících dat.
;; Toto neplatí nutně jen pro funkce na číslech jako je average, ale i
;; pro funkce na jiných datových typech.

;; Cvičení - napište funkci která vezme list stringů a vypíše nejkratší z nich.
;; Okomentujte proč tato funkce nebude dobře fungovat s prázdným stringem.
