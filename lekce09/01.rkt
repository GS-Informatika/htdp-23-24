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




;; --- Funkce produkující listy ---

;; Zatím jsme si ukazovali funkce které ze sebe-referujících dat vytvářely
;; hodnoty které už sebe-referující nebyly. V procvičovacích úlohách jste ale
;; měli možnost vyzkoušet si nadesignovat funkci která listy "vytváři".

;; Koncept byl podobný - rekurzivně zpracováváme data, v rekurzivním kroku vytvoříme list

(define WAGE-PER-HOUR 400)

; ListOfNubmer -> ListOfNumber
; Spočítá mzdy z listu odpracovaných hodin za týden
(check-expect (wages '()) '())
(check-expect (wages (cons 32 (cons 0 (cons 8 '()))))
              (cons (* WAGE-PER-HOUR 32) (cons 0 (cons (* WAGE-PER-HOUR 8) '()))))
(define (wages list-of-hours)
  (cond [(empty? list-of-hours) '()] ; Prázdný list vede na prázdný list
        [(cons? list-of-hours) (cons (* WAGE-PER-HOUR
                                        (first list-of-hours))
                                     (wages (rest list-of-hours)))]))


;; -------------------------------------------------------------------

;; Cvičení - ne každý zaměstnanec má stejnou odměnu za hodinu práce.
;; Vytvořte datovou strukturu (+ typ) work, která bude obsahovat křestní jméno a příjmení zaměstnance, rate
;; (tedy mzdu za hodinu) a počet odpracovaných hodin.




;; Cvičení - vytvořte datovou strukturu (+ typ) payslip - výplatnice - bude obsahovat
;; křestní jméno a příjmení zaměstnance a celkovou hrubou výplatu za týden (tedy rate * počet hodin)




;; Cvičení - navrhněte funkci wages.v2 která z listu hodnot typu Work vytvoří list
;; hodnot typu Payslip




;; Cvičení - nadesignujte funkci substitute-name která v listu stringů nahradí všechny výskyty
#; "<name>"
;; za jméno předané v argumentu funkce




;; -------------------------------------------------------------------

;; ----- Listy v souborech -----
(require 2htdp/batch-io)
;; Když jsme si ukazovali čtení z textových souborů, reprezentovali jsme vnitřek souboru jako
;; jeden string. Nyní máme k dispozici další možné reprezentace!

;; 1) List stringů - jednotlivé řádky souboru jako stringy v listu
#;(read-lines "file.txt")

;; 2) List stringů - jednotlivá slova jako stringy v listu
#;(read-words "file.txt")

;; 3) List listu stringů - jednotlivá slova na řádku jako stringy v listu, každý řádek jako
;;                         list stringů
#;(read-words/line "file.txt")


;; Když naopak chceme uložit data do souboru, musíme je nejdřív agregovat do jednoho strigu,
;; tedy použít rekurzivní funkci typu List -> String

;; Cvičení - výše jste implementovali funkci wages.v2 která z ListOfWork vytvářela ListOfPayslip.
;; Máme soubor ve kterém je na řádku vždy jméno, příjmení, rate a počet odpracovaných hodin.
;; Vaším úkolem je napsat program, který ze souboru s těmito informacemi (příkald - work.txt)
;; vytvoří nový soubor kde bude na řádku jméno, příjmení a celková výplata za týden.
;; Použíjte již implementovanou funkci wages.v2, vytvořte funkce které ze souboru vytvoří
;; list hodnot Work a funkce které z listu hodnot Payslip vytvoří jediný string pro uložení
;; pomocí write-file (odřádkování za každým záznamem proveďte pomocí
#; "\n"
;; které připojíte za každou stringovou reprezentaci Payslip)
;; Hint: pokud víme že má list více prvků, můžeme kromě selektoru first použít i
;; pomocné funkce second, third a fourth nebo jejich "LISP" ekvivalenty car, cadr, caddr, cadddr

#;(read-words/line "work.txt")
