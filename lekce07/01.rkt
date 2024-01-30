;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |01|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; ----- Konečné automaty -----

;; Velká část programů lze nadesignovat jako FSM

;; Definujme si například program pro "automatické dveře".
;; Pokud příjde zákazník v obchodě před dveře, software v nich obdrží event.
;; Pokud jsou zavřené, musí se otevřít.
;; Pokud jsou po nějákou dobu od příchodu posledního zákazníka otevřené, musí se zavřít.
;; Tyto dveře lze ale také softwarem uzamknout.

;; FSM tedy vypadá takto:

;;            unlock            open
;;          -------->         -------->
;;   Locked            Closed            Open
;;          <--------         <--------
;;             lock             close


;; Podle FSM si můžeme zadefinovat datový typ představující stav

; DoorState is one of
; - "Locked"
; - "Closed"
; - "Open"
; Represents the state of the door
(define LOCKED "Locked")
(define CLOSED "Closed")
(define OPEN "Open")


;; Dále můžeme každý přechod mezi stavy reprezentovat vlastním typem


; DoorTransition is one of
; - "TUnlock"
; - "TLock"
; - "TOpen"
; - "TClose"
(define TUNLOCK "TUnlock")
(define TLOCK "TLock")
(define TOPEN "TOpen")
(define TCLOSE "TClose")


;; -----------------------------------------------------------------------

;; Cvičení - dokončete design funkce která aplikuje přechod na stav podle zadání FSM.
;; Pokud se pokusíme aplikovat přechod na stav na který aplikovat nelze,
;; funkce zachová původní stav.
;; Začněte s ukázkami použití

; DoorState DoorAction -> DoorState
; Acts on a door state with door action

(define (door-action s a)
  ...)

;; -----------------------------------------------------------------------

;; Abychom splnili definici zadání, musíme udělat úpravu definice dat.
;; Pro uzamčené a uzavřené dveře stačí string, otevřené dveře ale potřebují navíc informaci
;; za jak dlouho se mají samy uzavřít.

(define-struct open-door [time])
; OpenDoor is a struct
#; (make-open-door [Number])
; Represents open door with the information about remaining time (in ticks) to stay open.


; DoorState.v2 is one of
; - OpenDoor
; - "Locked"
; - "Closed"


;; -----------------------------------------------------------------------

;; Cvičení - napište funkci state=?, která porovná dvě hodnoty stavu DoorState.v2
;; Hodnota času v open-door se nemusí rovnat!

; DoorState.v2 DoorState.v2 -> Boolean
(define (state=? s1 s2)
  ...)


;; -----------------------------------------------------------------------


;; Cvičení - přepište funkci door-action aby odpovídala nové definici.
;; Zatím nebudeme řešit automatické uzavírání, pouze působení přechodu na stav.
;; Po přechodu na Open bude hodnota time nastavena na konstantu OPEN-TIME.
;; Začněte ukázkou použití.

(define OPEN-TIME 140)
(define OPEN-DOOR (make-open-door OPEN-TIME))



; DoorState.v2 DoorAction -> DoorState.v2
; Acts on a door state with door action

(define (door-action.v2 s a)
  ...)


;; -----------------------------------------------------------------------



;; Máme definovanou vnitřní logiku programu, teprve nyní můžeme řešit interakční logiku!

(require 2htdp/image)
(require 2htdp/universe)

; DoorState.v2 Key -> DoorState.v2
; Handles key events in door FSM application.
(define (handle-key s key)
  (cond [(key=? " " key) (door-action.v2 s TOPEN)]
        [(key=? "l" key) (door-action.v2 s TLOCK)]
        [(key=? "u" key) (door-action.v2 s TUNLOCK)]
        [(key=? "c" key) (door-action.v2 s TCLOSE)]
        [else s]))

; DoorState.v2 -> DoorState.v2
; Handles tick events in door FSM application.
(define (handle-door-tick s)
  (cond [(and (open-door? s) (= (open-door-time s) 0))
         (door-action.v2 s TCLOSE)]
        [(open-door? s) (make-open-door (sub1 (open-door-time s)))]
        [else s]))


(define LOCKED-DOOR-IMAGE (bitmap "locked.png"))
(define CLOSED-DOOR-IMAGE (bitmap "closed.png"))
(define OPEN-DOOR-IMAGE (bitmap "open.png"))

; DoorState.v2 -> Image
; Renders door application UI
(define (draw-door s)
  (cond [(state=? OPEN-DOOR s) OPEN-DOOR-IMAGE]
        [(state=? CLOSED s) CLOSED-DOOR-IMAGE]
        [(state=? LOCKED s ) LOCKED-DOOR-IMAGE]))

#;(big-bang CLOSED
  [to-draw draw-door]
  [on-tick handle-door-tick]
  [on-key handle-key])


;; ---------------------------------------------------------------------

;; Úprava - více dveří - ukázka "špatného" designu - potřebujeme lepší abstrakci!

(define-struct app-state [door1 door2 door3])
; AppState is a struct
#;(make-app-state [DoorState.v2 DoorState.v2 DoorState.v2])
; Represents an app with multiple doors

(define APP-STATE (make-app-state CLOSED CLOSED CLOSED))

; AppState DoorAction -> AppState
; Acts on door1
(define (door1-action s a)
  (make-app-state (door-action.v2 (app-state-door1 s) a)
                  (app-state-door2 s)
                  (app-state-door3 s)))

; AppState DoorAction -> AppState
; Acts on door2
(define (door2-action s a)
  (make-app-state (app-state-door1 s)
                  (door-action.v2 (app-state-door2 s) a)
                  (app-state-door3 s)))

; AppState DoorAction -> AppState
; Acts on door3
(define (door3-action s a)
  (make-app-state (app-state-door1 s)
                  (app-state-door2 s)
                  (door-action.v2 (app-state-door3 s) a)))


(define BUTTON-WIDTH 64)
(define BUTTON-HEIGHT 16)
(define BUTTON-SPACING-X 4)
(define BUTTON-SPACING-Y 6)
(define MARGIN-X 6)
(define MARGIN-Y 2)
(define TEXT-SIZE 12)

; Button is a image
; Image sized BUTTON-WIDTH x BUTTON-HEIGHT that serves as a button in UI


(define-struct ui-button [image column row])
; UIButton is a struct
#;(make-ui-button Button Number Number)
; Represents a UI button element in grid


; String Color Color -> Button
(define (button str color-border color-background)
  (overlay
   (text str TEXT-SIZE "black")
   (overlay
    (rectangle BUTTON-WIDTH BUTTON-HEIGHT "outline" color-border)
    (rectangle BUTTON-WIDTH BUTTON-HEIGHT "solid" color-background))))

; Number Number Number -> Boolean
; Determines if a number x is in range (start, start + size)
(define (in-range? start size x)
  (< start x (+ start size)))

; Number Number Number -> Boolean
(define (row-element-clicked? column-idx row-idx x y)
  (and
   (in-range? (+ MARGIN-X (* column-idx (+ BUTTON-WIDTH BUTTON-SPACING-X))) BUTTON-WIDTH x)
   (in-range? (+ MARGIN-Y (* row-idx (+ BUTTON-HEIGHT BUTTON-SPACING-Y))) BUTTON-HEIGHT y)))

; UIButton -> Boolean
(define (ui-button-clicked? button x y)
  (row-element-clicked? (ui-button-column button) (ui-button-row button) x y))

; UIButton Image -> Image
; Places a UIbutton in button-sized grid on 0-indexed row and column in image
(define (place-button button image)
  (place-image/align
   (ui-button-image button)
   (+ MARGIN-X (* (ui-button-column button) (+ BUTTON-WIDTH BUTTON-SPACING-X)))
   (+ MARGIN-Y (* (ui-button-row button) (+ BUTTON-HEIGHT BUTTON-SPACING-Y)))
   "left" "top"
   image))

;; Velké množství definic ...
(define BUTTON-LOCK (button "lock" "yellow" "gray"))
(define BUTTON-UNLOCK (button "unlock" "gold" "yellow"))
(define BUTTON-OPEN (button "open" "gold" "orange"))
(define BUTTON-CLOSE (button "close" "red" "pink"))

(define BUTTON-BASE (empty-scene 280 68))

(define B-LOCK1 (make-ui-button BUTTON-LOCK 0 0))
(define B-LOCK2 (make-ui-button BUTTON-LOCK 0 1))
(define B-LOCK3 (make-ui-button BUTTON-LOCK 0 2))

(define B-UNLOCK1 (make-ui-button BUTTON-UNLOCK 1 0))
(define B-UNLOCK2 (make-ui-button BUTTON-UNLOCK 1 1))
(define B-UNLOCK3 (make-ui-button BUTTON-UNLOCK 1 2))

(define B-OPEN1 (make-ui-button BUTTON-OPEN 2 0))
(define B-OPEN2 (make-ui-button BUTTON-OPEN 2 1))
(define B-OPEN3 (make-ui-button BUTTON-OPEN 2 2))

(define B-CLOSE1 (make-ui-button BUTTON-CLOSE 3 0))
(define B-CLOSE2 (make-ui-button BUTTON-CLOSE 3 1))
(define B-CLOSE3 (make-ui-button BUTTON-CLOSE 3 2))


;; !Toto je velmi ošklivé!

(define UI-BASE
  (place-button
   B-LOCK1
   (place-button
    B-LOCK2
    (place-button
     B-LOCK3
     (place-button
      B-UNLOCK1
      (place-button
       B-UNLOCK2
       (place-button
        B-UNLOCK3
        (place-button
         B-OPEN1
         (place-button
          B-OPEN2
          (place-button
           B-OPEN3
           (place-button
            B-CLOSE1
            (place-button
             B-CLOSE2
             (place-button
              B-CLOSE3
              BUTTON-BASE)))))))))))))

; AppState -> Image
(define (draw-doors s)
  (beside (draw-door (app-state-door1 s))
          (empty-scene 4 0)
          (draw-door (app-state-door2 s))
          (empty-scene 2 0)
          (draw-door (app-state-door3 s))))

; AppState -> Image
(define (draw-ui s)
  (above/align "left"
               UI-BASE
               (draw-doors s)))

; AppState -> AppState
(define (handle-tick s)
  (make-app-state (handle-door-tick (app-state-door1 s))
                  (handle-door-tick (app-state-door2 s))
                  (handle-door-tick (app-state-door3 s))))

; AppState Number Number -> AppState
(define (dispatch-button s x y)
  (cond [(ui-button-clicked? B-LOCK1 x y) (door1-action s TLOCK)]
        [(ui-button-clicked? B-LOCK2 x y) (door2-action s TLOCK)]
        [(ui-button-clicked? B-LOCK3 x y) (door3-action s TLOCK)]
        [(ui-button-clicked? B-UNLOCK1 x y) (door1-action s TUNLOCK)]
        [(ui-button-clicked? B-UNLOCK2 x y) (door2-action s TUNLOCK)]
        [(ui-button-clicked? B-UNLOCK3 x y) (door3-action s TUNLOCK)]
        [(ui-button-clicked? B-OPEN1 x y) (door1-action s TOPEN)]
        [(ui-button-clicked? B-OPEN2 x y) (door2-action s TOPEN)]
        [(ui-button-clicked? B-OPEN3 x y) (door3-action s TOPEN)]
        [(ui-button-clicked? B-CLOSE1 x y) (door1-action s TCLOSE)]
        [(ui-button-clicked? B-CLOSE2 x y) (door2-action s TCLOSE)]
        [(ui-button-clicked? B-CLOSE3 x y) (door3-action s TCLOSE)]
        [else s]))

; AppState Number Number MouseEvent -> AppState
(define (handle-click s x y event)
  (if (mouse=? event "button-up")
      (dispatch-button s x y)
      s))

#;(big-bang APP-STATE
  [to-draw draw-ui]
  [on-tick handle-tick]
  [on-mouse handle-click])

;; Pokud bychom chtěli ještě více dveří, museli bychom upravit velkou část kódu
;; Problém "dat s fixní velikostí" - problém designujeme kolem pevně daného počtu
;; věcí.

;; Všimněte si - problém se 3 dveřmi potřeboval pouze vnitřní logiku problému s 1 dveřmi
;; jedná se o 3 identické kopie propojené až na interakční úrovni aplikace.
