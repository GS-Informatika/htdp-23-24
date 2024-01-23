;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |02|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Interaktivní programy - rychlá ukázka
(require 2htdp/image)
(require 2htdp/universe)

;; Interaktivní programy konzumují události (eventy) z OS (interakce s myší, klávesnicí, internetem ...)
;; Reagují na tyto události event handlery - funkcemi, které mění momentální stav programu


; Counter is a Number
; Represents current count


;; V BSL máme knihovnu 2htdp/universe která zajistí přísun eventů a umožňuje vytvářet handlery

;; Handler je funkce která z momentálního stavu programu vytvoří nový stav

; Counter Key -> Counter
; Increases the counter on arrow up and decreases on arrow down
(define (key-handler current key)
  (cond [(key=? key "up") (add1 current)]
        [(key=? key "down") (sub1 current)]
        [else current]))


;; 2htdp/universe nám také umožňuje vykreslit momentální stav do UI (user interface)
(define TEXT-SIZE 36)
(define TEXT-COLOR "indigo")
(define WINDOW-HEIGHT 128)
(define WINDOW-WIDTH 128)
; Counter -> Image
; creates image with number equal to the value of counter
(define (draw-counter counter)
  (place-image
   (text (number->string counter)
         TEXT-SIZE TEXT-COLOR)
   (/ WINDOW-WIDTH 2) (/ WINDOW-HEIGHT 2)
   (empty-scene WINDOW-WIDTH WINDOW-HEIGHT)))


;; Pro vytvoření interaktivního programu se pak použije výraz (big-bang initial handlers...)
#;(big-bang 0
  [to-draw draw-counter]
  [on-key key-handler])





;; Stav programu může být libovolný typ, musíme ale dodržovat kontrakty funkcí!



; TrafficLightState is one of
; - "red"
; - "yellow"
; - "green"
; represents a state on traffic lights



; TimeDelay is a number in the interval of
; - 0 to infinity
; represents delay in ticks (28 per second)



(define RED-DURATION-SECONDS 12)
(define GREEN-DURATION-SECONDS 8)
(define YELLOW-DURATION-SECONDS 2)
; TrafficLightState -> TimeDelay
; Returns the duration of the lights state in ticks
(define (tl-state-duration state)
  (* 28
     (cond [(string=? state "red") RED-DURATION-SECONDS]
           [(string=? state "yellow") YELLOW-DURATION-SECONDS]
           [(string=? state "green") GREEN-DURATION-SECONDS])))


; TrafficLightState -> TrafficLightState
; Returns next state on the traffic light
(define (tl-next-state state)
  (cond [(string=? state "red") "green"]
        [(string=? state "green") "yellow"]
        [(string=? state "yellow") "red"]))

(define-struct world-state [pos tl time-remaining])
; WorldState is a struct
#;(make-world-state Posn TrafficLightState TimeDelay)
; represents world state of interactive application
; where circle following TrafficLightState finite state
; machine is at located at pos


; WorldState -> WorldState
; ticks the world state
(define (tl-tick-handler state)
  (if (= (world-state-time-remaining state) 0)
      (make-world-state (world-state-pos state)
                        (tl-next-state (world-state-tl state))
                        (tl-state-duration (tl-next-state (world-state-tl state))))
      (make-world-state (world-state-pos state)
                        (world-state-tl state)
                        (sub1 (world-state-time-remaining state)))))

; Posn Number -> Posn
; Moves posn by y in the y axis
(define (move-y posn y)
  (make-posn (posn-x posn) (+ (posn-y posn) y)))

; Posn Number -> Posn
; Moves posn by x in the x axis
(define (move-x posn x)
  (make-posn (+ (posn-x posn) x) (posn-y posn)))

; WorldState Key -> WorldState
; handles keys - moves the circle
(define (tl-key-handler state key)
  (cond [(key=? key "up") (make-world-state (move-y (world-state-pos state) -1)
                                            (world-state-tl state)
                                            (world-state-time-remaining state))]
        [(key=? key "down") (make-world-state (move-y (world-state-pos state) 1)
                                            (world-state-tl state)
                                            (world-state-time-remaining state))]
        [(key=? key "left") (make-world-state (move-x (world-state-pos state) -1)
                                            (world-state-tl state)
                                            (world-state-time-remaining state))]
        [(key=? key "right") (make-world-state (move-x (world-state-pos state) 1)
                                            (world-state-tl state)
                                            (world-state-time-remaining state))]
        [else state]))


(define TL-CIRCLE-RADIUS 10)
(define TL-WINDOW-WIDTH 256)
(define TL-WINDOW-HEIGHT 256)
; WorldState -> Image
; renders world state
(define (tl-draw state)
  (place-image
   (circle TL-CIRCLE-RADIUS "solid" (world-state-tl state))
   (posn-x (world-state-pos state)) (posn-y (world-state-pos state))
   (empty-scene TL-WINDOW-WIDTH TL-WINDOW-HEIGHT)))

(big-bang (make-world-state (make-posn 10 10)
                            "red"
                            64)
  [on-draw tl-draw]
  [on-key tl-key-handler]
  [on-tick tl-tick-handler])
