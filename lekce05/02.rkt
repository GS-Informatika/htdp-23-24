;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |02|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; convert.v2 z předchozí části obsahoval několik funkcí, které byly správnou kompozicí
;; složeny do funkčního programu. Jednotlivé funkce musely být složeny správně, aby program fungoval
;; dle našeho očekávání. Postupně budeme budovat formalismus, který nám velmi pomůže s designem funkcí
;; v programu.

;; Pro psaní programů je důležité nejprve provést analýzu - měli byste být schopni určit relevantní
;; části problému a také části které můžete ignorovat. Je třeba uvědomovat si
;; 1) Co je vstupem do programu
;; 2) Co  je výstupem programu
;; 3) Jaká je relace mezi vstupem a výstupem
;; 4) Umí programovací jazyk (a knihovny) který chceme použít dobře reprezentovat data
;;    a operace které budeme pro řešení problému potřebovat?

;; Pokud programovací jazyk našho výběru neumí dané operace, bude na nás vyvinout vhodné funkce!

;; Ve chvíli kdy máme napsaný kód, je třeba jej testovat! Můžeme narazit na neočekávané chyby, které
;; je třeba opravit.

;; Je vhodné vyhnout se "garage programming" (bastlení - z německého basteln) - experimentování s kódem
;; do chvíle než funguje - takto vzniká "tech debt" (technický dluh)

;; Produkt programování by měl být doprovázen alespoň krátkou dokumentací - co software dělá, jaké
;; vstupy očekává. Dále by měl mít alespoň nějákou záruku funkčnosti.

;; Programy běžně nevytváříte pro sebe, ale pro ostatní programátory, kteří později budou opravovat chyby
;; nebo přidávat novou funkcionalitu. Občas se také stane, že si váš software i někdo spustí!

;; Většina programů je obrovská a komplexní kolekce funkcí - takové programy nelze napsat rychle
;; a v jednom člověku. Programátoři se na projektech střídají, klienti mění své požadavky,
;; programy obsahují chyby které je třeba opravovat. Velmi častý úkol programátora je
;; zjistit, jak funguje několik let starý kód a provést v něm úpravy. Aby to bylo možné,
;; je třeba psát kód systematicky.


;; ------- Designování funkcí -------

;; Program je předpis ve tvaru:
;; INFORMACE ----> DATA ----> VÝPOČET ----> DATA ----> INFORMACE

;; Informace jsou prvky v doméně se kterou pracujeme, data jsou naše reprezentace informací


;; Diskuze - jaký význam má tento predikát?
(define (some-predicate? number)
  (< (/ number 1.36) 4))


;; Bez znalosti na které doméně operuje nedokážeme určit - je třeba jej popsat!

;; Jedná se o podmínku pro klasifikaci lehké čtyřkolky podle koňské síly (dělení 1.36 převádí HP na kW, počet kW musí být menší než 4)


;; Protože je znalost, co data reprezentují (a jak je interpretovat) důležitá, budeme psát definice dat - komentáře, které
;; 1) pojmenovávají data
;; 2) říkají, jak daná data vytvořit (reprezentovat) v programu
;; 3) říkají, jak daná data interpretovat (převést je na informaci)

;; Ukázka:

; Temperature is a Number
; Represents temperature in degrees Celsius


(define-struct user [username password])
;; User is a structure
#; (make-user String String)
; User authentificated using username and password



;; Když máme definována naše data, můžeme designovat funkci. Pro to si zavedeme "recept" - design proces pro funkce

;; 1) Sepsání signatury, účelu a hlavičky funkce
;;    - Signatura udává jaká data funkce očekává jako vstupy a jaký typ dat vyprodukuje

;;        String -> Number

;;        Temperature -> String

;;        Number String Image -> Image

;;    - Účel je stručný komentář, kterým popisujeme co funkce dělá.
;;      Čtenář kódu by měl rozumět co funkce dělá bez toho, aby četl implementaci

;;    - Hlavička funkce je pak jednoduchá definice funkce ("stub"). Pro každou proměnnou na vstupu
;;      zvolíme vhodné jméno a hodnotu která má typ produkovaných dat použijeme jako tělo funkce.
#;      (define (f a-string) 0)

#;      (define (display-temperature temp) "0 °C")

#;      (define (g num str img) (empty-scene 100 100))

;; 2) Sepsání ukázek použití - sepíšeme jaký je očekávaný výstup pro námi vybraný (reprezentativní) vstup.
;;    Tuto část také použijeme pro testování pomocí výrazu check-expect
;;    Ukázka: funkce pro výpočet obsahu čtverce

#|
; Number -> Number
; computes the area of square with side len
(check-expect (area-of-square 2) 4)
(check-expect (area-of-square 7) 49)
(check-expect (area-of-square 0) 0)
(define (area-of-square len) 0)
|#

;; 3) Sepsání "inventáře" - v tomto kroku si uvědomíme, co máme dostupné na vstupu funkce (které proměnné)
;;    a co z nich musíme vypočítat. Tělo funkce nahradíme za "vzor" - template

#|
; Number -> Number
; computes the area of square with side len
(check-expect (area-of-square 2) 4)
(check-expect (area-of-square 7) 49)
(check-expect (area-of-square 0) 0)
(define (area-of-square len)
  (... len ...))
|#

;; 4) Implementace - nyní je teprve čas začít psát kód - výraz, který se provede v těle funkce

#|
; Number -> Number
; computes the area of square with side len
(check-expect (area-of-square 2) 4)
(check-expect (area-of-square 7) 49)
(check-expect (area-of-square 0) 0)
(define (area-of-square len)
  (sqr len))
|#

;; 5) Test - spuštěním kódu provedeme testy v check-expect výrazech a ujistíme se, že naše
;;    funkce vrací očekávané hodnoty


;; ------- Typové enumerace -------

;; Některá data připouští jen některé hodnoty - například světla na semaforu mají jen 3 možné stavy:
(define RED "RED")
(define YELLOW "YELLOW")
(define GREEN "GREEN")

;; Datový typ String je pro taková data příliš široký - String mohou být i jiné hodnoty.
;; Chceme tedy definovat užší datový typ - obsahuje pouze jednu z vybraných hodnot!

; TrafficLightState is one of:
; - "RED"
; - "YELLOW"
; - "GREEN"
; Represents the state of a traffic light

;; Enumerace se často vyhodnocují pomocí kondicionálů - pro každou možnost které může enumerace
;; nabývat bude (alespoň) jedna větev kondicionálu!


;; ------- Typové intervaly -------

;; Některá data nepřipouští konečný počet hodnot, hodnoty jsou ale i tak omezené - například
;; souřadnice X pixelu v obrázku img se nachází v intervalu [0, (image-width img)).

;; Takovému omezení se říká interval a data v tomto intervalu můžeme označit jménem typu.

; ImageXCoord is a Number in the interval
; - between 0 including and (image-width img) excluding
; Represents X coordinate of a pixel on image img


; BlinkInterval is a Number in the interval:
; - between 2 and 4 (both including)
; Represents duration of the on/off state of blinking light


;; ------- Typové itemizace -------

;; Kombinace enumerace a itemizace

; TrafficLightState.v2 is one of:
; - TrafficLightState
; - BlinkInterval
; Represents traffic light state. Data of BlinkInterval type
; represent a traffic light that is not working and the yellow
; light toggles on/off with given interval.


;; ------- Cvičení -------

;; Cvičení 1
; Napište funkci, která určí plochu kruhu o daném poloměru (radius). Využíjte všechny kroky
; receptu pro design funkcí



;; Cvičení 2
; Napište definici datového typu RPS, který bude představovat jedno z rozhodnutí při hře
; "Kámen, Nůžky, Papír" (Rock, Paper, Scissors).



;; Cvičení 3
; Napište definici hráče Kámen Nůžký Papír  která bude obsahovat
; jméno hráče a rozhodnutí co zahrál ("ROCK", "PAPER", "SCISSORS")
; Ke strukturnímu typu napište i jeho interpretaci podle ukázky výše



;; Cvičení 4
; Nadesignujte predikát (is-winner? player other-choice), která určí jestli hráč vyhrál proti other-choice typu RPS.
; Klasická pravidal RPS - ROCK vyhrává nad SCISSORS, SCISSORS vyhrává nad PAPER, PAPER vyhrává nad ROCK



;; Cvičení 5
; Napište funkci určující vítěze hry Kámen, Nůžky, Papír - funkce bude brát za argumenty 2 hráče
; (podle definice z předchozího cvičení) a vrátí jméno vítězného hráče. Pokud nevyhrál ani jeden,
; funkce vrátí #false. Použíjte predikát a definici z předchozích cvičení


