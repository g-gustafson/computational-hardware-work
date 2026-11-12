Psudo code for the players turn. Made my Grant Gustafson


figure out what the cards suit is
figure out what the cards value is 
take that and give it to the user
do this for all the cards in the room 
then ask the user to input a number to indicate card they want to use
use the card 
rerun though the options of what the user can do in the room 

cards_in_room = 4

get_suits:
Suit for card_a:
araccumulator  = card_a logic shifted right 4 times
accumulator = accumulator and "11" / 3 # will give the suit of the card in accumulator
if accumulator is hearts 
    accumulator becomes card_a and "1111" / 15
    tell user card 1 is a heart and the hears value
if accumulator is diamonds
    accumulator becomes card_a and "1111" / 15
    tell user card a is a dimond and its value
if accumulator = 0 
    tell user this is a used card
else 
    accumulator becomes card_a and "1111" /15 
    tell user card is a monster and its value

Suit for card_b:
araccumulator  = card_b logic shifted right 4 times
accumulator = accumulator and "11" / 3 # will give the suit of the card in accumulator
if accumulator is hearts 
    accumulator becomes card_b and "1111" / 15
    tell user card 1 is a heart and the hears value
if accumulator is dimmonds
    accumulator becomes card_b and "1111" / 15
    tell user card a is a dimond and its value
if accumulator = 0 
    tell user this is a used card
else 
    accumulator becomes card_b and "1111" /15 
    tell user card is a monster and its value


Suit for card_c:
araccumulator  = card_c logic shifted right 4 times
accumulator = accumulator and "11" / 3 # will give the suit of the card in accumulator
if accumulator is hearts 
    accumulator becomes card_c and "1111" / 15
    tell user card 1 is a heart and the hears value
if accumulator is dimmonds
    accumulator becomes card_c and "1111" / 15
    tell user card a is a dimond and its value
if accumulator = 0 
    tell user this is a used card
else 
    accumulator becomes card_c and "1111" /15 
    tell user card is a monster and its value


Suit for card_d:
araccumulator  = card_b logic shifted right 4 times
accumulator = accumulator and "11" / 3 # will give the suit of the card in accumulator
if accumulator is hearts 
    accumulator becomes card_d and "1111" / 15
    tell user card 1 is a heart and the hears value
if accumulator is dimmonds
    accumulator becomes card_d and "1111" / 15
    tell user card a is a dimond and its value
if accumulator = 0 
    tell user this is a used card
else 
    accumulator becomes card_d and "1111" /15 
    tell user card is a monster and its value


use_cards: 
    prompt user it input value 1 for card_a 2 for card_b 3 for card_c and 4 for card_d 
    if input = 1
        if card_a = 0 
            tell user to pick new card
            jump to use_cards
        jump to use_card_a
    if input = 2 
        if card_b = 0
            tell uer to pick new card 
            jump to use_cards
        jump to use_card_b
    if input = 3 
        if card_c = 0 
            tell user to pick new card 
            jump to use_cards 
        jump to use_card_c
    if input = 4
        if card_d = 0 
            tell user to pick new card 
            jump to use_cards
        jump to use_card_c
    finished_use_cards:
        jump to get_suits



use_card_a:
    accumulator = suit of card #copy from above
    accumulator = accumulator and "11"
    if heart
        accumulator = card value
        heath = health + accumulator
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        cards_in_room--
        jump get suits
    if dimond 
        accumulator = card value
        weapon = accumulator
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        cards_in_room--
        jump get suits
    else
        accumulator = card value
        if accumulator > last_monster_killed
            health = health - accumulator
            jump clear memory a 
        last monster killed = accumulator 
        clear memory a: 
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        cards_in_room--
        jump get suits

use_card_b:
    accumulator = suit of card #copy from above
    accumulator = accumulator and "11"
    if heart
        accumulator = card value
        heath = health + accumulator
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        cards_in_room--
        jump get suits
    if dimond 
        accumulator = card value
        weapon = weapon + accumulator 
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        cards_in_room--
        jump get suits
    else
        accumulator = card value
        if weapon > last_monster_killed
            if weapon >= accumulator
                weapon = weapon - accumulator
                # clear card value in memory 
                accumulator = card logic shifted right 8
                sb $0, deck(accumulator)
                # clear regester
                card = 0
                cards_in_room--
                jump get suits
            #weapon is used but does not negate all dammage
            accumulator = accumulator - weapon 
            health = health - accumulator
            # clear card value in memory 
            accumulator = card logic shifted right 8
            sb $0, deck(accumulator)
            # clear regester
            card = 0
            cards_in_room--
            jump get suits
        #need to use fists to kill monseter
        health = heath - accumulator
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        cards_in_room--
        jump get suits

use_card_c:
    accumulator = suit of card #copy from above
    accumulator = accumulator and "11"
    if heart
        accumulator = card value
        heath = health + accumulator
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        cards_in_room--
        jump get suits
    if dimond 
        accumulator = card value
        weapon = weapon + accumulator 
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        cards_in_room--
        jump get suits
    else
        accumulator = card value
        if weapon > last_monster_killed
            if weapon >= accumulator
                weapon = weapon - accumulator
                # clear card value in memory 
                accumulator = card logic shifted right 8
                sb $0, deck(accumulator)
                # clear regester
                card = 0
                cards_in_room--
                jump get suits
            #weapon is used but does not negate all dammage
            accumulator = accumulator - weapon 
            health = health - accumulator
            # clear card value in memory 
            accumulator = card logic shifted right 8
            sb $0, deck(accumulator)
            # clear regester
            card = 0
            cards_in_room--
            jump get suits
        #need to use fists to kill monseter
        health = heath - accumulator
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        jump get suits

use_card_d:
    accumulator = suit of card #copy from above
    accumulator = accumulator and "11"
    if heart
        accumulator = card value
        heath = health + accumulator
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        cards_in_room--
        jump get suits
    if dimond 
        accumulator = card value
        weapon = weapon + accumulator
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        cards_in_room--
        jump get suits
    else
        accumulator = card value
        if weapon > last_monster_killed
            if weapon >= accumulator
                weapon = weapon - accumulator
                # clear card value in memory 
                accumulator = card logic shifted right 8
                sb $0, deck(accumulator)
                # clear regester
                card = 0
                cards_in_room--
                jump get suits
            #weapon is used but does not negate all dammage
            accumulator = accumulator - weapon 
            health = health - accumulator
            # clear card value in memory 
            accumulator = card logic shifted right 8
            sb $0, deck(accumulator)
            # clear regester
            card = 0
            cards_in_room--
            jump get suits
        #need to use fists to kill monseter
        health = heath - accumulator
        # clear card value in memory 
        accumulator = card logic shifted right 8
        sb $0, deck(accumulator)
        # clear regester
        card = 0
        cards_in_room--
        jump get suits




finish_use_X:
    if health <= 0, game ends
    if monsters <= 0 game end
    j continue play
    nop
    game ends:
        j end of game
    continue play:
