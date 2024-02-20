;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 01-files-and-lists) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
;; Vytvořte datovou strukturu (+ typ) work, která bude obsahovat křestní jméno
;; a příjmení zaměstnance, rate (tedy mzdu za hodinu) a počet odpracovaných hodin.

(define-struct work [name surname rate hours])
; Work je struktura
#;(make-work String String Number Number)

;; Cvičení - vytvořte datovou strukturu (+ typ) payslip - výplatnice - bude obsahovat
;; křestní jméno a příjmení zaměstnance a celkovou hrubou výplatu za
;; týden (tedy rate * počet hodin)

(define-struct payslip [name surname pay])
; Payslip je struktura
#;(make-payslip String String Number)

;; Cvičení - navrhněte funkci wages.v2 která z listu hodnot typu Work vytvoří list
;; hodnot typu Payslip

; Work -> Payslip
(check-expect (work->payslip (make-work "A" "B" 5 10)) (make-payslip "A" "B" 50))
(define (work->payslip work)
  (make-payslip (work-name work) (work-surname work)
                (* (work-rate work) (work-hours work))))

(define W1 (make-work "A" "B" 100 20))
(define W2 (make-work "C" "D" 50 5))
(define P1 (make-payslip "A" "B" 2000))
(define P2 (make-payslip "C" "D" 250))

; List-of-Work -> List-of-Payslip
(check-expect (wages.v2 '()) '())
(check-expect (wages.v2 (cons W1 (cons W2 '())))
              (cons P1 (cons P2 '())))
(define (wages.v2 l-o-w)
  (cond [(empty? l-o-w) '()]
        [(cons? l-o-w) (cons (work->payslip (first l-o-w))
                             (wages.v2 (rest l-o-w)))]))


;; Cvičení - nadesignujte funkci substitute-name která v listu stringů
;; nahradí všechny výskyty
#; "<name>"
;; za jméno předané v argumentu funkce




;; -------------------------------------------------------------------

;; ----- Listy v souborech -----
(require 2htdp/batch-io)
;; Když jsme si ukazovali čtení z textových souborů, reprezentovali jsme vnitřek
;; souboru jako jeden string. Nyní máme k dispozici další možné reprezentace!

;; 1) List stringů - jednotlivé řádky souboru jako stringy v listu
#;(read-lines "file.txt")

;; 2) List stringů - jednotlivá slova jako stringy v listu
#;(read-words "file.txt")

;; 3) List listu stringů - jednotlivá slova na řádku jako stringy v listu,
;; každý řádek jako list stringů
(read-words/line "file.txt")


;; Když naopak chceme uložit data do souboru, musíme je nejdřív agregovat do
;;  jednoho strigu, tedy použít rekurzivní funkci typu List -> String

;; Cvičení - výše jste implementovali funkci wages.v2 která z ListOfWork
;; vytvářela ListOfPayslip. Máme soubor ve kterém je na řádku vždy
;; jméno, příjmení, rate a počet odpracovaných hodin.
;; Vaším úkolem je napsat program, který ze souboru s těmito informacemi
;; (příkald - work.txt) vytvoří nový soubor kde bude na řádku jméno,
;; příjmení a celková výplata za týden.
;; Použíjte již implementovanou funkci wages.v2, vytvořte funkce které ze souboru vytvoří
;; list hodnot Work a funkce které z listu hodnot Payslip vytvoří jediný string pro uložení
;; pomocí write-file (odřádkování za každým záznamem proveďte pomocí
#; "\n"
;; které připojíte za každou stringovou reprezentaci Payslip)
;; Hint: pokud víme že má list více prvků, můžeme kromě selektoru first použít i
;; pomocné funkce second, third a fourth nebo jejich "LISP"
;; ekvivalenty car, cadr, caddr, cadddr

; Nora Courtney 430 14
(cons "Nora" (cons "Courtney" (cons "430" (cons "14" '()))))
(make-work "Nora" "Courtney" 430 14)

#;(read-words/line "work.txt")

; List-of-String -> Work
(define (parse-work l)
  (make-work (first l) (second l) (string->number (third l))
             (string->number (fourth l))))

; List-of-List-of-String -> List-of-Work
(define (parse-all-work ll)
  (cond [(empty? ll) '()]
        [(cons? ll) (cons (parse-work (first ll))
                          (parse-all-work (rest ll)))]))

;; wages.v2 je List-of-Work -> List-of-Payslip

; Payslip -> String
(define (payslip->string p)
  (string-append (payslip-name p) " " (payslip-surname p)
                 " " (number->string (payslip-pay p)) " Kč"))

; List-of-Payslip -> List-of-String
(define (stringify-payslips lop)
  (cond [(empty? lop) '()]
        [(cons? lop) (cons (payslip->string (first lop))
                           (stringify-payslips (rest lop)))]))

; List-of-String -> String
(define (concat los)
  (cond [(empty? los) ""]
        [(cons? los) (string-append (first los)
                                    "\n"
                                    (concat (rest los)))]))

(write-file "out.txt"
            (concat (stringify-payslips
                     (wages.v2 (parse-all-work (read-words/line "work.txt"))))))
