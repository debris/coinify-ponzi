{
	[0] "CoinifyPonzi"
	(call 0x929b11b8eeea00966e873a241d4b67f7540d1f38 0 0 0 12 0 0) 			

	(return 0 (lll {
		(when (!= calldatasize 32) (stop))
		(if (= (calldataload 0) 0)
		{ 				
			(when (<= callvalue @@("MIN")) (stop)) 	
			[["MIN"]] (callvalue) 					
			
			[user_balance] @@(caller) 				
			[["TOTAL_MONEY"]] (+ @@("TOTAL_MONEY") (callvalue)) 	
			[[caller]] (+ @user_balance (callvalue)) 				

			(when (= @user_balance 0) { 				   		
				[["PEOPLE_COUNT"]] (+ @@("PEOPLE_COUNT") 1)  
			})			
			
		}
		{				
			(when (= @@(caller) 0) (stop) )
			
			[[caller]] (0)
			[people_count] @@("PEOPLE_COUNT")
			[total_money] @@("TOTAL_MONEY")
			[withdraw_money] (/ @total_money @people_count)
				
			[["TOTAL_MONEY"]] (- @total_money @withdraw_money)
			[["PEOPLE_COUNT"]] (- @people_count 1)

			(call (caller) @withdraw_money 0 0 0 0 0)
		}
		)
  	} 0))
}
