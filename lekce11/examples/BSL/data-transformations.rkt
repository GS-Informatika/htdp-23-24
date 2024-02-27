;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname data-transformations) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)


(define-struct work [name surname rate hours])
; Work je struktura:
#;(make-work String String Number Number)
; Reprezentuje výkaz práce za měsíc


(define-struct payslip [name surname pay])
; Payslip je struktura:
#;(make-payslip String String Number)
; Reprezentuje měsíční výplatnici člověka


; Work -> Payslip
; Převede výkaz práce na výplatnici
(check-expect (work->payslip (make-work "A" "B" 10 2)) (make-payslip "A" "B" 20))
(check-expect (work->payslip (make-work "C" "D" 5 7)) (make-payslip "C" "D" 35))
(define (work->payslip w)
  (make-payslip (work-name w) (work-surname w)
                (* (work-rate w) (work-hours w))))


; List-of-Work -> List-of-Payslip
; Převede list výkazů na list výplatnic
(check-expect (to-payslips '()) '())
(check-expect (to-payslips (cons (make-work "A" "B" 10 2)
                                 (cons (make-work "C" "D" 5 7) '())))
              (cons (make-payslip "A" "B" 20)
                    (cons (make-payslip "C" "D" 35) '())))
(define (to-payslips l-o-w)
  (cond [(empty? l-o-w) '()]
        [(cons? l-o-w) (cons (work->payslip (first l-o-w))
                             (to-payslips (rest l-o-w)))]))


; List-of-String -> Work
; Převede list 4 stringů (Name Surname Rate Hours) na typ Work
(check-expect (parse-work (cons "A" (cons "B" (cons "10" (cons "2" '())))))
              (make-work "A" "B" 10 2))
(check-expect (parse-work (cons "C" (cons "D" (cons "5" (cons "7" '())))))
              (make-work "C" "D" 5 7))
(check-error (parse-work (cons "X" (cons "Y" (cons "30" '())))))
(define (parse-work l-o-s)
  (if (= (length l-o-s) 4)
      (make-work (first l-o-s) (second l-o-s)
                 (string->number (third l-o-s))
                 (string->number (fourth l-o-s)))
      (error "parse-work requires a list of 4 strings, last two being numeric")))


; List-of-List-of-String -> List-of-Work
; Převede list 4-listů (Name Surname Rate Hours) na list hodnot typu Work
(check-expect (parse-all-work '()) '())
(check-expect (parse-all-work (cons (cons "A" (cons "B" (cons "10" (cons "2" '()))))
                                    (cons (cons "C" (cons "D" (cons "5" (cons "7" '()))))
                                          '())))
              (cons (make-work "A" "B" 10 2) (cons (make-work "C" "D" 5 7) '())))
(define (parse-all-work lst)
  (cond [(empty? lst) '()]
        [(cons? lst) (cons (parse-work (first lst))
                           (parse-all-work (rest lst)))]))


; Payslip -> String
; Vytvoří textovou reprezentaci hodnoty typu Payslip
(check-expect (payslip->string (make-payslip "A" "B" 200))
              "A B - 200€")
(check-expect (payslip->string (make-payslip "C" "D" 1000))
              "C D - 1000€")
(define (payslip->string p)
  (string-append (payslip-name p) " "
                 (payslip-surname p) " - "
                 (number->string (payslip-pay p)) "€"))


; List-of-Payslip -> List-of-String
; Z listu výplatnic vytvoří list textových reprezentací
(check-expect (stringify-payslips '()) '())
(check-expect (stringify-payslips (cons (make-payslip "A" "B" 200)
                                        (cons (make-payslip "C" "D" 1000) '())))
              (cons "A B - 200€" (cons "C D - 1000€" '())))
(define (stringify-payslips l-o-p)
  (cond [(empty? l-o-p) '()]
        [(cons? l-o-p) (cons (payslip->string (first l-o-p))
                             (stringify-payslips (rest l-o-p)))]))

; List-of-String -> String
; Spojí list stringů do jediného stringu separováného znakem sep
(check-expect (string-join "-" '()) "")
(check-expect (string-join " " (cons "A" '())) "A")
(check-expect (string-join "." (cons "A" (cons "B" '())))
              "A.B")
(check-expect (string-join " " (cons "C" (cons "D" (cons "E" '()))))
              "C D E")
(define (string-join sep l-o-s)
  (cond [(empty? l-o-s) ""]
        [(empty? (rest l-o-s)) (first l-o-s)]
        [(cons? l-o-s) (string-append (first l-o-s)
                                      sep
                                      (string-join sep (rest l-o-s)))]))

; String String -> String
; Z výkazů práce ve file-in vytvoří záznamy výplatnic ve file-out
; Vyprodukuje jméno souboru do kterého bylo zapsáno
(define (main file-in file-out)
  (write-file file-out
              (string-join "\n"
                           (stringify-payslips
                            (to-payslips
                             (parse-all-work
                              (read-words/line file-in)))))))
