;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 05-abstraction-of-functions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ------------------- ABSTRAKCE -------------------

;; Spousta funkcí, se kterými jsme se setkali, vypadá velmi podobně.
;; Při rekurzi vypadala většina funkcí téměř stejně, lišily se jen v
;; hodnotě pro base case a ve vyhodnocení rekurzivního kroku.

;; Tyto podobnosti jsou ale problematické - v kódu běžně vedou na repetici,
;; programátor zkopíruje existující kód a případně jej lehce upraví pro
;; požadovaný účel. Kopírování kódu sebou nese velký problém - kopírují se chyby!


(define-struct person [name age])
; Person is a struct
#;(make-person String Number)


; List-of-Person is one of:
; - '()
; - (cons Person List-Of-Person)


;; Jaký je rozdíl mezi následujícími funkcemi?


; List-of-Person -> Number
(define (count-james lop)
  (cond [(empty? lop) 0]
        [(cons? lop)
         (if (string=? (person-name (first lop)) "James")
             (add1 (count-james (rest lop)))
             (count-james (rest lop)))]))


; List-of-Person -> Number
(define (count-amy lop)
  (cond [(empty? lop) 0]
        [(cons? lop)
         (if (string=? (person-name (first lop)) "Amy")
             (add1 (count-amy (rest lop)))
             (count-amy (rest lop)))]))


; List-of-Person -> Number
(define (count-john lop)
  (cond [(empty? lop) 0]
        [(cons? lop)
         (if (string=? (person-name (first lop)) "John")
             (add1 (count-john (rest lop)))
             (count-john (rest lop)))]))


;; Kopírovaný kód se také hůře přizpůsobuje změnám požadavků
;; Jak bychom museli upravit předchozí funkce, pokud by se upravil požadavek
;; na započítávání lidí - přidání pole pro příjmení a započtení podle
;; křestního jména i příjmená?


;; Programátoři se snaží redukovat podobnosti v kódu.
;; Nejprve si tedy děláme "draft" programu, ve kterém se
;; snažíme najít podobnosti a následně draft upravit tak, abychom se jich
;; zbavili. Toho dosáhneme pomocí abstrakce.

;; Abstrakce funkcí pro počet lidí

; Person String -> Boolean
(define (is-named? person name)
  (string=? (person-name person) name))


; List-of-Person String -> Number
(define (named-person-count lop name)
  (cond [(empty? lop) 0]
        [(cons? lop) (if (is-named? (first lop) name)
                         (add1 (named-person-count (rest lop) name))
                         (named-person-count (rest lop) name))]))

;; Původní funkce jsou pak specializace abstrahované funkce


; List-of-Person -> Number
(define (count-amy lop)
  (named-persion-count lop "Amy"))


; List-of-Person -> Number
(define (count-james.v2 lop)
  (named-person-count lop "James"))



;; Cvičení:
;;   Zkuste vymyslet - jak provést abstrakci následujících funkcí?

; List-of-Strings -> Boolean
(define (contains-10-letter-string? l)
  (cond [(empty? l) #f]
        [(= (length (first l)) 10) #t]
        [else (contains-10-letter-string? (rest l))]))

; List-of-Strings -> Boolean
(define (contains-8-letter-string? l)
  (cond [(empty? l) #f]
        [(= (length (first l)) 8) #t]
        [else (contains-8-letter-string? (rest l))]))





;;   Popište rozdíly mezi funkcemi. Navrhněte abstrakci.

; List-of-Numbers -> List-of-Numbers
(define (add5/list l)
  (cond [(empty? l) '()]
        [else (cons (+ (first l) 5)
                    (add5/list (rest l)))]))

; List-of-Numbers -> List-of-Numbers
(define (add8/list l)
  (cond [(empty? l) '()]
        [else (cons (+ (first l) 8)
                    (add8/list (rest l)))]))

; List-of-Numbers -> List-of-Numbers
(define (multiply5/list l)
  (cond [(empty? l) '()]
        [else (cons (* (first l) 5)
                    (multiply5/list (rest l)))]))

;; Pro abstrakci nad všmi třemi funkcemi najednou ale musíme zajít trochu dále.


; Operation is one of
; - 'multiply
; - 'add

; List-of-Numbers Operation Number -> List-of-Numbers
(define (operation/list op l num)
  (cond [(empty? l) '()]
        [(eq? op 'multiply) (cons (* (first l) num)
                                  (operation/list op
                                                  (rest l)
                                                  num))]
        [(eq? op 'add) (cons (+ (first l) num)
                             (operation/list op
                                             (rest l)
                                             num))]))

;; Zdá se ale, že jsme jen "přesunuli" opakování dovnitř funkce!
;; Toto tedy není ten nejlepší přístup!

;; Zkusme to ještě jednou! Definujme funkci ve tvaru

; ??? List-of-Number Number -> List-of-Number
(define (operation/list.v2 op l num)
  (cond [(empty? l) '()]
        [else (cons (op (first l) num)
                    (operation/list.v2 op (rest l) num))]))


;; STOP! Zkuste vysvětlit, jaký datový typ má parametr op.
;; Všimněte si jak jej používáme! Má tato definice smysl?

;; V rámci BSL/BSL+ tato definice není sémanticky správná.
;; My se ale nyní přesuneme do ISL (Intermediate Student Language)
;; ve které je toto povoleno.

;; Vyzkoušejme - chceme filtrovat listy podle čísla
;; (vybrat sub-list menších/větších čísel než je nějáké číslo v parametru)

;; Vytvořme nejprve funkce smaller a larger

; Number List-of-Number -> List-of-Number
; Vybere čísla z lon která jsou menší než num
(define (smaller num lon)
  (cond [(empty? lon) '()]
        [(< (first lon) num) (cons (first lon)
                                   (smaller num (rest lon)))]
        [else (smaller num (rest lon))]))


; Number List-of-Number -> List-of-Number
; Vybere čísla z lon která jsou větší než num
(define (larger num lon)
  (cond [(empty? lon) '()]
        [(> (first lon) num) (cons (first lon)
                                   (larger num (rest lon)))]
        [else (larger num (rest lon))]))


;; Nalezněte rozdíly v těchto funkcích a navrhněte abstrakci.
;; Abstrahovanou funkci pojmenujte extract.




;; Definujte funkce smaller.v2 a larger.v2 pomocí abstrahované funkce
;; extract




;; Nejen že je taková definice přehlednější a kratší,
;; ale že můžeme definovat mnohem více "specializovaných" funkcí

; List-of-Numbers Number -> List-of-Numbers
#; (define (equal lon num)
  (extract = lon num))

; List-of-Numbers Number -> List-of-Numbers
#; (define (equal-or-larger lon num)
  (extract >= lon num))


;; Za argument můžeme použít i vlastní funkci, která
;; bude mít správnou signaturu.

; Number Number -> Boolean
; Určí, jestli je (x*x) > c.
(define (sqr>? x c)
  (> (* x x) c))

; List-of-Numbers Number -> List-of-Numbers
#; (define (sqr-larger lon num)
  (extract sqr>? lon num))



;; Abstrahované funkce jsou ve výsledku užitečnější, než specializované!

;; Cvičení
; Infimum a supremum jsou funkce na množinách, které vybírají nejmenší a největší prvek celé množiny.


; NE-List-of-Numbers -> Number
; Nalezne nejmenší číslo v neprázdném listu
(check-expect (inf (list 3 2 7 1 5)) 1)
(check-expect (inf (list 5)) 5)
(define (inf l)
  (cond [(empty? (rest l)) (first l)]
        [else (if (< (first l) (inf (rest l)))
                  (first l)
                  (inf (rest l)))]))


; NE-List-of-Numbers -> Number
; Nalezne největší číslo v neprázdném listu
(check-expect (sup (list 3 2 7 1 5)) 7)
(check-expect (sup (list 5)) 5)
(define (sup l)
  (cond [(empty? (rest l)) (first l)]
        [else (if (> (first l) (sup (rest l)))
                  (first l)
                  (sup (rest l)))]))


;; Definujte funkci (pick-one op l) která bude abstrahovat tyto dvě funkce
;; Vyzkoušejte. Zkuste popsat, jak dlouho se výraz evaluuje v závislosti na
;; délce listu. Dokážete říct proč se funkce takhle chová?





;; Přepište původní funkce za použití funkcí (min x y) a (max x y).
;; Abstrahujte takto přepsané funkce do (pick-one.v2 op l).
;; Proč jsou tyto funkce "rychlejší"?




; -----------------------------------------------------------------------------

;; Efektivně jsme povýšili funkce na "first class citizens" (občany první třídy)
;; Můžeme definovat funkci a následně ji použít jako argument jiné funkce!
;; Funkce jsou HODNOTY (values)

;; Rozmyslete: jak vypadá datová definice typu pro funkce?
