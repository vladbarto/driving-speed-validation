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

;;----------------------------------
;;
;;    Autostrada
;;
;;----------------------------------
(defrule AGENT::initCycle-viteza-autostrada
    (declare (salience 89))
    (timp (valoare 1))
    (ag_bel (bel_type moment) (bel_pname is_a) (bel_pval autostrada))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <DEFAULT SPEED> 130 by default as fluent bel" crlf))
    (assert (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 130)))
    (facts AGENT)
)

;;----------------------------------
;;
;;    Senzor vizibilitate redusa
;;
;;----------------------------------
(defrule AGENT::senzor-vizibilitate-redusa-afara
    (declare (salience 25))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval senzor))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname semnificatie) (bel_pval vizibilitate_redusa))
    (not (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 50))) 
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <INDICATOR> Vizibilitate redusa: afara din localitate" crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 50)))
)

(defrule AGENT::senzor-vizibilitate-redusa-localitate
    (declare (salience 25))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval senzor))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname semnificatie) (bel_pval vizibilitate_redusa))
    (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 50)) 
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <INDICATOR> Vizibilitate redusa: in localitate" crlf))
    (modify ?s (bel_type TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 30)))
)

(defrule AGENT::senzor-vizibilitate-redusa-autostrada
    (declare (salience 25))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval senzor))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname semnificatie) (bel_pval vizibilitate_redusa))
    (not (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 50)))
    (not (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 90))) 
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <INDICATOR> Vizibilitate redusa: autostrada" crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 50)))
    ; (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval ?speed)))   
)

;;----------------------------------
;;
;;    Trecere tren
;;
;;----------------------------------
(defrule AGENT::trecere-tren-fara-bariera
    (declare (salience 20))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname is_a) (bel_pval trecere_tren))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname bariera) (bel_pval no))
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TRAIN> Trecere tren fara bariera" crlf))
    (modify ?s (bel_type TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 0)))    
)

(defrule AGENT::trecere-tren-cu-bariera-afara
    (declare (salience 25))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval trecere_tren))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname bariera) (bel_pval yes))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname stare_bariera) (bel_pval bariera_sus))
    (not (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 50))) 
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TRAIN> Trecere tren cu bariera: afara din localitate" crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 90)))
    ; (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval ?speed)))   
)

(defrule AGENT::trecere-tren-cu-bariera-localitate
    (declare (salience 25))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval trecere_tren))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname bariera) (bel_pval yes))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname stare_bariera) (bel_pval bariera_sus))
    (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 50)) 
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TRAIN> Trecere tren cu bariera: in localitate"  crlf))
    (modify ?s (bel_type TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 50)))
)

(defrule AGENT::trecere-tren-cu-bariera-afara
    (declare (salience 25))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval trecere_tren))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname bariera) (bel_pval yes))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname stare_bariera) (bel_pval bariera_jos))
    (not (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 50))) 
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TRAIN> Tren: afara din localitate"  crlf))
    (modify ?s (bel_pval TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 0)))
)

(defrule AGENT::trecere-tren-cu-bariera-localitate
    (declare (salience 25))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval trecere_tren))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname bariera) (bel_pval yes))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname stare_bariera) (bel_pval bariera_jos))
    (ag_bel (bel_type fluent) (bel_pname default_speed_limit) (bel_pval 50)) 
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <TRAIN> Tren: in localitate"  crlf))
    (modify ?s (bel_type TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 0)))
    ; (assert (ag_bel (bel_type fluent) (bel_pname speed_limit) (bel_pval ?speed)))   
)

;;----------------------------------
;;
;;    Scoala
;;
;;----------------------------------
(defrule AGENT::scoala
    (declare (salience 20))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname is_a) (bel_pval indicator))
    (ag_bel (bel_type moment) (bel_pobj ?tp) (bel_pname semnificatie) (bel_pval scoala))
    ?s<-(ag_bel (bel_type moment) (bel_pname speed_limit_exists))
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <SCHOOL> Scoala" crlf))
    (modify ?s (bel_type TRUE))
    (assert (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval 30)))    
)

;; limo driving

;---------Auxiliary task: when indicator perceived from distance (nu esti fix in dreptul lui, aka mai ai fix 0 metri pana la el)
;     sa asertezi viteza corecta a masinii
(deffunction AGENT::calcule-viteza-decrementala (?v0 ?acc ?delta_x)
    (bind ?v1 (sqrt (+ (* ?v0 ?v0) (* 2 ?acc ?delta_x)))) ; Galilei's equation
    (return ?v1)
)

(defrule AGENT::indicator-start-la-distanta
    (declare (salience 8)) ; la final, dupa ce deja am determinat limita de viteza maxima admisa
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval indicator))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname semnificatie) (bel_pval impunere_restrictie_viteza))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname valoare) (bel_pval ?speed))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname distanta_pana_la_indicator) (bel_pval ?dist))
    ?nr_ind_perc <- (ag_bel (bel_type fluent) (bel_pname indicator_perceput) (bel_pval FALSE)) ; daca abia acum incep sa percep indicatorul
    ?nr_dist <- (ag_bel (bel_type fluent) (bel_pname distanta_parcursa) (bel_pval ?dist_parcurs))
    (ag_bel (bel_type moment) (bel_pname speed_limit) (bel_pval ?get_speed)); get determined speed limit
=>
    (modify ?nr_ind_perc (bel_pval TRUE)) ; marchez ca am inceput sa masor distanta parcursa de masina
    (assert (ag_bel (bel_type fluent) (bel_pname ultima_borna) (bel_pval ?dist))) ; tinem minte care e ultima distanta vazuta, pentru ca la timpul urmator sa pot face delta x
    (assert (ag_bel (bel_type moment) (bel_pname limo_speed_limit) (bel_pval ?get_speed))) ; evident ca la momentul 0 in care vad indicatorul nu apuc sa reduc viteza
    (assert (ag_bel (bel_type fluent) (bel_pname limo_speed_limit) (bel_pval ?get_speed))) ; evident ca la momentul 0 in care vad indicatorul nu apuc sa reduc viteza
)

(defrule AGENT::indicator-meanwhile-la-distanta
    (declare (salience 8))
    (timp (valoare ?))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval indicator))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname semnificatie) (bel_pval impunere_restrictie_viteza))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname valoare) (bel_pval ?speed))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname distanta_pana_la_indicator) (bel_pval ?dist))
    (test (> ?dist 0))
    ?nr_ultima_borna <- (ag_bel (bel_type fluent) (bel_pname ultima_borna) (bel_pval ?ultima_borna))
    ?nr_ind_perc <- (ag_bel (bel_type fluent) (bel_pname indicator_perceput) (bel_pval TRUE)) ; daca abia acum incep sa percep indicatorul
    ?nr_dist <- (ag_bel (bel_type fluent) (bel_pname distanta_parcursa) (bel_pval ?dist_parcurs))
    ?nr_fluent_sp_lim <- (ag_bel (bel_type fluent) (bel_pname limo_speed_limit) (bel_pval ?initial_speed))
=>
    (bind ?delta_x (- ?ultima_borna ?dist))
    (bind ?new_dist_parcurs (+ ?delta_x ?dist_parcurs))
    (printout t "New Dist parcurs = " ?new_dist_parcurs " si dist parcurs " ?dist_parcurs crlf)
    ;(retract ?nr_dist)
    (bind ?final_sp (calcule-viteza-decrementala ?initial_speed -2.5 ?new_dist_parcurs))
    (assert (ag_bel (bel_type moment) (bel_pname limo_speed_limit) (bel_pval ?final_sp)))
    ;(assert (ag_bel (bel_type fluent) (bel_pname limo_speed_limit) (bel_pval ?final_sp)))
    ;(modify ?nr_fluent_sp_lim (bel_pval ?final_sp))
    ;(facts AGENT)
    ;(assert (ag_bel (bel_type fluent) (bel_pname distanta_parcursa) (bel_pval ?new_dist_parcurs)))
    ; (modify ?nr_dist (bel_pval ?new_dist_parcurs))
)

(defrule AGENT::indicator-reached
    (declare (salience 8))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname is_a) (bel_pval indicator))
    (ag_bel (bel_type moment) (bel_pobj ?indic) (bel_pname distanta_pana_la_indicator) (bel_pval ?dist&:(= ?dist 0)))
    ?nr_ind_perc <- (ag_bel (bel_type fluent) (bel_pname indicator_perceput))
    ?nr_ultima_borna <- (ag_bel (bel_type fluent) (bel_pname ultima_borna))
=>
    (modify ?nr_ind_perc (bel_pval FALSE))
    (retract ?nr_ultima_borna) ; Retractăm ultima bornă
    (retract ?nr_ind_perc) ; Retractăm ultima bornă

    (printout t "Indicatorul a fost atins sau depășit." crlf)
)
