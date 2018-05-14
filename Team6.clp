(deftemplate available-items (slot item))
(deftemplate current-amounts (slot amount))

;This allows the user to enter the amount to the vendor machine and select the item

(deffunction getitem (?items ?item)
	(if (lexemep ?items)
	then 
		(bind ?items (lowcase ?items))
		(if (or (eq ?items "5")(eq ?items "R5")(eq ?items "5.00")(eq ?items "R5.00"))
		then 
			(bind ?items (+ ?item 5.00))
		else
			(if (or (eq ?items "2")(eq ?items "R2")(eq ?items "2.00")(eq ?items "R2.00")) 
			then 
				(bind ?items (+ ?item 2.00))
			else
				(if (or (eq ?items "1")(eq ?items "R1")(eq ?items "1.00")(eq ?items "R1.00")) 
				then 
					(bind ?itemss (+ ?item 1.00))
				else
					(if (or (eq ?items "50")(eq ?items "50c")(eq ?items "0.50")(eq ?items "0.50c")) 
					then 
						(bind ?items (+ ?item 0.50))
					else
						(if (or (eq ?items "20")(eq ?items "20c")(eq ?items "0.20")(eq ?items "0.20c"))
						then 
							(bind ?items (+ ?item 0.20))
						else
							(if (or (eq ?items "10")(eq ?items "10c")(eq ?items "0.10")(eq ?items "0.10c"))
							then 
								(bind ?items (+ ?item 0.10))
							else
								(bind ?items ?item) 
								(printout t "Please enter amount with ZAR cureency: " crlf)
							)
						)
					)
				)
			)
		)
	else
		(bind ?items ?item) 
		(printout t "You did not enter the currency or try again!" crlf)
	)
	(return ?items)
)

(defrule Start
	=>
	(printout t "These are the items in the vending maching:" 
	    crlf " This is Team Six Vending machine"
	    crlf "================================================"
		crlf "	1 -- (Cola 		    R8.50)"
		crlf "	2 -- (Orange		R10.00)"
		crlf "	3 -- (Sweets		R12.50)"
		crlf "	4 -- (Chocolate	    R15.00)" crlf)
	(bind ?ans (readline))
	(if (eq ?ans "1")
	then
		(assert(current-amounts (amount 8.50)))
	else
		(if (eq ?ans "2")
		then
			(assert(current-amounts (amount 10.00)))
		else
			(if (eq ?ans "3")
			then
				(assert(current-amounts (amount 12.50)))
			else
				(if (eq ?ans "4")
				then
					(assert(current-amounts (amount 15.00)))
				else
					(reset)
					(run)
				)
			)
		)
	)
)

(defrule calculate
	?fact <- (available-items (item ?num))
	(current-amounts (amount ?entedAmt&~:(>= ?num ?entedAmt)))
	=>
	(printout t crlf "Please enter the amount: R" ?entedAmt  crlf " Enter the above R"   ?num crlf)
	(bind ?ans (readline))
		(retract ?fact)					
		(assert (current-value (item (getitem ?ans ?num) )))
)

(defrule getAmount 
	?fact <- (available-items (item ?total))
	(current-amounts (amount ?entedAmt&:(>= ?total ?entedAmt)))
	=>
	(bind ?thoseA (- ?total ?entedAmt))
	(printout t crlf "Received amount entered: R" ?total "   Balance : R" ?thoseA crlf crlf crlf) 
		(retract ?fact)
		(reset)
		(run)
)

(deffacts machines 
	(current-amounts (item 0))	
)
