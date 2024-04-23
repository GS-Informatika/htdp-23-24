;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 18-merge-sort) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Dalším generativně rekurzivním algoritmem je merge sort.
;; Jeho asymtotická složitost je stejná jako u quick sortu
;; O(n log(n))

;; Jeho princip spočívá v tom, že máme triviálně řešitelnou
;; úlohu (triviálně je v tomto kontextu odborní termín!)
;; seřazení prázdného listu nebo listu o jednom prvku.

;; Problém seřazení pak převedeme na problém jak "spojit"
;; dva již seřazené listy.

;; Abychom se dostali k triviálně řešitelnému problému,
;; rozdělíme list v rekurzivním kroku na poloviny.

; [List-of Number] -> [List-of Number]
; Seřadí list pomocí spojování seřazených listů (merge sort)
(check-expect (merge-sort '(80 60 70 50 30 40))
              '(30 40 50 60 70 80))
(check-expect (merge-sort '(1 4 2))
              '(1 2 4))
(check-expect (merge-sort '(5))
              '(5))
(check-expect (merge-sort '())
              '())
(define (merge-sort l)
  (local (; [List-of Number] [List-of Number] -> [List-of Number]
          ; Spojí dva seřazené listy tak, aby výsledek byl seřazený
          (define (merge xs ys)
            (cond [(empty? xs) ys]
                  [(empty? ys) xs]
                  [(< (first xs) (first ys))
                   (cons (first xs) (merge (rest xs) ys))]
                  [(>= (first xs) (first ys))
                   (cons (first ys) (merge xs (rest ys)))]))

          ; [T]: Nat [List-of T] -> [List-of T]
          (define (take n lst)
            (if (or (empty? lst) (= 0 n))
                '()
                (cons (first lst) (take (sub1 n) (rest lst)))))
          ; [T]: Nat [List-of T] -> [List-of T]
          (define (drop n lst)
            (if (or (empty? lst) (= 0 n))
                lst
                (drop (sub1 n) (rest lst))))

          (define half (ceiling (/ (length l) 2))))
    (cond [(or (empty? l) (empty? (rest l))) l] ; triviální případ
          [else (merge (merge-sort (take half l))
                       (merge-sort (drop half l)))])))


;; Generativní krok nemá žádnou spojitost se strukturou dat,
;; v hlavičce funkce bychom tedy měli ujasnit "jak"
;; funkce dosáhne svého výsledku.

;; Generativní rekurze tedy rozeznává dva typy problémů:
;; 1) triviálně řešitelné - dokážeme přímo určit výsledek
;; 2) netriviální - tyto problémy převádíme na menší subproblémy,
;;    které řešíme rekurzivně (dokud nedojdeme k
;;    triviálně řešitelnému problému) a výsledky následně
;;    zkombinujeme.

;; Dále jsme se také potkali s problémem "terminace".
;; Některé problémy pro určité vstupy nevygenerují žádný
;; výsledek, výpočet se nikdy neukončí - říká se, že
;; se funkce zacyklika, nebo je v nekonečném cyklu.

;; Při psaní generativních algoritmů bychom tedy měli
;; specifikovat, pro jaká data může k zacyklení dojít.
