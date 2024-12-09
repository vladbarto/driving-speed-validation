;
;-------Auxiliary facts ---------------------------------------
;

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

;;----------------------------------
;;
;;    Semafor
;;
;;----------------------------------
;--- Semafor culoare galbena sau rosie
(defrule AGENT::semafor-galben-rosu-no-speed-limit
    (declare (salience 20))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?sem) (bel_pname is_a) (bel_pval semafor))
    (ag_bel (bel_type moment) (bel_pobj ?sem) (bel_pname culoare) (bel_pval ?color&galben|rosu))
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <SEMAFOR> Semafor perceput, culoare " ?color crlf))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 0)))    
    (modify ?s (bel_pval TRUE))
 )

;  (defrule AGENT::semafor-galben-rosu-with-speed-limit  ;FIXME: adapt
;     (declare (salience 20))
;     (timp (valoare ?t))
;     (ag_bel (bel_type moment) (bel_pobj ?sem) (bel_pname is_a) (bel_pval semafor))
;     (ag_bel (bel_type moment) (bel_pobj ?sem) (bel_pname culoare) (bel_pval ?color&galben|rosu))
;     ;?current_speed_limit <- (ag_bel (bel_pname speed_limit))
;     ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
; =>
;     (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D><SEMAFOR> Semafor perceput, culoare " ?color crlf))
;     ;(retract ?current_speed_limit)
;     (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 0)))    
;     (modify ?s (bel_pval TRUE))
;  )


(defrule AGENT::semafor-verde "don't modify speed limit, as it will be adapted by itself (see last command)" ;TODO: creeaza inca un belief de tip fluent, cu viteza tinuta in minte, nu numai cu cea default
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?sem) (bel_pname is_a) (bel_pval semafor))
    (ag_bel (bel_type moment) (bel_pobj ?sem) (bel_pname culoare) (bel_pval ?color&verde))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <SEMAFOR> semafor perceput, culoare " ?color crlf))
)


;;----------------------------------
;;
;;    Politie
;;
;;----------------------------------
(defrule AGENT::politie-in-misiune
    (declare (salience 20))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?pol) (bel_pname is_a) (bel_pval echipaj_de_politie))
    (ag_bel (bel_type moment) (bel_pobj ?pol) (bel_pname semnale_acustice) (bel_pval active))
    (ag_bel (bel_type moment) (bel_pobj ?pol) (bel_pname semnale_luminoase) (bel_pval rosu_si_albastru))
    ;TODO:? add pozitia relativa a echipajului fata de masina sau get rid of it
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <POLITIE> echipaj in misiune perceput" crlf))
    (modify ?s (bel_type TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 0)))    
)

;;----------------------------------
;;
;;    Trecere de pietoni
;;
;;----------------------------------
(defrule AGENT::trecere-de-pietoni-fara-pietoni-in-localitate
    (declare (salience 20))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname is_a) (bel_pval trecere_de_pietoni))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname buza_trecerii) (bel_pval all_clear))
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <CROSSROAD> trecere de pietoni fara pietoni in localitate perceputa" crlf))
    (modify ?s (bel_type TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 30)))    
)

(defrule AGENT::trecere-de-pietoni-cu-pietoni
    (declare (salience 20))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname is_a) (bel_pval trecere_de_pietoni))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname buza_trecerii) (bel_pval pietoni_approaching))
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <CROSSROAD> trecere de pietoni fara pietoni in afara perceputa" crlf))
    (modify ?s (bel_type TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 0)))    
)

;;----------------------------------
;;
;;    Indicator generic limita de viteza
;;
;;----------------------------------
(defrule AGENT::indicator-start
    (declare (salience 20))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval indicator))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname semnificatie) (bel_pval impunere_restrictie_viteza))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname valoare) (bel_pval ?speed))
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <INDICATOR><"?speed"> Limita viteza " ?speed " perceputa" crlf))
    (modify ?s (bel_type TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval ?speed)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval ?speed)))   
)

(defrule AGENT::indicator-end
    (declare (salience 20))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval indicator))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname semnificatie) (bel_pval sfarsit_restrictie_viteza))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname valoare) (bel_pval ?speed))
    ; ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
    ?r<-(ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval ?speed))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <INDICATOR><"?speed"> Sfarsit Limita viteza " ?speed " perceputa" crlf))
    ; (modify ?s (bel_type FALSE)) ; implicitly FALSE by initCycle routine
    (retract ?r)
)

;;----------------------------------
;;
;;    Indicator curba deosebit de periculoasa
;;
;;----------------------------------
(defrule AGENT::indicator-curba-deosebit-de-periculoasa-afara
    (declare (salience 25))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval indicator))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname semnificatie) (bel_pval atentionare))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname valoare) (bel_pval curba_deosebit_de_periculoasa))
    (not (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 50))) ; ne folosim de limita de viteza default ca sa ne dam seama ca nu suntem in localitate
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <INDICATOR> Curba_deosebit_de_periculoasa in afara localitatii perceputa" crlf))
    (modify ?s (bel_type TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 50)))
    ; (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval ?speed)))   
)

(defrule AGENT::indicator-curba-deosebit-de-periculoasa-in-localitate
    (declare (salience 25))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval indicator))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname semnificatie) (bel_pval atentionare))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname valoare) (bel_pval curba_deosebit_de_periculoasa))
    (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 50)) ; ne folosim de limita de viteza default ca sa ne dam seama ca suntem in localitate
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <INDICATOR> Curba_deosebit_de_periculoasa in interiorul localitatii perceputa" crlf))
    (modify ?s (bel_type TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 30)))
    ; (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval ?speed)))   
)
;-------Chiar la final-----------
; verifica daca nu s-a stabilit niciun belief MOMENT de speed limit,
; then ia speed limit FLUENT si aserteaza-l ca MOMENT
;--------------------------------
(defrule AGENT::aserteaza-viteza-tinuta-minte "daca am dat de un indicator de limita viteza, nu il mai vedem, dar ne ramane in cap"
    (declare (salience 15))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
    (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval ?speed))
    ?s<-(ag_bel (bel_type moment) (bel_pname kept_in_mind_speed_active))
=>
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval ?speed)))
    (modify ?s (bel_pval TRUE))
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D><LA FINAL> no rule activated, tinut in minte moment speed_limit is " ?speed crlf))
)


(defrule AGENT::aserteaza-viteza-default "in cazul in care nu s-a activat nicio regula care sa impuna speed_limit MOMENT"
    (declare (salience 10))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE))
    (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval ?speed))
    (ag_bel (bel_type moment) (bel_pname kept_in_mind_speed_active) (bel_pval FALSE))
=>
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval ?speed)))
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D><LA FINAL> no rule activated, default moment speed_limit is " ?speed crlf))
)

;
;-------Check percepts to update restriction fluents-----------

;;----------------------------------
;;
;;    Situatie 1
;;    European 100 - Localitate 50 - European 100
;;
;;----------------------------------


; (defrule AGENT::sign-speed-limit
;     (declare (salience -10))
;     (timp (valoare ?t))
;     ?f <- (ag_bel
;             (bel_type moment) ; indicator vazut
;             (bel_pobj ?)
;             (bel_pname viteza_maxima_admisa)
;             (bel_pval ?limita_viteza))
;     ?s <- (ag_bel ; belief limita viteza
;             (bel_type moment)
;             (bel_pname speed_limit)
;             (bel_pval ?)
;     )
; =>
;     (modify ?s (bel_pval ?limita_viteza))
;     ; (assert (ag_bel
;     ;             (bel_type moment)
;     ;             ;(bel_timeslice 0)
;     ;             (bel_pname speed)
;     ;             (bel_pval 100)))
;     (if (eq ?*ag-in-debug* TRUE) then (printout t " interzis peste " ?limita_viteza  crlf))
;     (retract ?f)
;     ; (facts AGENT)
; )
;---------Delete auxiliary facts which are no longer needed ----------
;
; Programmer's task
;
