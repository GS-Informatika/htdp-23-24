;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |02|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ---------------- List (seznam) ----------------

;; Implementován jako "linked list" (spojový seznam)

;; -----------------------------------------------

;; Inventář "primitivů" k listům

#; '() ; Empty list
#; empty? ; Predikát který rozpozná empty list
#; cons ; Checked konstruktor struktur se dvěma polemi (druhé pole obsahuje list)
#; (cons "first" (cons "first of rest" '()))
#; first ; Selektor posledního přidaného prvku do listu
#; rest ; Selektor "zbytku" listu ("druhého pole")
#; cons? ; Predikát pro rozpoznání instancí (cons ...)

;; -----------------------------------------------

;; ----- Definice rekurzivního datového typu -----

; ListOfNames is one of
; - '()
; - (cons String ListOfNames)

; ------------------------------------------------

;; Cvičení - vytvořte list obsahující čísla od 0 do 6 (včetně) v libovolném pořadí.




;; Cvičení - nadesignujte funkci names->list která ze dvou jmen (String) vytvoří list,
;; který tyto jména obsahuje.




;; Cvičení - nadesignujte funkci, append-two-names která připojí dvě jména do
;; již existujícího listu




;; Diskuze - jak pracovat s listy (a dalšími self-referencing daty)?
;; Modelový příklad - Design funkce contains-john?

; ListOfNames -> Boolean
; Determines if "John" is in the list-of-names
#;(check-expect (contains-john? '()) #false)
#;(check-expect (contains-john? (cons "John" (cons "James" '()))) #true)
#;(check-expect (contains-john? (cons "James" (cons "John" '()))) #true)
#;(check-expect (contains-john? (cons "James" (cons "Anna" '()))) #false)
(define (contains-john? list-of-names)
  ...)



;; Při designu můžeme "přeložit" definice dat na definici funkce:

;; +-------------------------------+----------------------------------+
;; | Má definice dat má více       | Vzor musí obsahovat cond         |
;; | podtříd (možností)?           | klauzuli pro každou možnost      |
;; +-------------------------------+----------------------------------+
;; | Jak se možnosti podtříd liší? | Rozdíly použijeme k definici     |
;; |                               | predikátů pro jednotlivé větve   |
;; +-------------------------------+----------------------------------+
;; | Obsahuje nějáká možnost       | Přidáme do vzoru příslušné       |
;; | strukturní typ?               | selektory                        |
;; +-------------------------------+----------------------------------+
;; | Je definice dat               | Formulujeme "přirozenou" rekurzi |
;; | sebe-referující?              | ve vzoru                         |
;; +-------------------------------+----------------------------------+


;; Ukázky příkladů pro nerekurzivní větve cond klauzule nám rovnou říkají
;; jak je máme definovat!


;; Cvičení - nadesignujte funkci alice-count která spočítá počet
;; stringů "Alice" v ListOfNames




;; Cvičení - nadesignujte funkci how-many která spočítá počet prvků v
;; libovolném listu




;; Cvičení - nadesignujte datový typ pro list čísel




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




;; Rekurzivní datové typy se neváží jen k seznamům - podobnou strukturu jako
;; seznamy mohou mít například přirozená čísla

; Nat is one of
; - 0
; - (add1 Nat)

;; Této definici se říká Peanova konstrukce. Číslu (add1 _) se říká "následovník"
;; (successor - succ(x))

;; Funkce add1 slouží jako konstruktor nových dat (stejně jako cons u listů)

;; Diskuze - Co je selektor rekurzivních dat? (obdoba rest u listu)


;; Pro sčítání Peanových čísel platí 
;; a + 0 = a
;; a + succ(x) = succ(a + x) ==> a + succ(x) = succ(a) + x

;; Nyní napíšeme funkci pro součet podle předpisu na levé straně implikace

; Nat Nat -> Nat
; Sums two Nats
(define (nat-add a b)
  ...)


;; A pomocí předpisu na pravé straně implikace
(define (nat-add2 a b)
  ...)

;; Vyhodnoťme následující výrazy pomocí stepperu a porovnejme

#;(nat-add 3 5)
#;(nat-add2 3 5)

;; nat-add2 má lepší prostorovou složitost - konstantní
;; Diskuze - proč?

;; Druh rekurze s konstantní prostorovou složitostí je velmi důležitý
;; Říká se mu "tail call rekurze" a některé překladače tento typ rekurze umí
;; velmi dobře optimalizovat (včetně používaných překladačů jazyka C)
