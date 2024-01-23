;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |01|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ------ OPAKOVÁNÍ ------

;; Definice datového typu - aliasy typů s významem, enumerace, interval, itemizace, strukturní typ

;; Příklady aliasu datových typu - pouze komentář:

; Balance is a Number
; Represents money balance of a player


; Health is a Number
; Represents health of a player


;; Enumerací vytváříme datové typy které obsahují právě jednu hodnotu z výčtu.


; PlayerClass is one of the following Strings:
; - "MAGE"
; - "WARRIOR"
; - "ARCHER"


;; Definice strukturního typu zavádí definici datového typu

(define-struct defense [melee ranged magic])
; Defense is a struct
#; (make-defense (Number Number Number))
; Represents defense against melee, ranged and magic damage



;; Strukturní typ si navíc nese "runtime" informaci (predikát strukturního typu)
;; informaci například o Health nebo Balance nemáme - za běhu programu víme že máme pouze číslo
;; Strukturní typ můžeme použít i pro uložení jediné informace + informace o typu


(define-struct magic-attack [damage])
; MagicAttack is a struct
#; (make-magic-attack Number)
; Represents magic attack

(define-struct ranged-attack [damage])
; RangedAttacj is a struct
#; (make-ranged-attack Number)
; Represents ranged attack

(define-struct melee-attack [damage])
; MeleeAttack is a struct
#; (make-melee-attack Number)
; Represents close combat attack



;; Interval je omezení spojitého typu (například Number) na nekonečný subset


; MovementSpeed is a Number in the interval
; - from 0.1 to 1.8



;; Itemizace dovoluje kombinovat již zavedené typy a hodnoty - určuje, že hodnota bude jeden z
;; typů nebo hodnot ve výčtu


; Attack is one of
; - MagicAttack
; - RangedAttack
; - MeleeAttack



;; Takové definice pak můžeme využít

(define-struct weapon [name attack])
; Weapon is a struct
#; (make-weapon [String Attack])
; Represents a weapon wtih name that does an attack.


(define-struct player [name health defense speed weapon balance])
; Player is a struct
#; (make-player String Health Defense MovementSpeed Weapon Balance)
; Represents a player with health HP, defense agains attack, speed, equipped with weapon and
; having savings of balance



;; Typy nám pomáhají říct která data můžeme použít ve funkcích
;; Funkce označujeme "SIGNATUROU" (v BSL ve formě komentáře) určující na hodnoty jakých typů
;; se funkce může aplikovat a hodnotu jakého typu vyprodukuje.



;; Funkce
#; string-length
;; má následující signaturu:

; String -> Number

;; To nám říká, že funkci můžeme aplikovat na jeden String a tato aplikace vyprodukuje Number (číslo).
#;(string-length "abc")
#;(string-length "abcd")



;; Funkce
#; string-downcase
;; má následující signaturu:

;; String -> String

;; Funkci tedy můžeme aplikovat na jeden String a tato aplikace vyprodukuje String.
#;(string-downcase "ABCD")
#;(string-downcase "AbCd")



;; Cvičení:

;; 1) Jakou signaturu má funkce
#; string-number

;; 2) Jakou signaturu má funkce
#; posn-x

;; 3) Jakou signaturu má predikát
#; player?



;; Když píšeme programy, je vhodné začít s definicí datových typů - ujasníme si co potřebujeme, jak vypadají naše data

;; Dále využijeme analýzu - propojení vstupu a výstupu - k napsání potřebných kroků, abychom se dostali od vstupu do programu
;; až k požadovanému výstupu. Pro každý mezikrok budeme mít funkci, která jej zařídí.
;; Při psaní funkcí nejprve napíšeme signaturu, účel a hlavičku.

;; Příklad - chceme programem určit nový stav hráče na kterého útočí jiný hráč. Za každou obranu se sníží útok o 1.

;; Nejprve definice dat
(define player1-weapon (make-weapon "Meč" (make-melee-attack 4)))
(define player2-weapon (make-weapon "Hůlka" (make-magic-attack 5)))

(define player1-defense (make-defense 2 1 1))
(define player2-defense (make-defense 1 2 1))

(define player1 (make-player "Player 1" 10 player1-defense 1 player1-weapon 42))
(define player2 (make-player "Player 2" 8 player2-defense 1.1 player2-weapon 35))

;; Operace kterou chceme má signaturu

; Player Player -> Player

;; Hlavička funkce je
#;(define (attack attacker defender) ...)


;; Uvnitř této funkce budeme potřebovat určit kolik životů ubere attacker defenederovi.


; Attack Defense -> Number
; How many lives are taken from defender with defense when attacked by attack

; health taken is always non-negative
#;(check-expect (health-taken (make-melee-attack 1) (make-defense 2 0 0)) 0)
#;(check-expect (health-taken (make-magic-attack 1) (make-defense 0 0 2)) 0)
#;(check-expect (health-taken (make-ranged-attack 1) (make-defense 0 2 0)) 0)
; defense reduces damage by one
#;(check-expect (health-taken (make-melee-attack 2) (make-defense 1 0 0)) 1)
#;(check-expect (health-taken (make-magic-attack 2) (make-defense 0 0 1)) 1)
#;(check-expect (health-taken (make-ranged-attack 2) (make-defense 0 1 0)) 1)
; defense of other type does not decrease damage
#;(check-expect (health-taken (make-melee-attack 1) (make-defense 0 1 1)) 1)
#;(check-expect (health-taken (make-magic-attack 1) (make-defense 1 1 0)) 1)
#;(check-expect (health-taken (make-ranged-attack 1) (make-defense 1 0 1)) 1)

#;(define (health-taken attack defense) ...)


;; Jakmile máme napsanou signaturu, hlavičku, účel a ukázky použití, můžeme funkci implementovat


; Attack Defense -> Number
; How many lives are taken from defender with defense when attacked with an attack

; health taken is always non-negative
(check-expect (health-taken (make-melee-attack 1) (make-defense 2 0 0)) 0)
(check-expect (health-taken (make-magic-attack 1) (make-defense 0 0 2)) 0)
(check-expect (health-taken (make-ranged-attack 1) (make-defense 0 2 0)) 0)
; defense reduces damage by one
(check-expect (health-taken (make-melee-attack 2) (make-defense 1 0 0)) 1)
(check-expect (health-taken (make-magic-attack 2) (make-defense 0 0 1)) 1)
(check-expect (health-taken (make-ranged-attack 2) (make-defense 0 1 0)) 1)
; defense of other type does not decrease damage
(check-expect (health-taken (make-melee-attack 1) (make-defense 0 1 1)) 1)
(check-expect (health-taken (make-magic-attack 1) (make-defense 1 1 0)) 1)
(check-expect (health-taken (make-ranged-attack 1) (make-defense 1 0 1)) 1)

(define (health-taken attack defense)
  (cond [(magic-attack? attack) (max 0 (- (magic-attack-damage attack) (defense-magic defense)))]
        [(ranged-attack? attack) (max 0 (- (ranged-attack-damage attack) (defense-ranged defense)))]
        [(melee-attack? attack) (max 0 (- (melee-attack-damage attack) (defense-melee defense)))]))



;; Dále budeme potřebovat funkci, která vytvoří nový stav obránce - ubere mu daný počet životů.
;; Signatura takové funkce může být například

; Number Player -> Player

;; A hlavičku
#;(define (take-health amount player) ...)



;; Očekávané chování funkce ukážeme v ukázce použití / testech. Můžeme si vytvořit pomocnou funkci pro
;; tvorbu testovacích dat
(define (make-test-player-with-health health)
  (make-player "test-player" health (make-defense 0 0 0) 1
               (make-weapon "test-weapon" (make-melee-attack 0)) 0))

#;(check-expect (take-health 0 (make-test-player-with-health 10))
                (make-test-player-with-health 10))
#;(check-expect (take-health 2 (make-test-player-with-health 10))
                (make-test-player-with-health 8))
#;(check-expect (take-health 5 (make-test-player-with-health 1))
                (make-test-player-with-health -4))

;; Tuto funkci poté můžeme implementovat. Celek bude vypadat následovně:

; Number Player -> Player
; Creates a new state of a player with amount of health subtracted
(check-expect (take-health 0 (make-test-player-with-health 10))
                (make-test-player-with-health 10))
(check-expect (take-health 2 (make-test-player-with-health 10))
                (make-test-player-with-health 8))
(check-expect (take-health 5 (make-test-player-with-health 1))
                (make-test-player-with-health -4))
(define (take-health amount player)
  (make-player (player-name player) (- (player-health player) amount)
               (player-defense player) (player-speed player)
               (player-weapon player) (player-balance player)))
               

;; Nyní zkusíme implementovat funkci attack, která bude základem našeho programu

;; Začneme se signaturou, účelem a hlavičkou - již známe

; Player Player -> Player
; Creates new state of a defender after being attacked by attacker
#;(define (attack attacker defender) ...)



;; Dále přidáme připravíme ukázky použítí a testování. Pro to si vytvoříme definice a pomocnou funkci,
;; která nám předvyplní hodnoty hráče

(define melee-defense (make-defense 1 0 0))
(define ranged-defense (make-defense 0 1 0))
(define magic-defense-strong (make-defense 0 0 6))

(define melee-weapon (make-weapon "test-melee" (make-melee-attack 4)))
(define ranged-weapon (make-weapon "test-ranged" (make-ranged-attack 4)))
(define magic-weapon (make-weapon "test-magic" (make-magic-attack 4)))

; String Defense Weapon -> Player
; Creates base player called name, with 10 health, 1 movement speed, 50 money balance
; and given defense and weapon
(define (make-base-player name defense weapon)
  (make-player name 10 defense 1 weapon 50))

;; Funkce make-base-player je "příliš jednoduchá" pro testování!



;; Testy funkce attack můžeme definovat například následovně:

#;(check-expect (attack (make-base-player "atacker1" melee-defense ranged-weapon)
                        (make-base-player "defender1" ranged-defense melee-weapon))
                (make-player "defender1" 7 ranged-defense 1 melee-weapon 50))
#;(check-expect (attack (make-base-player "attacker2" melee-defense melee-weapon)
                        (make-base-player "defender2" ranged-defense ranged-weapon))
                (make-player "defender2" 6 ranged-defense 1 ranged-weapon 50))
#;(check-expect (attack (make-base-player "attacker3" melee-defense magic-weapon)
                        (make-base-player "defender2" magic-defense-strong magic-weapon))
                (make-base-player "defender2" magic-defense-strong magic-weapon))



;; Nyní tedy uděláme inventář - máme funkci health-taken se signaturou (Attack Defense -> Number)
;; která nám řekne kolik poškození má obránce obdržet.

;; Dále máme funkce take-health se signaturou (Number Player -> Player)
;; která ubere hráči daný počet životů

;; Ve funkci pak máme dostupné dvě hodnoty typu Player - attacker a defender.
;; Defendera využijeme jednou pro získání hodnoty obrany a podruhé pro vytvoření nového stavu.
;; Attackera pouze pro získání hodnoty útoku

#;(define (attack attacker defender)
    (... (... attacker ... defender ...) ... defender ...))

;; Z typu Player můžeme vytvořit typ Attack pomocí kompozice selektorů
; Player -> Weapon
#;(player-weapon Player)
; Weapon -> Attack
#;(weapon-attack Weapon)

;; Dále můžeme vytvořit typ Defense pomocí selektoru
; Player -> Defense
#;(player-defense Player)

;; Nyní nám stačí využít kompozici funkcí a nechat se vést typovým systémem!



;; LIVE UKÁZKA

; Player Player -> Player
; Creates new state of a defender after being attacked by attacker
(check-expect (attack (make-base-player "atacker1" melee-defense ranged-weapon)
                      (make-base-player "defender1" ranged-defense melee-weapon))
              (make-player "defender1" 7 ranged-defense 1 melee-weapon 50))
(check-expect (attack (make-base-player "attacker2" melee-defense melee-weapon)
                      (make-base-player "defender2" ranged-defense ranged-weapon))
              (make-player "defender2" 6 ranged-defense 1 ranged-weapon 50))
(check-expect (attack (make-base-player "attacker3" melee-defense magic-weapon)
                      (make-base-player "defender2" magic-defense-strong magic-weapon))
              (make-base-player "defender2" magic-defense-strong magic-weapon))
(define (attack attacker defender)
  (... (... attacker ... defender ...) ... defender ...))
