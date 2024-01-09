;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |02|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Strukturní (kompozitní) typy

;; Zatím jsme používali pouze velmi omezenou množinu datových typů
;; Pracovali jsme s
;; - String
;; - Number
;; - Image
;; - Boolean

;; Pro programování ale potřebujeme reprezentovat složitější data

;; - V počítačové hře:
;;   Pozice hráče, pozice nepřátel, úkol pro hráče (zadání, průběh a odměna)

;; - V aplikaci adresáře kontaktů:
;;   Reprezentace kontaktu - jméno, adresa, mobilní telefon, pracovní telefon

;; - V aplikaci pro kontrolu inventáře skladu:
;;   ID, jméno a počet momentálně naskladněných kusů, umístění ve skladu


;; Pro reprezentaci složitějších dat používáme strukturní typy - data skládající se
;; z více "primitivních" dat

;; V BSL máme některé strukturní typy předem definované - například posn - 2D souřadnice
;; 2D Pozice se skládá ze dvou primitivních částí dat - souřadnice x a souřadnice y.

;; Data typu posn vytváříme pomocí konstruktoru make-posn

(define pos1
  (make-posn 3 4))

;; Se strukturními typy pak pracujeme stejně jako s jinými datovými typy, potřebujeme ale
;; přístup k datům schovaným uvnitř - selektory
#;(posn-x pos1)
#;(posn-y pos1)

;; Dále máme predikát, který určuje zda jsou nějáká data strukturní typ posn
#;(posn? pos1)
#;(posn? "not a posn")

;; Dále můžeme se strukturním datovým typem pracovat stejně jako jsme pracovali s jinými daty
;; Příklad - Funkce určující euklidovskou vzdálenost od středu souřadného systému (0, 0)
(define (distance-from-0 pos)
  (sqrt (+ (sqr (posn-x pos))
           (sqr (posn-y pos)))))



;; Vlastní strukturní typy definujeme pomocí define-struct.
;; Definice posn vypadá následovně:
#;(define-struct posn [x y])

;; Obecně je definice strukturního typu následující
#;(define-struct JménoStrukturníhoTypu [JménoPole ...])

;; Data obsažená ve strukturním typu jsou uložena v tzv. polích - v případě posn máme pole x a pole y

;; Definice strukturního typu pro záznam člověka
(define-struct person [first-name surname year-born nationality])

;; Definice strukturního typu pro databázi filmů
(define-struct movie [title director year])

;; define-struct zajistí definici konstruktoru pro náš strukturní datový typ
(define CLINT-EASTWOOD
  (make-person "Clint" "Eastwood" 1930 "USA"))

(define DANNY-BOYLE
  (make-person "Danny" "Boyle" 1956 "England"))

;; a strukturní typ může obsahovat ve svých polích další strukturní typy
(define GRAN-TORINO
  (make-movie "Gran Torino" CLINT-EASTWOOD 2008))

(define TRAINSPOTTING
  (make-movie "Trainspotting" DANNY-BOYLE 1996))


;; Dále define-struct zajistí selektory pro jednotlivá pole
#;(person-surname DANNY-BOYLE)
#;(person-year-born CLINT-EASTWOOD)

#;(movie-title TRAINSPOTTING)
#;(person-surname (movie-director GRAN-TORINO))

(define (movie-info m)
  (string-append
   (movie-title m) ", "
   (person-first-name (movie-director m)) " " (person-surname (movie-director m)) ", "
   (number->string (movie-year m))))

#; (movie-info GRAN-TORINO)

;; define-struct take vytvoří predikát pro náš strukturní datový typ
#;(movie? GRAN-TORINO)
#;(movie? CLINT-EASTWOOD)
#;(person? CLINT-EASTWOOD)

;; --- CVIČENÍ ---

;; Určete na jakou hodnotu se redukuje výraz
#;(person-nationality
   (movie-director
    (make-movie "Seven Samurai"
                (make-person "Akira" "Kurosawa" 1910 "Japan")
                1954)))

;; -- ------- ---
