shuffle:
	jal prepare_shuffle
	jal generate_random

	addi $t3, $0, 0	 # iterator
	addi $t4, $s7, 0 # random value to destructable register
	riffle:
		addi $t0, $0, 26
		lb $t1, deck($t0)     # card a
		lb $t2, deck_temp($0) # card b
		andi $t4, $s7, 1      # random point
		
		bne $t4, $0, riffle_alt
			sb   $t1, deck($t3) # a in deck
			addi $t3, $t3, 1    # iterator++
			sb   $t2, deck($t3) # b in deck
			j riffle_end
		riffle_alt:
			sb   $t2, deck($t3) # b in deck
			addi $t3, $t3, 1    # iterator++
			sb   $t1, deck($t3) # a in deck
		riffle_end:
		addi $t3, $t3, 1 # iterator++
		srl  $t4, $t4, 1 # shift random for next bit
		# check if loop finished
		addi $t0, $t3, -52
		bne $t3, $0, riffle 

