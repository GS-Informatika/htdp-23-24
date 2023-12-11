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


;; --- OPAKOVÁNÍ ---

;; Definujte funkci euclidean-distance
;; která vezme 2 argumenty x, y a vyhodnotí euklidovskou vzdálenost bodu (x, y) od (0, 0)
;; Euklidovskou vzdálenost spočítáte pomocí Pythagorovy věty



;; --- --------- ---


;; Kromě čísel (Number) a jejich aritmetiky máme i jiné typy a jejich příslušnou aritmetiku
;; - String
;; - Image


;; --- CVIČENÍ ---

;; Otevřete dokumentaci Racketu (F1), vyhledejte dokumentaci pro Beginning Student (zadejte do vyhledávání).
;; Najděte v dokumentaci alespoň 4 funkce, které vrací datový typ String.
;; Dále najděte alespoň 4 funkce, které mají datový typ String jako argument.
;; Zkuste pro každou funkci kterou si vyberete krátce vlastními slovy popište co dělá



;; --- ------- ---

;; Nyní se podíváme na datový typ Boolean
#;#true
#;#false

;; S Booleany jsme se již setkali ve funkci
#;(string->number "non-numeric string")
;; která vrátí
#; #false
;; pro argumenty které nelze převést


;; Operace s booleany

;; Vsuvka - všechny možné operace a booleovské algebry

;; Unární - berou 1 argument

;; not - převrací hodnotu argumentu
#;(not #true)


;; Binární - berou 2 argumenty
(define left #true)
(define right #true)

;; or - #true pokud alespoň 1 argument je #true
#;(or left right)

;; and - #true pokud všechny argumenty jsou #true
#;(and left right)

;; Booleany využíváme při rozhodování - větvení kódu (branching)
;; Výraz if - podmíněný výraz

(define sunny #true)
(define accessory
  (if sunny
      "sunglasses" ; Pokud je sunny #true výraz (if ...) se vyhodnotí na "sunglasses"
      "umbrella")) ; Pokud je sunny #false výraz (if ...) se vyhodnotí na "umbrella"

;; Porovnávání čísel vede na booleany
#;(< 1 2) #;#true
#;(< 5 1) #;#false
#;(= 4 4) #;#true
#;(>= 10 5) #;true
#;(>= 5 5) #;true
#;(>= 4 5) #;false

(define warm-treshold-celsius 39)
(define (water-status temperature-celsius)
  (if (>= temperature-celsius warm-treshold-celsius)
      "warm"
      "not warm"))

;; Občas potřebujeme porovnat více možností - vnořování if výrazůnení příliš přehledné!
(define (signum-bad x)
  (if (> x 0)
      1
      (if (= x 0)
          0
          -1)))

;; Lepší je využít "cond" klauzuli - kondicionál
(define (signum x)
  (cond [(> x 0) 1]
        [(= x 0) 0]
        [else -1]))


