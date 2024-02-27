;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 02-lists-and-quotes) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ----- Funkce list -----
;; Konstruktor cons jsme psali už hodněkrát - pojďme si zjednodušit život!
;; Od teď budeme pracovat v jazyce BSL+ a budeme používat List Abbreviations

#; (list 1 2 3 4 5)
#; (list "první string" "druhý string" "třetí string")

;; Funkce list umožňuje konstruovat listy jednodušeji, stále ale mají
;; rekurzivní strukturu danou konstruktorem
#;(cons ITEM List-of-ITEM)



;; ----- Quote a unquote -----
;; Pro LISPové jazyky je dále typická konstrukce listů pomocí "quotes"

#; '(1 2 3)

;; Technicky toto odpovídá volání speciální funkce quote
#; (quote (1 2 3))
;; Apostrof ' je zkratka pro aplikaci této funkce.

;; Cvičení:
;; Zapište následující listy pomocí konstruktoru cons
#; (list "John" "Adam" "Julia")
#; '("Josh" "Paula" "Elisa")



;; Zapište následující listy pomocí funkce list
#; (cons "Francis" (cons "Antoine" '()))
#; '("Astrid" "Alanna" "Dean")



;; Zapište následující listy pomocí quotes
#; (cons "Noelle" (cons "Adrian" '()))
#; (list "Rose" "Evelyn" "Mia")



;; Pomocí funkce list můžeme do listu vložit výsledky vyhodnocování výrazů a funkcí
(define x 20)
#; (list (+ 1 1) (add1 5) x)

;; Pokud se o to samé pokusíme pomocí quotes, dostaneme odlišný výsledek
#; '((+ 1 1) (add1 5) x)
;; Funkce se nevyhodnotí, místo toho ale máme hodnoty se kterými jsme se ještě
;; nesetkali!

#; '+
#; 'add1
#; 'x

;; Jedná se o tzv. symboly - dynamické internované hodnoty.
;; Používají se například při implementacích FSM namísto stringů

; DoorState is one of:
; - 'open
; - 'closed
; - 'locked

;; Všimněte si také, že
#; '((1 2 3) (4 5 6))
;; vytváří list listů.

;; Do quote tedy nelze vložit konstanta nebo výraz.
;; Místo toho ale můžeme využít quasiquote a unquote.

;; Quasiquote se na první pohled chová stejně jako quote
#; `(1 2 3 x)

;; V quasiquote ale můžeme použít unquote ,
#; `(1 2 3 ,x 50 ,(add1 55))



;; ----- X-Expressions a HTML -----
(require 2htdp/web-io)

;; HTML je jeden z hlavních jazyků používaných pro tvorbu webových stránek.
;; Když otevřete nějakou webovou stránku, prohlížeč ji nejprve vykreslí na
;; základě HTML kódu který obdrží od serveru.
;; Velká část webových stránek pak funguje tak, že server doplňí nutné informace
;; do šablony a výsledek odešle klientovi.

;; Pomocí quotes a quasiquotes dokážeme zapsat takzvané X-Expressions - výrazy
;; které odpovídají valdiním HTML elementům a můžeme tak tvořit jednoduché webové
;; templates přímo v prostředí našich výukových jazyků.

;; Pro překlaz z X-Expressions na HTML použijeme knihovnu web-io

;; Modelový příklad: osobní webová stránka
(define (my-web-page author title)
  `(html
    (head
     (title ,title))
    (body
     (h1 ,title)
     (p "Vítejte na stránce kterou jsem vytvořil já, " ,author "."))))

#; (show-in-browser (my-web-page "Dan" "Má webová stránka"))
     


;; ----- Unquote Splice -----

;; Někdy ale potřebujeme aby unquote který vytváří list "vnořil"
;; hodnoty listu

;; Příklad:
;; Chtěli bychom vytvořit paragraf obsahující čísla od min do max

; Number Number -> List-of-String
(check-expect (numbers 0 0) '("0"))
(check-expect (numbers 0 1) '("0" "1"))
(check-expect (numbers 1 6) '("1" "2" "3" "4" "5" "6"))
; Vytvoří list string čísel od min do max
(define (numbers min max)
  (if (= min max)
      (cons (number->string max) '())
      (cons (number->string min) (numbers (add1 min) max))))

; List-of-Numbers -> X-Expression
(define (numbers-page-wrong min max)
  `(html
    (head
     (title "Numbers"))
    (body
     (p ,(numbers min max)))))

#; (show-in-browser (numbers-page-wrong 0 6))
;; Toto ale nefunguje! Potřebovali bychom aby paragraf p vypadal
#; '(p "0" "1" "2" "3" "4" "5" "6")

;; Toho můžeme dosáhnout pomocí unquote-splicing
(define (numbers-page min max)
  `(html
    (head
     (title "Numbers"))
    (body
     (p ,@(numbers min max)))))

#; (show-in-browser (numbers-page 0 6))
;; Modelový příklad: filmová databáze na webu

(define-struct movie [name year rating])
; Movie je struct
#; (make-movie String Number Number)


(define top-movies (list (make-movie "Vykoupení z věznice Shawshank" 1994 95.3)
                         (make-movie "Forrest Gump" 1994 94.4)
                         (make-movie "Zelená míle" 1999 92.9)
                         (make-movie "Sedm" 1995 92.4)
                         (make-movie "Přelet nad kukaččím hnízdem" 1975 92.4)))

; Movie -> X-Expression
(define (movie-row movie)
  `(tr
    (td ((style "padding: 2px 4px")) ,(movie-name movie))
    (td ((style "padding: 2px 8px;")) ,(number->string (movie-year movie)))
    (td ((style "padding: 2px 8px;")) ,(number->string-digits (movie-rating movie) 2))))

; List-of-Movie -> List-of-X-Expression
(define (movie-rows movies)
  (cond [(empty? movies) '()]
        [(cons? movies) (cons (movie-row (first movies))
                              (movie-rows (rest movies)))]))

; List-of-Movie -> X-Expression
(define (movie-table movie-list)
  `(table ((border "1"))
    (tr (th "Film") (th "Rok") (th "Rating"))
    ,@(movie-rows movie-list)))

; String List-of-Movie -> X-Expression
(define (movie-page title movie-list)
  `(html
    (head
     (title ,title))
    (body
     (h1 ,title)
     ,(movie-table movie-list))))

#; (show-in-browser (movie-page "Top filmy" top-movies))
