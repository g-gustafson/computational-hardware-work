.data
    deck:        .byte 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,  18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,  34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46,  50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62
    deck_Temp:    .byte 0:25
    rMultiplier: .word 1664525
    rIncrement:  .word 1013904223

    

    #########################
	# Card Printing Strings #
	#########################

    # Messages/Misc
    cards_picked: .asciiz "Cards: "
	entered_card: .asciiz "Enter selected card (1-4): "
	newline:      .asciiz "\n"
    comma:        .asciiz ", "

    # Suite strings
    spades:   .asciiz "♠"
    hearts:   .asciiz "♥"
    diamonds: .asciiz "♦"
    clubs:    .asciiz "♣"

    # Card
    ace:   .asciiz "A"   # when accumulator = 14
    king:  .asciiz "K"   # when accumulator = 13
    queen: .asciiz "Q"   # when accumulator = 12
    jack:  .asciiz "J"   # when accumulator = 11
	empty: .asciiz "X"   # when accumulator = 0

.text
main:
################################################################
#####               Reserved Registers                     #####
#####               $s0 - health                           #####
#####               $s1 - card_a                           #####
#####               $s2 - card_b                           #####
#####               $s3 - card_c                           #####
#####               $s4 - card_d                           #####
#####               $s5 - weapon                           #####
#####               $s7 - random seed                      #####
#####                                                      #####
#####               $t0 - accumulator                      #####
#####               $t1 - iterator                         #####
#####               $t2 - deck_size                        #####
#####               $t3 - deck_top                         #####
#####               $t4 - monsters                         #####
#####               $t5 - room_skip                        #####
#####               $t6 - top_card                         #####
#####               $t7 - last_monster_killed              #####
#####               $t8 - cards_in_room                    #####
#####               $t9 - second_accumulator               #####
#####                                                      #####
#####               $a3 - temporary holder for user inputs #####
#####                                                      #####
################################################################

    li $s7, 1773704637  # random seed initialization 

#shuffle 7 times lol
jal shuffle
nop
jal shuffle
nop
jal shuffle
nop
# pete if you are watching this code run for some reasons i did not copy and paste the 7 shuffle calls i typed them all out 

#Game loop

#initializing variables
addi $t3, $0, 0 # setting the offset of the top of the deck to 0
addi $t4, $0, 26 # setting number of monsters 
addi $t2, $0, 52 #setting number of cards in deck
addi $s0, $0, 20 #setting player health to 20 
addi $s5, $0, 0 # setting weapon to 0
addi $t8, $0, 0 # setting number of cards in room to 4
addi $t7, $0, 0 # setting last value of monsters killed to 0
#getting the cards
game_loop:
j get_new_card
fill_cards:
    bne $s1, $0, check_b # branch if not equal to 0 (card exists and is there) 
    nop
        addi $s1, $t6, 0 # make card_a equal the top card gotten with get new card
        j get_new_card
        nop
    check_b:
    bne $s2, $0, check_c # branch if not equal to 0 (card exists and is there)
    nop
        addi $s2, $t6, 0 # make card_b equal the top card gotten with get new card
        j get_new_card
        nop
    check_c:
        bne $s3, $0, check_d # branch if not equal to 0 (card exists and is there)
        nop
        addi $s3, $t6, 0 # make card_c equal the top card gotten with get new card
        j get_new_card
        nop
    check_d:
        bne $s4, $0, cards_gotten # branch if not equal to 0 (card exists and is there)
            nop
            addi $s4, $t6, 0 # make card_d equal the top card gotten with get new card
        j cards_gotten
        nop
get_new_card: 
    lb $t6, deck($t3) # getting the card from the deck and putting it in the top register
    bne $t6, $0, continue_get_new_card # if the card does not exist
    nop
        addi $t3, $t3, 1
        addi $t0, $0, 52
        beq $t3, $t0, wrap_deck # if deck top is after the end of the deck
        nop 
            j get_new_card
            nop
        wrap_deck: 
            addi $t3, $0, 0 # set top deck back to 0
            j get_new_card
            nop
        
    continue_get_new_card:
        sll $t0, $t3, 8 
        or $t6, $t6, $t0 # storing where the card is in the deck in the register so we can 0 it later
        addi $t3, $t3, 1
        bne $t3, $t0, continue_get_new_card_continued # if deck top after the end of the deck 
        nop
            addi $t3, $0, 0 # set top deck back to 0
    continue_get_new_card_continued:
j fill_cards
nop

cards_gotten:
addi $t8, $0, 4
get_suits: 
    suit_card_a:
        srl $t0, $s1, 4
        andi $t0, $t0, 3
        card_a_empty:
        addi $t9, $0, 0
        bne $s1, $t9, card_a_hearts
        nop
            #TODO: tell user this card is used
            	jal printCardFromAccumulator   # Call print function
                nop
            j suit_card_b
            nop
        card_a_hearts:
        addi $t9, $0, 0
        bne $t0, $t9, card_a_cDiamonds
        nop
            andi $t0, $s1, 15 #accumulator contains cards value
            #TODO: tell user card 1 is hearts and the hearts value
            	la $a2, hearts                 # Set $a2 value to whatever suite - spades here
	            jal printCardFromAccumulator   # Call print function
                nop
            j suit_card_b
            nop
        card_a_cDiamonds:
        addi $t9, $0, 1
        bne $t0, $t9, card_a_other
        nop
            andi $t0, $s1, 15 # accumulator contains cards value 
            #TODO: tell user card a is diamonds and its value 
            	la $a2, diamonds                 # Set $a2 value to whatever suite - spades here
	            jal printCardFromAccumulator   # Call print function
                nop
            j suit_card_b
            nop
        card_a_other:
            andi $t0, $s1, 15 # accumulator contains cards value 
            #TODO tell user card is a monster and cards value
                la $a2, spades                 # Set $a2 value to whatever suite - spades here
	            jal printCardFromAccumulator   # Call print function
                nop
            j suit_card_b
            nop



        
    suit_card_b:
        srl $t0, $s2, 4
        andi $t0, $t0, 3 # accumultro becomes the suit value
        card_b_empty:
        addi $t9, $0, 0
        bne $s2, $t9, card_b_hearts
        nop
            #TODO: tell user this card is used
            	jal printCardFromAccumulator   # Call print function
                nop
            j suit_card_c
            nop
        card_b_hearts:
        addi $t9, $0, 0
        bne $t0, $t9, card_b_cDiamonds
        nop
            andi $t0, $s2, 15 #accumulator contains cards value
            #TODO: tell user card 1 is hearts and the hearts value
                la $a2, hearts                 # Set $a2 value to whatever suite - spades here
	            jal printCardFromAccumulator   # Call print function
                nop
            j suit_card_c
            nop
        card_b_cDiamonds:
        addi $t9, $0, 1
        bne $t0, $t9, card_b_other
        nop
            andi $t0, $s2, 15 # accumulator contains cards value 
            #TODO: tell user card a is diamonds and its value 
                la $a2, diamonds                 # Set $a2 value to whatever suite - spades here
	            jal printCardFromAccumulator   # Call print function
                nop
            j suit_card_c
            nop
        card_b_other:
            andi $t0, $s2, 15 # accumulator contains cards value 
            #TODO tell user card is a monster and cards value
                la $a2, spades                 # Set $a2 value to whatever suite - spades here
	            jal printCardFromAccumulator   # Call print function
                nop
            j suit_card_c
            nop


    
    suit_card_c:
        srl $t0, $s3, 4
        andi $t0, $t0, 3 # accumultro becomes the suit value
        card_c_empty:
        addi $t9, $0, 0
        bne $s3, $t9, card_c_hearts
        nop
            #TODO: tell user this card is used
            	jal printCardFromAccumulator   # Call print function
                nop
            j suit_card_d
            nop
        card_c_hearts:
        addi $t9, $0, 0
        bne $t0, $t9, card_c_cDiamonds
        nop
            andi $t0, $s3, 15 #accumulator contains cards value
            #TODO: tell user card 1 is hearts and the hearts value
                	la $a2, hearts                 # Set $a2 value to whatever suite - spades here
	                jal printCardFromAccumulator   # Call print function
                    nop
            j suit_card_d
            nop
        card_c_cDiamonds:
        addi $t9, $0, 1
        bne $t0, $t9, card_c_other
        nop
            andi $t0, $s3, 15 # accumulator contains cards value 
            #TODO: tell user card a is diamonds and its value
                	la $a2, diamonds                 # Set $a2 value to whatever suite - spades here
	                jal printCardFromAccumulator   # Call print function 
                    nop
            j suit_card_d
            nop
        card_c_other:
            andi $t0, $s3, 15 # accumulator contains cards value 
            #TODO tell user card is a monster and cards value
                	la $a2, clubs                 # Set $a2 value to whatever suite - spades here
	                jal printCardFromAccumulator   # Call print function
                    nop
            j suit_card_d
            nop
             

    

    suit_card_d:
        srl $t0, $s4, 4
        andi $t0, $t0, 3 # accumultro becomes the suit value
        card_d_empty:
        addi $t9, $0, 0
        bne $s4, $t9, card_d_hearts
        nop
            #TODO: tell user this card is used
            	jal printCardFromAccumulator   # Call print function
                nop
            j use_cards
            nop
        card_d_hearts:
        addi $t9, $0, 0
        bne $t0, $t9, card_d_cDiamonds
        nop
            andi $t0, $s4, 15 #accumulator contains cards value
            #TODO: tell user card 1 is hearts and the hearts value
                	la $a2, hearts                 # Set $a2 value to whatever suite - spades here
	                jal printCardFromAccumulator   # Call print function
                    nop
            j use_cards
            nop
        card_d_cDiamonds:
        addi $t9, $0, 1
        bne $t0, $t9, card_d_other
        nop
            andi $t0, $s4, 15 # accumulator contains cards value 
            #TODO: tell user card a is diamonds and its value 
                la $a2, diamonds                 # Set $a2 value to whatever suite - spades here
	            jal printCardFromAccumulator   # Call print function
                nop
            j use_cards
            nop
        card_d_other:
            andi $t0, $s4, 15 # accumulator contains cards value 
            #TODO tell user card is a monster and cards value
                la $a2, clubs                 # Set $a2 value to whatever suite - spades here
	            jal printCardFromAccumulator   # Call print function
                nop
            j use_cards
            nop


use_cards:
    #TODO: prompt user to input values (refer to psuedo code for key line 79)
    jal getEnteredCard
    nop
    check_input_a:
        addi $t0, $0, 1
        bne $a3, $t0, check_input_b #if input is 1
            bne $s1, $0, continue_card_a # if card is 0 
            nop
                #TODO: tell user to pick new card
                j use_cards
                nop
            continue_card_a:
            j use_card_a
            nop


    check_input_b:
        addi $t0, $0, 2
        bne $a3, $t0, check_input_c #if input is 2
           bne $s2, $0, continue_card_b # if card is 0 
           nop
                #TODO: tell user to pick new card
                j use_cards
                nop
            continue_card_b:
            j use_card_b
            nop 


    check_input_c:
        addi $t0, $0, 3
        bne $a3, $t0, check_input_d #if input is 3
           bne $s3, $0, continue_card_c # if card is 0 
           nop
                #TODO: tell user to pick new card
                j use_cards
                nop
            continue_card_c:
            j use_card_c
            nop 


    check_input_d:
        addi $t0, $0, 4
        bne $a3, $t0, continue #if input is 4
        continue:
           bne $s4, $0, continue_card_d # if card is 0 
           nop
                #TODO: tell user to pick new card
                j use_cards
                nop
            continue_card_d:
            j use_card_d
            nop 


use_card_a:
    addi $t0, $s1, 0 # make accumulator equal to card a
    srl $t0, $t0, 4 # shift accumulator right 4 bits
    andi $t0, $t0, 3 # suit value

    addi $t9, $0, 0 # suit value set to 0 (hearts are 0)
    bne $t0, $t9, a_use_diamond # branch if not 0 (not a heart suit)
    nop
        andi $t0, $s1, 15 # accumulator gets value of card
        add $s0, $s0, $t0 # health = health + accumulator
        addi $t0, $s0, -21
        blez $t0, a_use_health_continue
        nop
            addi $s0, $0, 20 # sets health back to 20 if it was over
        a_use_health_continue:
        j clear_memory_a
        nop

    a_use_diamond:
        addi $t9, $0, 1 # suit value set to 1 (diamonds are 1)
        bne $t0, $t9, a_use_other # branch if not equal (not a diamond suit)
        nop

        andi $t0, $s1, 15 # accumulator gets value of card
        add $s5, $0, $t0 # weapon = accumulator
        j clear_memory_a
        nop

    a_use_other:
        andi $t0, $s1, 15 # accumulator gets value of card
        sub $t9, $t0, $t7
        blez $t9, a_use_kill # if card value is greater then last monster 
        nop
            sub $s0, $s0, $t0 # you cant use weapon so you loose health equal to the monsters value
            addi $t4, $s0, -1
            j clear_memory_a
            nop
        a_use_kill:
        sub $t9, $t0, $s5 # second accumulator becomes difference between monster - weapon (if posotive loose life)
        blez $t9, no_damage_a # if difference is <= 0 branch 
        nop
            sub $s0, $s0, $t9
        no_damage_a:
        addi $t7, $t0, 0 # last monster killed becomes the value of the current monster
        addi $t4, $t4, -1
        j clear_memory_a
        nop
        
        clear_memory_a:
        srl $t0, $s1, 8 # accumulator gets card logic shifted right 8 to get memory location
        sb $0, deck($t0)
        addi $s1, $0, 0 # card a set to 0
        addi $t8, $t8, -1 # decrement cards in room by 1
        j game_end
        nop



use_card_b:
    addi $t0, $s2, 0 # make accumulator equal to card a
    srl $t0, $t0, 4 # shift accumulator right 4 bits
    andi $t0, $t0, 3 # suit value

    addi $t9, $0, 0 # suit value set to 0 (hearts are 0)
    bne $t0, $t9, b_use_diamond # branch if not 0 (not a heart suit)
    nop
        andi $t0, $s2, 15 # accumulator gets value of card
        add $s0, $s0, $t0 # health = health + accumulator
        addi $t0, $s0, -21
        blez $t0, b_use_health_continue
        nop
            addi $s0, $0, 20 # sets health back to 20 if it was over
        b_use_health_continue:
        j clear_memory_b
        nop

    b_use_diamond:
        addi $t9, $0, 1 # suit value set to 1 (diamonds are 1)
        bne $t0, $t9, b_use_other # branch if not equal (not a diamond suit)
        nop

        andi $t0, $s2, 15 # accumulator gets value of card
        add $s5, $0, $t0 # weapon = accumulator
        j clear_memory_b
        nop

    b_use_other:
        andi $t0, $s2, 15 # accumulator gets value of card
        sub $t9, $t0, $t7
        blez $t9, b_use_kill # if card value is greater then last monster 
        nop
            sub $s0, $s0, $t0 # you cant use weapon so you loose health equal to the monsters value
            addi $t4, $s0, -1
            j clear_memory_b
            nop
        b_use_kill:
        blez $t9, no_damage_b # if difference is <= 0 branch 
        nop
            sub $s0, $s0, $t9
        no_damage_b:
        addi $t7, $t0, 0 # last monster killed becomes the value of the current monster
        addi $t4, $t4, -1
        j clear_memory_b
        nop
        
        clear_memory_b:
        srl $t0, $s2, 8 # accumulator gets card logic shifted right 8 to get memory location
        sb $0, deck($t0)
        addi $s2, $0, 0 # card a set to 0
        addi $t8, $t8, -1 # decrement cards in room by 1
        j game_end
        nop


use_card_c:
    addi $t0, $s3, 0 # make accumulator equal to card a
    srl $t0, $t0, 4 # shift accumulator right 4 bits
    andi $t0, $t0, 3 # suit value

    addi $t9, $0, 0 # suit value set to 0 (hearts are 0)
    bne $t0, $t9, c_use_diamond # branch if not 0 (not a heart suit)
    nop
        andi $t0, $s3, 15 # accumulator gets value of card
        add $s0, $s0, $t0 # health = health + accumulator
        addi $t0, $s0, -21
        blez $t0, c_use_health_continue
        nop
            addi $s0, $0, 20 # sets health back to 20 if it was over
        c_use_health_continue:
        j clear_memory_c
        nop

    c_use_diamond:
        addi $t9, $0, 1 # suit value set to 1 (diamonds are 1)
        bne $t0, $t9, c_use_other # branch if not equal (not a diamond suit)
        nop

        andi $t0, $s3, 15 # accumulator gets value of card
        add $s5, $0, $t0 # weapon = accumulator
        j clear_memory_c
        nop

    c_use_other:
        andi $t0, $s3, 15 # accumulator gets value of card
        sub $t9, $t0, $t7
        blez $t9, c_use_kill # if card value is greater then last monster 
        nop
            sub $s0, $s0, $t0 # you cant use weapon so you loose health equal to the monsters value
            addi $t4, $s0, -1
            j clear_memory_c
            nop
        c_use_kill:
        blez $t9, no_damage_c # if difference is <= 0 branch 
        nop
            sub $s0, $s0, $t9
        no_damage_c:
        addi $t7, $t0, 0 # last monster killed becomes the value of the current monster
        addi $t4, $t4, -1
        j clear_memory_c
        nop
        
        clear_memory_c:
        srl $t0, $s3, 8 # accumulator gets card logic shifted right 8 to get memory location
        sb $0, deck($t0)
        addi $s3, $0, 0 # card a set to 0
        addi $t8, $t8, -1 # decrement cards in room by 1
        j game_end
        nop



use_card_d:
    addi $t0, $s4, 0 # make accumulator equal to card a
    srl $t0, $t0, 4 # shift accumulator right 4 bits
    andi $t0, $t0, 3 # suit value

    addi $t9, $0, 0 # suit value set to 0 (hearts are 0)
    bne $t0, $t9, d_use_diamond # branch if not 0 (not a heart suit)
    nop
        andi $t0, $s4, 15 # accumulator gets value of card
        add $s0, $s0, $t0 # health = health + accumulator
        addi $t0, $s0, -21
        blez $t0, d_use_health_continue
        nop
            addi $s0, $0, 20 # sets health back to 20 if it was over
        d_use_health_continue:
        j clear_memory_d
        nop

    d_use_diamond:
        addi $t9, $0, 1 # suit value set to 1 (diamonds are 1)
        bne $t0, $t9, d_use_other # branch if not equal (not a diamond suit)
        nop

        andi $t0, $s4, 15 # accumulator gets value of card
        add $s5, $0, $t0 # weapon = accumulator
        j clear_memory_d
        nop

    d_use_other:
        andi $t0, $s4, 15 # accumulator gets value of card
        sub $t9, $t0, $t7
        blez $t9, d_use_kill # if card value is greater then last monster 
        nop
            sub $s0, $s0, $t0 # you cant use weapon so you loose health equal to the monsters value
            addi $t4, $s0, -1
            j clear_memory_d
            nop
        d_use_kill:
        blez $t9, no_damage_d # if difference is <= 0 branch 
        nop
            sub $s0, $s0, $t9
        no_damage_d:
        addi $t7, $t0, 0 # last monster killed becomes the value of the current monster
        addi $t4, $t4, -1
        j clear_memory_d
        nop
        
        clear_memory_d:
        srl $t0, $s4, 8 # accumulator gets card logic shifted right 8 to get memory location
        sb $0, deck($t0)
        addi $s4, $0, 0 # card a set to 0
        addi $t8, $t8, -1 # decrement cards in room by 1
        j game_end
        nop
            
game_end:
    blez $s0, end_game
    nop
    blez $t4, end_game
    nop
    addi $t0, $0, 1
    bne $t0, $t8 stay_in_room
        j game_loop
        nop
    stay_in_room:
    j get_suits
    nop

    end_game:
    j end
    nop

# exit progam - syscall 10 = exit program in QtSpim
end:    
    li $v0, 10
    syscall


# updates the random seed with a new random number
# using the formula SEED = SEED*MULTIPLIER + INCREMENT
# s7 - random seed / number
# t0 - temporary multiplier
# t1 - temporary increment
updateRandomSeed:         
    lw $t0, rMultiplier    # load in constant multiplier
    lw $t1, rIncrement     # load in constant increment

    mul $s7, $t0, $s7      # multiply random seed by the multiplier constant
    addu $s7, $s7, $t1     # increment by the constant

    jr $ra                 # return


# shuffle the deck


        # get a random value
        # take the first value in each array and use the random number to decide which one goes into the deck array first
        # repeat this process till new array is empty
        # repeat all steps except making new array 7 total times. 
        # contain two loops


shuffle:
	    # 1. Copy first half into temp array
    add $t0, $0, 25 # load index (0 to 25 - loop 26 times)

    prepare_deck_loop:

        lb $t1, deck($t0)     # pull the byte value from deck[$t0] into t3
        sb $t1, deck_Temp($t0) # load t3 value into tempDeck[$t0]

        addiu $t0, $t0, -1
        bgez $t0, prepare_deck_loop # while index >= 0
    
    # 2. Shuffle deck and tempDeck

    for_loop_done:
	#jal generate_random

	addi $t3, $0, 0	 # iterator for where to put cards in deck
    addi $t6, $0, 0 # iterator for where we are in the deck (Had error were only looking at top two cards) 
	addi $t5, $s7, 0 # random value to destructable register
	riffle:
		addi $t0, $t6, 27
		lb $t1, deck($t0)     # card a
		lb $t2, deck_Temp($t6) # card b
		andi $t4, $t5, 1      # random point
		
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
		addi $t3, $t3, 1 # iterator (for where to put cards)++
        addi $t6, $t6, 1 # iterator (for where you are in deck)+
		srl  $t5, $t5, 1 # shift random for next bit
		# check if loop finished
		addi $t0, $t3, -52
		bne $t0, $0, riffle 
        nop
    
    jr $ra
    nop



# Should prompt the user to pick a card between 1 and 4. Input value is then checked and stored in $a3
getEnteredCard:
	li $v0, 4   # syscall code 4 - print string
	la $a0, entered_card
	syscall

	li $v0, 5   # syscall code 5 - read integer
	syscall

	add $a3, $0, $v0    # Store the return value into $a3

	jr $ra

# Should print card value from $t0 accumulator (2,3,4,5,6,7,8,9,J,Q,K,A) and suite from $a2
printCardFromAccumulator:

	li $v0, 4   # syscall code 4 - print string
	

	addi $t9, $0, 14   # 14 - ace
	beq $t0, $t9, printAce

	addi $t9, $0, 13   # 13 - king
	beq $t0, $t9, printKing

	addi $t9, $0, 12   # 12 - queen
	beq $t0, $t9, printQueen

	addi $t9, $0, 11   # 11 - jack
	beq $t0, $t9, printJack

	beqz $t0, printNone   # 0 - NONE
	

	printNumber: # Print the card number
		li $v0, 1   # syscall code 1 - print int
		add $a0, $0, $t0
		syscall
		j printSuite

	printAce:   # Print "A" (ace, $t0 = 14)
		la $a0, ace
		syscall
		j printSuite

	printKing:   # Print "K" (king, $t0 = 13)
		la $a0, king
		syscall
		j printSuite

	printQueen:   # Print "Q" (queen, $t0 = 12)
		la $a0, queen
		syscall
		j printSuite

	printJack:   # Print "J" (jack, $t0 = 11)
		la $a0, jack
		syscall
		j printSuite

	printNone:   # Print "X" (no selection, $t0 = 0)
		la $a0, empty
		syscall
		j printDone

	printSuite:   # Print suite stored in $a2
		li $v0, 4   # syscall code 4 - print string
		addu $a0, $0, $a2
		syscall

	printDone:   # Return
		jr $ra 
		nop