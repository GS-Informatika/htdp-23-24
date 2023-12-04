;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |01|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; V levém dolním rohu zvolte programovací jazyk "Beginning Student"

;; Toto je oblast definicí

;; Stisknutím "Run" v pravém horním rohu zobrazíte interakční oblast

;; Zkusme do interakční oblasti vložit
#; "toto je interakční oblast"

;; Beginning Student Language (BSL) používá tzv. prefixovou notaci
;; Zkusme provést několik procedur
#;(+ 2 3) ; = 5

#;(+ 2 3 4 5 6) ; = 20

#;(* 3 3)

#;(- 4 2)


;; Programy se skládájí z výrazů - expression, které můžeme zapsat zde - v oblasti definic

;; Výrazy se vyhodnotí a výsledky vyhodnocení se zobrazí v oblasti interakcí

#;(sin 0)
#;(sqr 3)

;; Výrazy můžeme skládat pomocí vnoření (nesting) - 2 + (3 * 5)

#;(+ 2 (* 3 5))

;; Nesting je "neomezený" (limitace pouze počítačem), odpovídá kompozici funkcí z matematiky

#;(sin (+ 0.1 0.1)) ; sin(0.1 + 0.1)

;; Zkuste vyhodnotit následující výraz "v hlavě"
#;(+ 5
     (* 2 2 (+ 1
               (* 3 7))
        4)
     2)

;; Dokumentaci jednotlivých procedur nalezneme stisknutím F1 na vybraném výrazu

;; Aritmetika stringů - podobná jako u čísel, méně restriktivní
;; Dokážete říct které operace má společné?

#;(string-append "ab" "cd")
#;(string-append "cd" "ab")


;; Čísla - datový typ "Number" (později se setkáme s různými "subtypy" Number)
;; Text - datový typ "String"

;; (Number, +) tvoří grupu (+ operace je komutativní)
;; (String, string-append) tvoří monoid - nemá operaci inverze


;; Mezi typy lze převádět - mění se reprezentace v počítači!
#;(string->number "52")
#;(number->string 52)

#;(string->number "not a number")

;; #false a #true jsou hodnoty typu Boolean - aritmetiku Booleanů si ukážeme příště
;; Nyní nám stačí že odpovídají hodnotám ano/ne, případně pravda/nepravda

;; Aritmetiku můžeme provádět např. i na obrázcích (v BSL datový typ Image)
;; Přidejme "teachpack" 2htdp/image - menu Language > Add Teachpack
;; Můžeme také přidat pomocí kódu - "požadujeme rozšíření 2htdp/image"
(require 2htdp/image)

#;(circle 10 "solid" "red")
#;(rectangle 30 20 "outline" "blue")

#;(overlay (circle 5 "solid" "red")
           (rectangle 20 20 "solid" "blue"))

;; Tato operace opět "odpovídá" operaci +, není však komutativní!

;; Plátno pro datový typ Image
#;(place-image (circle 5 "solid" "green")
               50 80
               (empty-scene 100 100))



;; Funkce a jejich definice