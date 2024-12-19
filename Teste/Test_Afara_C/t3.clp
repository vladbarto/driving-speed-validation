; t3 curba periculoasa + indicator 40
; speed_limit 40

(ag_percept
	(percept_pobj road)
	(percept_pname curba)
	(percept_pval periculoasa)  
)

(ag_percept
	(percept_pobj situatie3)
	(percept_pname is_a)
	(percept_pval indicator)
)

(ag_percept
	(percept_pobj situatie3)
	(percept_pname semnificatie)
	(percept_pval impunere_restrictie_viteza)
)

(ag_percept
	(percept_pobj situatie3)
	(percept_pname valoare)
	(percept_pval 40)
)