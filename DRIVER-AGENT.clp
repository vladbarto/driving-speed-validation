
(defrule AGENT::initCycle-exista-speed_limit-moment "presupun ca la final de tot nu exista speed_limit MOMENT"
    (declare (salience 90))
    (timp (valoare ?))
=>
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE)))
    (assert (ag_bel (bel_type moment) (bel_pname kept_in_mind_speed_active) (bel_pval FALSE)))
)

(defrule AGENT::initCycle-viteza-localitate
    (declare (salience 89))
    (timp (valoare 1))
    (ag_bel (bel_type moment) (bel_pname is_a) (bel_pval localitate))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <DEFAULT SPEED> 50 by default as fluent bel" crlf))
    (assert (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 50)))
    (facts AGENT)
)

(defrule AGENT::initCycle-viteza-drum-european
    (declare (salience 89))
    (timp (valoare 1))
    (ag_bel (bel_type moment) (bel_pname is_a) (bel_pval drum_european|drum_national|drum_judetean|drum_comunal))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <DEFAULT SPEED> 100 by default as fluent bel" crlf))
    (assert (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 100)))
    (facts AGENT)
)
(defrule AGENT::iesire-localitate-senin
    (declare (salience 30))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj semn_1) (bel_pname indicator) (bel_pval localitate_out))
    (ag_bel (bel_type moment) (bel_pobj senzor) (bel_pname stare_vreme) (bel_pval senin))
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <IESIRE LOCALITATE> Regula aplicată pentru senin crlf"))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 90)))
    (modify ?s (bel_pval TRUE))
)

(defrule AGENT::trecere-tren-bariera-no
    (declare (salience 25))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj trecere_tren) (bel_pname bariera) (bel_pval no))
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TRECERE TREN> Bariera ridicată, limită aplicată crlf"))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 0)))
    (modify ?s (bel_pval TRUE))
)

(defrule AGENT::curba-periculoasa-indicator-40
    (declare (salience 20))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj road) (bel_pname curba) (bel_pval periculoasa))
    (ag_bel (bel_type moment) (bel_pobj semn) (bel_pname indicator) (bel_pval 40))
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <CURBA PERICULOASA> Limită de viteză detectată crlf"))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 40)))
    (modify ?s (bel_pval TRUE))
)

(defrule AGENT::trecere-pietoni
    (declare (salience 20))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj semn) (bel_pname trecere_pietoni) (bel_pval yes))
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TRECERE PIETONI> Regula aplicată pentru trecere pietoni crlf"))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 90)))
    (modify ?s (bel_pval TRUE))
)

(defrule AGENT::om-pe-trecere
    (declare (salience 20))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj om) (bel_pname pe_trecere) (bel_pval yes))
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <OM PE TRECERE> Limită de viteză redusă crlf"))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 0)))
    (modify ?s (bel_pval TRUE))
)

(defrule AGENT::animal-pe-trecere
    (declare (salience 20))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj caine) (bel_pname pe_trecere) (bel_pval yes))
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <ANIMAL PE TRECERE> Limită de viteză redusă crlf"))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 0)))
    (modify ?s (bel_pval TRUE))
)


;;autostrada

;;----------------------------------
;;
;;    T1: Enter Highway
;;    Speed Limit: 130 km/h
;;----------------------------------
(defrule AGENT::scenario-enter-highway
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj semn)
        (percept_pname autostrada)
        (percept_pval yes)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TIME 1> Entering Highway - Speed Limit 130 km/h" crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 130)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 130)))
)

;;----------------------------------
;;
;;    T2: Road Work Speed Limit
;;    Speed Limit: 60 km/h
;;----------------------------------
(defrule AGENT::scenario-road-work-speed-limit
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj semn)
        (percept_pname lucrari_drum)
        (percept_pval yes)
    )
    (ag_percept
        (percept_pobj semn)
        (percept_pname limita_viteza)
        (percept_pval 60)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TIME 2> Road Work - Speed Limit 60 km/h" crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 60)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 60)))
)

;;----------------------------------
;;
;;    T3: Resume Normal Speed after Road Work
;;    Speed Limit: 130 km/h
;;----------------------------------
(defrule AGENT::scenario-resume-normal-speed
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj semn)
        (percept_pname lucrari_drum)
        (percept_pval no)
    )
    (ag_percept
        (percept_pobj semn)
        (percept_pname limita_viteza)
        (percept_pval 130)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TIME 3> Road Work Ended - Resuming Normal Speed 130 km/h" crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 130)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 130)))
)

;;----------------------------------
;;
;;    T4: Light Rain
;;    Speed Suggestion: 80 km/h
;;----------------------------------
(defrule AGENT::scenario-light-rain
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj senzor)
        (percept_pname vreme)
        (percept_pval ploaie)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TIME 4> Light Rain - Suggested Speed 80 km/h" crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 80)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 80)))
)

;;----------------------------------
;;
;;    T5: Heavy Rain
;;    Speed Limit: 50 km/h
;;----------------------------------
(defrule AGENT::scenario-heavy-rain
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj senzor)
        (percept_pname vreme)
        (percept_pval ploaie_torentiala)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TIME 5> Heavy Rain - Mandatory Speed Limit 50 km/h" crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 50)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 50)))
)

;;----------------------------------
;;
;;    T6: Rain Stops
;;    Speed Limit: Resume to 130 km/h
;;----------------------------------
(defrule AGENT::scenario-rain-stops
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj senzor)
        (percept_pname vreme)
        (percept_pval senin)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TIME 6> Rain Stops - Resuming Normal Speed 130 km/h" crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 130)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 130)))
)

;;----------------------------------
;;
;;    T7: Exit Highway
;;    Speed Limit: 90 km/h (National Road)
;;----------------------------------
(defrule AGENT::scenario-exit-highway
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj semn)
        (percept_pname iesire_autostrada)
        (percept_pval yes)
    )
    (ag_percept
        (percept_pobj semn)
        (percept_pname tip_drum)
        (percept_pval national)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TIME 7> Exiting Highway - Speed Limit 90 km/h (National Road)" crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 90)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 90)))
)

;;---------------------------------- 
;; T1: Entering Locality 
;; Speed Limit: 50 km/h 
;;----------------------------------
(defrule AGENT::scenario-enter-locality
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj semn)
        (percept_pname indicator)
        (percept_pval localitate_in)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
    =>
    (if (eq ?*ag-in-debug* TRUE) then 
        (printout t "    <TIME 1> Entering Locality - Speed Limit 50 km/h" crlf)
    )
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 50)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 50)))
)

;;---------------------------------- 
;; T2: Rainy Conditions 
;; Speed Limit: 30 km/h 
;;----------------------------------
(defrule AGENT::scenario-rainy-conditions
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj senzor)
        (percept_pname stare_vreme)
        (percept_pval ploaie_torentiala)
    )
    (ag_percept
        (percept_pobj senzor)
        (percept_pname vizibilitate)
        (percept_pval redusa)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
    =>
    (if (eq ?*ag-in-debug* TRUE) then 
        (printout t "    <TIME 2> Rainy Conditions - Reduced Speed Limit 30 km/h" crlf)
    )
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 30)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 30)))
)

;;---------------------------------- 
;; T3: School Zone 
;; Speed Limit: 30 km/h 
;;----------------------------------
(defrule AGENT::scenario-school-zone
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj semn)
        (percept_pname indicator)
        (percept_pval scoala)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
    =>
    (if (eq ?*ag-in-debug* TRUE) then 
        (printout t "    <TIME 3> School Zone - Speed Limit 30 km/h" crlf)
    )
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 30)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 30)))
)

;;---------------------------------- 
;; T4: Pedestrian Crossing with Red Light 
;; Speed Limit: 0 km/h (Full Stop) 
;;----------------------------------
(defrule AGENT::scenario-pedestrian-crossing
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj semn)
        (percept_pname indicator)
        (percept_pval trecere_pietoni)
    )
    (ag_percept
        (percept_pobj semn)
        (percept_pname semafor)
        (percept_pval rosu)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
    =>
    (if (eq ?*ag-in-debug* TRUE) then 
        (printout t "    <TIME 4> Pedestrian Crossing with Red Light - Full Stop" crlf)
    )
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 0)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 0)))
)

;;---------------------------------- 
;; T5: Leaving Locality 
;; Speed Limit: 90 km/h 
;;----------------------------------
(defrule AGENT::scenario-leave-locality
    (declare (salience 100))
    (timp (valoare ?t))
    (ag_percept
        (percept_pobj semn)
        (percept_pname indicator)
        (percept_pval localitate_out)
    )
    (ag_percept
        (percept_pobj senzor)
        (percept_pname stare_vreme)
        (percept_pval senin)
    )
    (ag_percept
        (percept_pobj senzor)
        (percept_pname vizibilitate)
        (percept_pval normala)
    )
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
    =>
    (if (eq ?*ag-in-debug* TRUE) then 
        (printout t "    <TIME 5> Leaving Locality - Speed Limit 90 km/h" crlf)
    )
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 90)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 90)))
)