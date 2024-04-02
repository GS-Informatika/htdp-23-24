;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 11-trees) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; ------- Stromy -------

;; Nyní se seznámíme s typem dat, se kterým se v
;; "real-world problémech" běžně setkáte

;; Stromy jsou struktura propojující jednotlivé vrcholy
;; pomocí hran (orientovaných) tak, aby nevznikla
;; kružnice (cyklus)

;; Příkladem stromu je rodokmen

;; Datovým typem pro záznam rodokmenu pak může být

#; (define-struct child [father mother name born-year])
; Child je struktura:
#; (make-child Child Child String Nat)

;; Takový datový typ je ale nepoužitelný!

;; Diskuze - proč?




;; Na chvíli zanedbejme nemožnost zkonstruovat hodnotu
;; typu Child a předpokládejme, že již máme
;; hodnoty typu child: Karel a Anna
;; Jejich dítě Adam pak bude definováno jako
#; (define Adam
     (make-child Karel Anna "Adam" 1990))

;; Abychom mohli vytvořit hodnoty, potřebujeme "někde zastavit"
;; Stromy jsou rekurzivní datová struktura - stejně jako Listy
;; potřebují base case!

(define NP 'NO-PARENT)
(define-struct child [father mother name born-year])
; FT (zktratka pro FamilyTree) je jedno z:
;  - NP
#; (make-child FT FT String Nat)

; FT -> Boolean
; Určí jestli je child NP
(define (NP? child)
  (and (symbol? child)
       (symbol=? 'NO-PARENT child)))

;; Nyní můžeme definovat rodokmen!
(define Jan (make-child NP NP "Jan" 1896))

(define Josef (make-child NP NP "Josef" 1920))
(define Tereza (make-child NP NP "Tereza" 1925))
(define Jana (make-child NP NP "Jana" 1930))
(define Rudolf (make-child Jan NP "Rudolf" 1929))

(define Karel (make-child Josef Tereza "Karel" 1962))
(define Anna (make-child Jana Rudolf "Anna" 1965))
(define Klara (make-child Jana Rudolf "Klára" 1960))

(define Adam (make-child Karel Anna "Adam" 1990))

;; Abychom definovali funkci která zpracuje strom,
;; budeme postupovat stejně jako u listů

; FT -> ???
; ...
(define (funkce-FT ftree)
  (cond [(NP? ftree) ...]
        [(child? ftree)
         (... (funkce-FT (child-father ftree)) ...
          ... (funkce-FT (child-mother ftree)) ...
          ... (child-name ftree) ...
          ... (child-born-year ftree) ...)]))


;; Z takové template dokážeme vytvořit funkce pracující nad
;; stromy (pomocí doplnění do template a abstrakce a dalších
;; pozorování o tvaru dat)

;; Funkce která určí, jestli strom obsahuje člověka narozeného před
;; daným rokem

;; Number FT -> Boolean
;; Určí, jestli ftree obsahuje člověka narozeného před rokem year
(define (has-born-before year ftree)
  (cond [(NP? ftree) #false]
        [(child? ftree)
         (if (< (child-born-year ftree) year)
             #true
             (or (has-born-before year (child-father ftree))
                 (has-born-before year (child-mother ftree))))]))


;; Cvičení - napište pomocí template funkci, která určí počet
;; lidí ve FT narozených po daném roce.
;; Hint - co můžete říct o polích child-mother a child-father?





;; ---------------------------------------------------
