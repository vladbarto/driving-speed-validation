(defrule AGENT::react-to-train-crossing
    (timp (valoare ?t))
    (ag_percept (percept_pname road_sign) (percept_pval trecere_cale_ferata_fara_bariera))
=>
    (printout t "CAUTION: Train crossing ahead without a barrier. Slow down and check for trains. Speed limit is 50 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 50)))
    (printout t "Current speed limit: 50 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::react-to-pedestrian
    (timp (valoare ?t))
    (ag_percept (percept_pname pedestrian) (percept_pval on_crossing))
=>
    (printout t "STOP: Pedestrian on the crossing. Do not proceed until the way is clear. Speed limit is 0 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 0)))
    (printout t "Current speed limit: 0 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::highway-entry
    (timp (valoare ?t))
    (ag_percept (percept_pname road_sign) (percept_pval intrare_autostrada))
=>
    (printout t "Entered highway. Speed limit is 130 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 130)))
    (printout t "Current speed limit: 130 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::slow-vehicle-detected
    (timp (valoare ?t))
    (ag_percept (percept_pname vehicle) (percept_pval slow) (percept_pdir ahead))
=>
    (printout t "Slow vehicle ahead in the right lane. Speed limit remains unchanged." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 130)))
    (printout t "Current speed limit: 130 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::overtake-vehicle
    (timp (valoare ?t))
    (ag_percept (percept_pname maneuver) (percept_pval overtaking))
    (ag_percept (percept_pname lane) (percept_pval left))
=>
    (printout t "Overtaking vehicle using the left lane. Speed limit remains unchanged." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 130)))
    (printout t "Current speed limit: 130 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::heavy-rain
    (timp (valoare ?t))
    (ag_percept (percept_pname weather) (percept_pval heavy_rain))
    (ag_percept (percept_pname visibility) (percept_pval reduced))
=>
    (printout t "Heavy rain detected. Speed limit is 50 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 50)))
    (printout t "Current speed limit: 50 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::accident-warning
    (timp (valoare ?t))
    (ag_percept (percept_pname road_sign) (percept_pval accident_ahead))
    (ag_percept (percept_pname lane) (percept_pval closed))
=>
    (printout t "Accident ahead. Speed limit is 30 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 30)))
    (printout t "Current speed limit: 30 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::localitate
    (timp (valoare ?))
    (ag_percept (percept_pobj semn) (percept_pname indicator) (percept_pval localitate_in))
=>
    (printout t "Entering locality. Speed limit is 50 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 50)))
    (printout t "Current speed limit: 50 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::clear-weather
    (timp (valoare ?))
    (ag_percept (percept_pobj semn) (percept_pname indicator) (percept_pval localitate_out))
    (ag_percept (percept_pobj senzor) (percept_pname stare_vreme) (percept_pval senin))
=>
    (printout t "Clear weather outside locality. Speed limit is 90 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 90)))
    (printout t "Current speed limit: 90 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::school-zone
    (timp (valoare ?))
    (ag_percept (percept_pobj semn) (percept_pname indicator) (percept_pval scoala))
=>
    (printout t "School zone. Speed limit is 30 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 30)))
    (printout t "Current speed limit: 30 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::pedestrian-crossing
    (timp (valoare ?))
    (ag_percept (percept_pobj semn) (percept_pname indicator) (percept_pval trecere_pietoni))
    (ag_percept (percept_pobj om) (percept_pname pe_trecere) (percept_pval yes))
=>
    (printout t "Pedestrian on the crossing. Speed limit is 30 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 30)))
    (printout t "Current speed limit: 30 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::red-traffic-light
    (timp (valoare ?))
    (ag_percept (percept_pobj semn) (percept_pname semafor) (percept_pval rosu))
=>
    (printout t "Red traffic light. Speed limit is 0 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 0)))
    (printout t "Current speed limit: 0 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::railroad-crossing-no-barrier
    (timp (valoare ?))
    (ag_percept (percept_pobj trecere_tren) (percept_pname bariera) (percept_pval no))
=>
    (printout t "Railroad crossing without barrier. Speed limit is 50 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 50)))
    (printout t "Current speed limit: 50 km/h" crlf)
    (facts AGENT)
)

(defrule AGENT::dangerous-curve
    (timp (valoare ?))
    (ag_percept (percept_pobj road) (percept_pname curba) (percept_pval periculoasa))
=>
    (printout t "Dangerous curve. Speed limit is 40 km/h." crlf)
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval 40)))
    (printout t "Current speed limit: 40 km/h" crlf)
    (facts AGENT)
)
