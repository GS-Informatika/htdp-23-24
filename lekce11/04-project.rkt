;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 04-project) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ----- Projekt - hra Snake -----

;; Pokusíme se využít naši novou znalost práce s listy a vytvoříme
;; si vlastní implementaci hry Snake.

;; Tento projekt bude na několik lekcí - ke konci každé lekce
;; bude prostor na dotazy k vaší implementaci a kde rychle zhodnotíte váš
;; postup v implementaci. Můžete postupovat podle následujícího "návodu"

;; Krok 1) Analýza
;; Jak funguje hra Snake? Zkuste si zahrát! (např. https://playsnake.org/)
;; Hráč určuje kterým směrem se pohybuje had.
;; Had se nesmí dotknout sám sebe nebo vyjít za okraj herní oblasti.
;; Cílem je sbírat "jablka" - pokud hlava hada dojde na pole s jablkem
;; had jablko zkonzumuje, prodlouží se o jeden článek a nové jablko se
;; vygeneruje jinde na herní oblasti.

;; Otázky - co vše musí obsahovat stav hry?


;;  Krok 2) Definice dat
;; Musíme zamyslet nad interní reprezentací
;; hada a jablka. Jablko se vždy nachází na jednom poli herní oblasti.
;; Had ale může okupovat více polí - tato délka není pevně daná.
;; Jaké budou datové typy reprezentující hada a jablko? Zapište jejich
;; deklaraci! Zapište i deklaraci ostatních typů které obsahuje stav hry.


;; Výstup hry je reprezentován funkcí která
;; ze stavu hry vytvoří obrázek. Definujte strukturní typ pro stav
;; hry podle vaší odpovědi v kroku 1. Jakou má signaturu funkce která
;; z vašeho stavu vytvoří obrázek?


;; Dále je potřeba ujasnit si uživatelský vstup. Uživatel bude používat
;; šipky nebo klávesy "w", "s", "a", "d" k určení kterým směrem se má
;; had pohybovat. Stisk příslušné klávesy upraví stav hry tak, aby se dále
;; had pohyboval daným směrem. Pro každý směr později vytvoříme funkci která
;; jej nastaví ve stavu hry. Jakou bude mít taková funkce signaturu?


;; V každém "ticku" hry by se měl had posunout o jedno pole směrem daným stavem.
;; Jakou signaturu bude mít funkce která toto posunutí provede?

;; Pokud ale had dojde na stejné pole jako je jablko, dojde k prodloužení hada o 1 pole
;; a vygenerování nového jablka. Jakou signaturu bude mít tato funkce?

;; Tato logika nám radí jak bude vypadat funkce on-tick - zkontrolujeme jestli had dojde
;; na pole s jablkem a podle toho provedeme příslušnou změnu.

;; Abychom tuto kontrolu provedli, potřebujeme vhodný predikát. Dále potřebujeme predikáty
;; pro určení prohry (had narazí do sebe nebo do zdi). Napište si "wish list" predikátů
;; které budete potřebovat


;; Krok 3) Stav programu
;; Stav hry se ve výsledku bude lišit od stavu programu - potřebujeme navíc
;; rozlišit "GAME OVER" obrazovku a "START GAME" obrazovku. Navrhněte
;; datový typ a FSM mezi těmito stavy.


;; Krok 4) Implementace
;; Začněte s implementací - nejprve nadesignujte potřebné predikáty a funkce
;; pracující s interním stavem hry, poté designujte funkce které pracují s uživatelským
;; vstupem a výstupem.
