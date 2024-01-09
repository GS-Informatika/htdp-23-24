;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |03|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Uživatelská interakce - vstup a výstup

;; Naše programy zatím pracovaly pouze s daty přímo dostupnými v kódu - definovali jsme konstanty a
;; aplikovali na ně funkce. Při používání programů ale chceme určitou interakci - chceme dovolit uživateli
;; aby vložil svá data a program zvládl pracovat na nich. Nejdříve si ukážeme nejjednodušší typ interaktivních
;; programů - "batchové" programy
;; Tyto programy vezmou uživatelský vstup, provedou na něm operace ("výpočet" - ne nutně matematický!) a vrátí
;; výsledek

;; Budeme využívat batch-io teachpack pro abstrakci nad operacemi vstupu a výstupu programu
(require 2htdp/batch-io)

;; Tento teachpack nám poskytuje funkce pro zapisování a čtení ze souborů a standardního vstupu/výstupu
#;(write-file "ukazka1.txt" "Tento text se uloží do souboru ukazka1.txt ve složce této lekce.")
#;(read-file "ukazka1.txt")

;; --- VYZKOUŠEJTE ---
;; Několikrát spusťte následující kód
#;(write-file "sometext.txt" "TEXT")

;; Co je poté obsahem souboru sometext.txt?

;; --- ----------- ---

;; Kromě přímého ukládání do souborů a čtení ze souborů můžeme využít standardní vstup (stdin)
;; a standardní výstup (stdout)
;; Využijeme speciální "tokeny" (symboly) 'stdin a 'stdout místo jména souboru

#;(write-file 'stdout "Výstup programu")
#;(read-file 'stdin)

;; Standardní vstup a výstup je daný momentálním kontextem ve kterém pracujeme.

;; U read-file ze stdin musíme v DrRacket prostředí kliknout na tlačítko "EOF" pro vyhodnocení.
;; Jedná se o speciální signál operačního systému, který označuje konec souboru (v tomto případě
;; konec vstupu ze stdin). Funkce read-file čte vstup dokud nedostane tento signál.

#;(write-file 'stdout
            (string-upcase (read-file 'stdin)))

;; Napišme jednoduchý program který bude převádět teplotu ze stupňů Celsius na hodnotu v Kelvinech
(define ABSOLUTE-ZERO-CELSIUS 273.15)

(define (C->K celsius)
  (+ celsius ABSOLUTE-ZERO-CELSIUS))

(define (read-number file)
  (string->number (read-file file)))

(define (write-number file number)
  (write-file file
              (number->string number)))

(define (convert.v1 file-in file-out)
  (write-number file-out
                (C->K (read-number file-in))))

;; Zkusme program rozšířit na více konverzí hodnot teploty - mezi °C, K a F
(define (K->C kelvin)
  (- kelvin ABSOLUTE-ZERO-CELSIUS))

(define (C->F celsius)
  (+ 32 (* 9/5 celsius)))

(define (F->C farenheit)
  (* 5/9 (- farenheit 32)))

(define (K->F kelvin)
  (C->F (K->C kelvin)))

(define (F->K farenheit)
  (C->K (F->C farenheit)))

;; Program bude očekávat 4 znaky určující konverzi a zbytek souboru hodnotu ke konverzi
;; K->F25

(define (convert-using function-name number)
  (cond [(not (number? number)) #false] ;; number není number - vracíme false
        [(string=? function-name "C->K") (C->K number)]
        [(string=? function-name "C->F") (C->F number)]
        [(string=? function-name "K->C") (K->C number)]
        [(string=? function-name "K->F") (K->F number)]
        [(string=? function-name "F->C") (F->C number)]
        [(string=? function-name "F->K") (F->K number)]
        [else #false]))

(define (convert-from-text text)
  (convert-using (substring text 0 4)
                 (string->number (substring text 4))))

(define (write-conversion file maybe-number)
  (write-file file (if (number? maybe-number)
                       (number->string maybe-number)
                       "Konverze se nepovedla!")))

(define (convert.v2 file-in file-out)
  (write-conversion file-out
                    (convert-from-text (read-file file-in))))
