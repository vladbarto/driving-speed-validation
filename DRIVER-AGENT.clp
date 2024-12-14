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
    (ag_bel (bel_type moment) (bel_pname is_a) (bel_pval drum_european))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <DEFAULT SPEED> 100 by default as fluent bel" crlf))
    (assert (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 100)))
    (facts AGENT)
)

(defrule AGENT::initCycle-viteza-alte-drumuri
    (declare (salience 89))
    (timp (valoare 1))
    (ag_bel (bel_type moment) (bel_pname is_a) (bel_pval drum_national|drum_judetean|drum_comunal))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <DEFAULT SPEED> 90 by default as fluent bel" crlf))
    (assert (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 90)))
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


(defrule AGENT::semafor-verde "don't modify speed limit, as it will be adapted by itself (see last command)"
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
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval ?val))
    (test (eq ?val FALSE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <INDICATOR><"?speed"> Limita viteza " ?speed " perceputa" crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval ?speed)))
    (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval ?speed)))
    (assert (trigger-computation-rule ?speed))
)

(defrule AGENT::indicator-end
    (declare (salience 20))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval indicator))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname semnificatie) (bel_pval sfarsit_restrictie_viteza))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname valoare) (bel_pval ?speed))
    ; ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
    ?r <- (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval ?speed))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <INDICATOR><"?speed"> Sfarsit Limita viteza " ?speed " perceputa" crlf))
    ; (modify ?s (bel_pval FALSE)) ; implicitly FALSE by initCycle routine
    (retract ?r)
)

;;----------------------------------
;;
;;    Indicatorare aditionale pentru cele cu limita de viteza
;;
;;----------------------------------
(defrule AGENT::indicator-aditional-conditii-de-vreme "regula care vrea sa impuna o limita de viteza daca afara vremea are o stare anume"
    (declare (salience 19))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indicator_aditional) (bel_pname is_a) (bel_pval indicator_aditional))
    (ag_bel (bel_type moment) (bel_pobj ?indicator_aditional) (bel_pname semnificatie) (bel_pval aplicabil_in_caz_de))
    (ag_bel (bel_type moment) (bel_pobj ?indicator_aditional) (bel_pname valoare) (bel_pval ?stare_indicator)) ; aka ploaie
    (ag_bel (bel_type moment) (bel_pobj senzor) (bel_pname stare_vreme) (bel_pval ?stare_reala)) ; aka senin
    (test (not (eq ?stare_reala ?stare_indicator)))
    ?s <- (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval ?))
    ?r <- (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval ?))
    ?sle <- (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval ?setting)) ;sle = speed limit exists
    (test (eq ?setting TRUE))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <INDICATOR ADITIONAL><Real "?stare_reala"> nu coincide cu <Indicator " ?stare_indicator "> perceput. Limita de viteza nu se aplica" crlf))
    (retract ?s)
    (retract ?r)
    ;(modify ?sle (bel_pval FALSE))
    ;(retract ?sle)
    ;(assert (ag_bel (bel_type moment) (bel_pname speed_limit_exists) (bel_pval FALSE)))
    ;(facts AGENT)
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
    (modify ?s (bel_pval TRUE))
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


;;----------------------------------
;;
;;    New feature
;;    Calculul distantei de adaptare a vitezei pentru indicatorul cerut
;;
;;----------------------------------
(deffunction AGENT::calcule (?v0 ?v1 ?miu ?k)
    ;; miu este coeficientul de frecare al automobilului cu drumul
    ;; pentru turisme mici, un miu bun ar fi 0.75
    ;; pentru tiruri, ceva mai mic, un 0.65

    ;; k este un coeficient ce determina eficienta franelor automobilului


    ;; Conversia vitezelor din km/h în m/s
    (bind ?v0_metri (/ ?v0 3.6)) 
    (bind ?v1_metri (/ ?v1 3.6)) 
    
    ;; Definirea accelerației gravitaționale
    (bind ?g 9.81) ;; în m/s^2
    
    ;; Calculează distanța de frânare
    (bind ?distanta (/ (- (* ?v0_metri ?v0_metri) (* ?v1_metri ?v1_metri)) 
                       (* 2 ?k ?miu ?g)))
    
    ;; Returnează distanța calculată
    (return ?distanta)
)

(defrule AGENT::reducing-distance-computation-1 "cazul in care soferul trebuie sa reduca de la default_speed_limit de pe categoria respectiva de drum la valoarea data de indicator"
    (declare (salience 10)) ; chiar ultima ultima
    (timp (valoare ?))
    ?r1 <- (trigger-computation-rule ?final_speed)
    (ag_bel (bel_pname kept_in_mind_speed_active) (bel_pval FALSE))
    (ag_bel (bel_pname default_speed_limit) (bel_pval ?initial_speed))
=>
    (retract ?r1)
    (if (eq ?*ag-in-debug* TRUE) then (printout t "...initial speed is " ?initial_speed crlf))
    (bind ?distanta (calcule ?initial_speed ?final_speed 0.75 0.85))
    (assert (ag_bel (bel_type moment) (bel_pobj tag_reducing_dist) (bel_pname distanta_in_metri_in_care_masina_poate_reduce_viteza) (bel_pval ?distanta)))
    (if (eq ?*ag-in-debug* TRUE) then (printout t "Distanta de reducere a vitezei de la " ?initial_speed " la " ?final_speed " este: " ?distanta " metri" crlf))
)
;---------Delete auxiliary facts which are no longer needed ----------
;
; Programmer's task
;
