;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 17-quick-sort) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; V některých případech existuje správný algoritmus, který
;; postupuje podle struktury dat, ale je výhodnější volit algoritmus
;; který přirozenou strukturu ignoruje.

;; Vzpomeňme si na insert sort

; [List-of Number] -> [List-of Number]
(define (sort> alon)
  (cond
    [(empty? alon) '()]
    [else
     (insert (first alon) (sort> (rest alon)))]))

(define (insert n l)
  (cond
    [(empty? l) (cons n '())]
    [else (if (>= n (first l))
              (cons n l)
              (cons (first l) (insert n (rest l))))]))

;; Tento algoritmus postupuje podle struktury a vždy vkládá první číslo v listu
;; "na místo kam přesně patří".

;; Hoareův quick-sort je pak odlišný algoritmus, který ignoruje strukturu listu
(define list1 (cons 6 (cons 5 (cons 8 (cons 12 (cons 1 '()))))))
;; a je "klasickou ukázkou" generativní rekurze. Generativní krok používá
;; strategii "divide and conquer" (rozděl a panuj), rozdějuje netriviální části
;; problému na dva menší (a blízké) subproblémy. Řešení těchto subproblémů pak
;; zkombinuje do celkového výsledku.

;; 1) Vybereme číslo z listu (např. první číslo) - pivot
;; 2) Rozdělíme list čísel k seřazení na list menších a větších čísel, než je pivot
;; 3) Seřadíme tyto sublisty pomocí quick-sortu
;; 4) Výsledky spojíme dohromady, pivot vložíme mezi dva seřazené sublisty

; [List-of Number] -> [List-of Number]
(check-expect (quick-sort< list1) '(1 5 6 8 12))
(check-expect (quick-sort< '()) '())
(check-expect (quick-sort< '(1 2)) '(1 2))
(define (quick-sort< lst)
  (cond
    [(empty? lst) '()]
    [else (local (
                  (define pivot (first lst))
                  (define larger (filter (λ (i) (> i pivot)) lst))
                  (define smaller (filter (λ (i) (< i pivot)) lst)))
            (append (quick-sort< smaller) (list pivot) (quick-sort< larger)))]))

;; Tento algoritmus naprosto ignoruje strukturu listu!
;; Rekurze obecně nepracuje na elementech které za sebou následují!

;; Procvičovací úloha:
;; Abstrahujte quick-sort funkci tak, aby brala za argument funkci [A]: (A A -> Bool) porovnávající
;; dva prvky a používala ji k filtrování listu

;; Zkuste navrhnout funkci, která vytvoří listy larger a smaller jedním průchodem listu.
;; Jako první navrhněte datovou strukturu, která může reprezentovat výsledek takové funkce.