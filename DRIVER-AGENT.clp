;
;-------Auxiliary facts ---------------------------------------
;

(defrule AGENT::initCycle-overtaking
    (declare (salience 89))
    (timp (valoare ?)) ;make sure it fires each cycle
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>initCycle-overtaking prohibited by default " crlf))
    (assert (ag_bel (bel_type moment) (bel_pname overtaking-maneuver) (bel_pval prohibited))) ;by default, we assume overtaking NOT valid
    ;(facts AGENT)
)

(defrule AGENT::initCycle-right-turn
    (declare (salience 89))
    (timp (valoare ?)) ;make sure it fires each cycle
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>initCycle-right-turn prohibited by default " crlf))
    (assert (ag_bel (bel_type moment) (bel_pname right-turn-maneuver) (bel_pval prohibited))) ;by default, we assume overtaking NOT valid
    ;(facts AGENT)
)

(defrule AGENT::initCycle-left-turn
    (declare (salience 89))
    (timp (valoare ?)) ;make sure it fires each cycle
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>initCycle-left-turn prohibited by default " crlf))
    (assert (ag_bel (bel_type moment)  (bel_pname left-turn-maneuver) (bel_pval prohibited))) ;by default, we assume overtaking NOT valid
    ;(facts AGENT)
)

;;----------------------------------
;;
;;    Overtaking
;;
;;----------------------------------

;
;-------Check percepts to update restriction fluents-----------
;
;---Case #1: a fluent with 1 sign to turn it on and 2 signs which might turn it off

;--- Sign overtaking prohibited
(defrule AGENT::rdi
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?ps) (bel_pname isa) (bel_pval road_sign))
    (ag_bel (bel_type moment) (bel_pobj ?ps) (bel_pname semnificatie) (bel_pval depasire_interzisa))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>rdi vad indicator " depasire_interzisa crlf))
    (assert (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes)))
    ;(facts AGENT)
)

(defrule AGENT::frdi
    (timp (valoare ?t))
    ?f <- (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes))
    (ag_bel (bel_type moment) (bel_pobj ?ps) (bel_pname isa) (bel_pval road_sign))
    (ag_bel (bel_type moment) (bel_pobj ?ps) (bel_pname semnificatie) (bel_pval final_depasire_interzisa))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>frdi vad indicator " final_depasire_interzisa crlf))
    (retract ?f)
    ;(facts AGENT)
)

(defrule AGENT::far
    (timp (valoare ?t))
    ?f <- (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes))
    (ag_bel (bel_type moment) (bel_pobj ?ps) (bel_pname isa) (bel_pval road_sign))
    (ag_bel (bel_type moment) (bel_pobj ?ps) (bel_pname semnificatie) (bel_pval  incetarea_tuturor_restrictiilor))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>far vad indicator " tip incetarea_tuturor_restrictiilor crlf))
    (retract ?f)
    ;(facts AGENT)
)

;----Case #2: an non-fluent belief: it depends on the current percepts only
;--- Marcaj trecere pietoni perceput in momentul curent
(defrule AGENT::rmtp
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?ps) (bel_pname isa) (bel_pval road_surface_marking))
    (ag_bel (bel_type moment) (bel_pobj ?ps) (bel_pname semnificatie) (bel_pval  trecere_pietoni))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>rmtp vad marcaj " trecere_pietoni crlf))
    (assert (ag_bel (bel_type moment) (bel_pname pedestrian-crossing-marking) (bel_pval yes)))
)

;--- Marcaj linie continua perceput in momentul curent
(defrule AGENT::rmlc
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?ps) (bel_pname isa) (bel_pval road_surface_marking))
    (ag_bel (bel_type moment) (bel_pobj ?ps) (bel_pname semnificatie) (bel_pval linie_cont))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>rmlc vad marcaj " linie_cont crlf))
    (assert (ag_bel (bel_type moment) (bel_pname continuous-line-marking) (bel_pval yes)))
    ;(facts AGENT)
)


;-- TODO: daca am Semn trecere de pietoni (nu marcaj, ci semn!) - switch fluent dupa o anumita distanta parcursa
;-- de abstractizat terminarea parcurgerii distantei

;-- TODO: marcaj linie continua pe care l-as incalca la repliere - tratare perceptii curente+viitoare
;-- de integrat si in regula validate-overtaking

;-----Validate intention of overtaking: check if there is any restriction ----------
(defrule AGENT::validate-overtaking
    (declare (salience -10))
    ?f <- (ag_bel (bel_type moment) (bel_pname overtaking-maneuver) (bel_pval prohibited))
    (not (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes)))
    (not (ag_bel (bel_type moment) (bel_pname pedestrian-crossing-marking) (bel_pval yes)))
    (not (ag_bel (bel_type moment) (bel_pname continuous-line-marking) (bel_pval yes)))
; TODO: De restul cazurilor, listate mai jos, trebuie sa te ocupi
;    (not (crt-intersectie)) TODO: TOATE?!?!
;    (not (crt-rampa))
;    (not (crt-curba))
;    (not (crt-vizibilitate redusa))
;    (not (crt-pasaj))
;    (not (crt-pod))
;    (not (crt-sub pod))
;    (not (crt-tunel))
;    (not (crt-cale ferata curenta))
;    (not (crt-urmeaza cale ferata))
;    (not (crt-statie))
;    (not (crt-marcaj dublu continuu))
;    (not (crt-posibila coliziune))
;    (not (crt-coloana))
;    (not (crt-coloana_oficiala))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>validate-overtaking NU->DA (nu avem restrictii) " crlf))
    (retract ?f)
    (assert (ag_bel (bel_type moment) (bel_pname overtaking-maneuver) (bel_pval allowed)))
    ;(facts AGENT)
)


;;----------------------------------
;;
;;    Right turn
;;
;;----------------------------------

;--- Sign forbidding right turn or forcing either go ahead or left turn
(defrule AGENT::r-no-right-turn-sign
    (timp (valoare ?t))
    (ag_bel (bel_pobj ?ps) (bel_pname isa) (bel_pval road_sign))
    (ag_bel (bel_pobj ?ps) (bel_pname semnificatie) (bel_pval ?v&interzis_viraj_dreapta | obligatoriu_inainte | obligatoriu_stanga | obligatoriu_inainte_stanga))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>r-no-right-turn-sign" crlf))
    (assert (ag_bel (bel_type fluent) (bel_pname no-right-turn-zone) (bel_pval yes)))
    ;(facts AGENT)
)

(defrule AGENT::r-no-right-turn-zone-end
    (timp (valoare ?t))
    ?f <- (ag_bel (bel_type fluent) (bel_pname no-right-turn-zone) (bel_pval yes))
    (ag_bel (bel_pobj ?ps) (bel_pname isa) (bel_pval area_limit))
    (ag_bel (bel_pobj ?ps) (bel_pname semnificatie) (bel_pval intersection_end))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>r-no-right-turn-zone-end we crossed an intersection" crlf))
    (retract ?f)
)

 ;--- Sign forbidding access on a street
(defrule AGENT::r-no-access
    (timp (valoare ?t))
    (ag_bel (bel_pobj ?ps) (bel_pname isa) (bel_pval road_sign))
    (ag_bel (bel_pobj ?ps) (bel_pname semnificatie) (bel_pval ?v& accesul_interzis | circulatia_interzisa_in_ambele_sensuri))
    ;;;(ag_bel (bel_pobj ?ps) (bel_pname direction) (bel_pval ?pd& right | left))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>r-no-access" crlf))
    (assert (ag_bel (bel_type moment) (bel_pname no-access) (bel_pval yes)))
    ;(facts AGENT)
)

;-----Validate intention of right-turn: check if there is any restriction ----------
(defrule AGENT::validate-right-turn
    (declare (salience -10))
    ?f <- (ag_bel (bel_type moment) (bel_pname right-turn-maneuver) (bel_pval prohibited))
    (not (ag_bel (bel_type fluent) (bel_pname no-right-turn-zone) (bel_pval yes)))
    ;(not (ag_bel (bel_type moment) (bel_pname no-access) (bel_pval yes) (bel_pdir right)))
    ;; TODO: manage direction
    (not (ag_bel (bel_type moment) (bel_pname no-access) (bel_pval yes)))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>validate-right-turn NU->DA (nu avem restrictii) " crlf))
    (retract ?f)
    (assert (ag_bel (bel_type moment) (bel_pname right-turn-maneuver) (bel_pval allowed)))
    ;(facts AGENT)
)


;;----------------------------------
;;
;;    Left turn
;;
;;----------------------------------

;--Sign forbidding access on a street to the left dealt by r-no-access rule
;--continuous line presence checked by rmlc rule
;--TODO: roundabout

;--- Sign forbidding left turn or forcing either go ahead or right turn
(defrule AGENT::r-no-left-turn-sign
    (timp (valoare ?t))
    (ag_bel (bel_pobj ?ps) (bel_pname isa) (bel_pval road_sign))
    (ag_bel (bel_pobj ?ps) (bel_pname semnificatie) (bel_pval ?v&interzis_viraj_stanga | obligatoriu_inainte | obligatoriu_dreapta | obligatoriu_inainte_dreapta | intersectie_cu_sens_giratoriu))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>r-no-left-turn-sign" ?v crlf))
    (assert (ag_bel (bel_type fluent) (bel_pname no-left-turn-zone) (bel_pval yes)))
    ;(facts AGENT)
)

(defrule AGENT::r-no-left-turn-zone-end
    (timp (valoare ?t))
    ?f <- (ag_bel (bel_type fluent) (bel_pname no-left-turn-zone) (bel_pval yes))
    (ag_bel (bel_pobj ?ps) (bel_pname isa) (bel_pval area_limit))
    (ag_bel (bel_pobj ?ps) (bel_pname isa) (bel_pval area_limit))
    (ag_bel (bel_pobj ?ps) (bel_pname semnificatie) (bel_pval intersection_end))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>r-no-left-turn-zone-end we crossed an intersection" crlf))
    (retract ?f)
)

;-----Validate intention of left-turn: check if there is any restriction ----------
(defrule AGENT::validate-left-turn
    (declare (salience -10))
    ?f <- (ag_bel (bel_type moment) (bel_pname left-turn-maneuver) (bel_pval prohibited))
    (not (ag_bel (bel_type fluent) (bel_pname no-left-turn-zone) (bel_pval yes)))
    ;(not (ag_bel (bel_type moment) (bel_pname no-access) (bel_pval yes) (bel_pdir left)))
    ;; TODO: manage direction
     (not (ag_bel (bel_type moment) (bel_pname no-access) (bel_pval yes)))
    (not (ag_bel (bel_type moment) (bel_pname continuous-line-marking) (bel_pval yes)))
;roundabout
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>validate-left-turn NU->DA (nu avem restrictii) " crlf))
    (retract ?f)
    (assert (ag_bel (bel_type moment) (bel_pname left-turn-maneuver) (bel_pval allowed)))
    ;(facts AGENT)
)



;---------Delete auxiliary facts which are no longer needed ----------
;
; Programmner's task
;
