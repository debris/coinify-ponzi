{
	[0] "CoinifyPonzi"
	(call 0x929b11b8eeea00966e873a241d4b67f7540d1f38 0 0 0 12 0 0) 			; register contract name

	(return 0 (lll {
		(when (!= calldatasize 32) (stop))      	; stop if there's not enough data passed.
		(if (== (calldataload 0) 0) ( 				; if it is case 0
			(when (<= callvalue @@("MIN")) (stop)) 	; stop if there is not enough money sent
			[["MIN"]] (callvalue) 					; store minimum
			
			[user_balance] @@(caller) 				; load user balance from storage
			[["TOTAL_MONEY"]] (+ @@("TOTAL_MONEY") (callvalue)) 		; increase total amount of money
			[[caller]] (+ @user_balance (callvalue)) 					; increase user 'account' 

			(when (== @user_balance 0) ( 				   		; increase number of people who has accounts
				[["PEOPLE_COUNT"]] (+ @@("PEOPLE_COUNT") 1)  
			))			
			
		) ( 										; else is withdraw
			(when (== @@(caller) 0) (stop) )
			
			[[caller]] (0)
			[people_count] @@("PEOPLE_COUNT")
			[total_money] @@("TOTAL_MONEY")
			[withraw_money] (/ @total_money @people_count)
				
			[["TOTAL_MONEY"]] (- total_money withraw_money)
			[["PEOPLE_COUNT"]] (- people_count 1)

			(call (caller) (@withraw_money) 0 0 0 0 0) 		; widthraw money
		)
	) ; end if (== (calldataload 0) 0) (..) (..)
  	} 0))
}
