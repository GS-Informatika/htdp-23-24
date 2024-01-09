;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |01|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;; --- OPAKOVÁNÍ ---

;; If podmínka má tvar
#;(if VýrazPodmínky VýrazKdyžTrue VyýrazKdyžFalse)

;; Kondicionál má tvar
#;(cond
    [VýrazPodmínky1 VýslednýVýraz1]
    [VýrazPodmínky2 VýslednýVýraz2]
    ...
    [VýrazPodmínkyN VýslednýVýrazN])

;; Případně
#;(cond
    [VýrazPodmínky1 VýslednýVýraz1]
    ...
    [VýrazPodmínkyN VýslednýVýrazN]
    [else VýrazProVšechnyOstatníPřípady])

(define (first-negative-value x y)
  (cond
    [(< x 0) x]
    [(< y 0) y]
    [else #false])) ;; "Fallback" - pokud je x a y kladné, funkce vrátí #false

    
;; Predikát je funkce, která klasifikuje data - vrací pravdivostní hodnotu
;; (true nebo false) na základě vstupních dat

#;(odd? 3)
#;(string-lower-case? "abC")


;; --- PROCVIČOVÁNÍ ---

(require 2htdp/image)
(require 2htdp/universe)
;; V minulých lekcích jsme si ukázali funkci
#;(animate ...)

;; Animovali jsme volný pád tečky pomocí následující funkce:
#;(define (picture-of-dot param)
  (place-image (circle 5 "solid" "red")
               50 (sqr param) ;; funkce sqr vrací druhou mocninu čísla
               (empty-scene 100 300)))

;; Vaším úkolem bude vytvořit stejnou animaci, odehrávající se na plátně o šířce WIDTH
;; a výšce HEIGHT s kroužkem CIRCLE.
;; Jakmile se kroužek dotkne spodního okraje scény zastaví se - nebude se dále pohybovat.
;; Doplňte funkci circle-height (která určuje výšku kroužku v animaci), aby animace probíhala podle zadání.
(define WIDTH 100)
(define HEIGHT 300)
(define CIRCLE (circle 5 "solid" "red" ))
(define SCENE (empty-scene WIDTH HEIGHT))

(define (circle-height t)
  ...)

(define (circle-fall t)
  (place-image
   CIRCLE
   (/ WIDTH 2)
   (circle-height t)
   SCENE))


#;(animate circle-fall)
;; --- ------- ---

;; Napište funkci classify-string klasifikující textový řetězec následujícím způsobem
;; Pokud je string "lowercase" (obsahuje pouze malá písmena), funkce vrátí textový řetězec "lowercase".
;; Pokud je string "uppercase" (obsahuje pouze velká písmena), funkce vrátí textový řetězec "uppercase".
;; Pokud string obsahuje pouze číslice (je "numerický"), funkce vrátí hodnotu "numeric".
;; Ve všech ostatních případech funkce vrátí hodnotu #false



;; --- ------- ---
