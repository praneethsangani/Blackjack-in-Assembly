#Praneeth Sangani (PRS79)

# --------------------------------
.data
deck: .byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 11, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 11, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 11, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 11
player: .byte 0:12
dealer: .byte 0:12
deck_index: .byte 0 
player_index: .byte 0 
dealer_index: .byte 0 
player_total: .byte 0
dealer_total: .byte 0
.text
# --------------------------------

# --------------------------------
print_space:
	li a0, ' '
	li v0, 11
	syscall
jr ra
# --------------------------------

# --------------------------------
print_line:
	li a0, '\n'
	li v0, 11
	syscall
jr ra
# --------------------------------

# --------------------------------
print_string:
	li v0, 4
	syscall     
jr	ra
# --------------------------------

# --------------------------------
print_array:
	li t4, 0
	ask_loop_top2: ble t4, 51, ask_loop_body2 
	j ask_loop_exit2
	ask_loop_body2: # {
		la t0, deck
		li t1, 1
		mul t1, t4, t1
		add t0, t0, t1
		lbu t3, 0(t0)
		move a0, t3
		li v0, 1
		syscall
		add t4, t4, 1
		li a0, ' '
		li v0, 11
		syscall
		j ask_loop_top2
	ask_loop_exit2: # }
	li	a0, '\n'
	li	v0, 11
	syscall
jr ra
# --------------------------------

# --------------------------------
print_player:
push ra
	li s0, 0
	sb s0, player_total
	lbu t1, player_total
	lbu t4, player_index
	ask_loop_top4: blt s0, t4, ask_loop_body4 
	j ask_loop_exit4
	ask_loop_body4: # {
		la t0, player
		add t0, t0, s0
		lbu t3, 0(t0)
		move a0, t3
		li v0, 1
		syscall
		jal print_space
		add t1, t1, t3
		add s0, s0, 1
		j ask_loop_top4
	ask_loop_exit4: # }
	sb t1, player_total
pop ra
jr ra
# --------------------------------

# --------------------------------
print_dealer:
push ra
	li s0, 0
	sb s0, dealer_total
	lbu t1, dealer_total
	lbu t4, dealer_index
	ask_loop_top5: blt s0, t4, ask_loop_body5 
	j ask_loop_exit5
	ask_loop_body5: # {
		la t0, dealer
		add t0, t0, s0
		lbu t3, 0(t0)
		move a0, t3
		li v0, 1
		syscall
		jal print_space
		add t1, t1, t3
		add s0, s0, 1
		j ask_loop_top5
	ask_loop_exit5: # }
		sb t1, dealer_total
pop ra
jr ra
# --------------------------------

# --------------------------------
print_player_total:
push ra
	li a0, '='
	li v0, 11
	syscall
	jal print_space
	lbu a0, player_total
	li v0, 1
	syscall
pop ra
jr ra
# --------------------------------

# --------------------------------
print_dealer_total:
push ra
	li a0, '='
	li v0, 11
	syscall
	jal print_space
	lbu a0, dealer_total
	li v0, 1
	syscall
pop ra
jr ra
# --------------------------------

# --------------------------------
show_hands:
push ra

	.data 
	player_hand: .asciiz "Player's Hand: "
	dealer_hand: .asciiz "Dealer's Hand: "
	.text
	la a0, player_hand
	jal print_string
	jal print_player
	jal print_player_total

	jal print_line

	la a0, dealer_hand
	jal print_string
	jal print_dealer
	jal print_dealer_total

	jal print_line
pop ra	
jr ra
# --------------------------------

# --------------------------------
deal_card_to_player:
	lbu t3, deck_index
	lbu t4, player_index
	la t0, deck
	add t0, t0, t3
	lbu t2, (t0)
	la t1, player
	add t1, t1, t4 
	sb t2, (t1)
	add t3, t3, 1
	add t4, t4, 1
	sb t3, deck_index
	sb t4, player_index
jr ra 
# --------------------------------

# --------------------------------
deal_card_to_dealer:
	lbu t3, deck_index
	lbu t4, dealer_index
	la t0, deck
	add t0, t0, t3
	lbu t2, (t0)
	la t1, dealer
	add t1, t1, t4 
	sb t2, (t1)
	add t3, t3, 1
	add t4, t4, 1
	sb t3, deck_index
	sb t4, dealer_index
jr ra 
# --------------------------------

# --------------------------------
swap: 
	la t0, deck
	add t0, t0, s0
	lbu t1, (t0)
	la t3, deck
	add t3, t3, a0 
	lbu t2, (t3)
	sb t1, (t3)
	sb t2, (t0)
jr ra
# --------------------------------

# --------------------------------
shuffle_deck:
	push ra
	li s0, 51
	ask_loop_top: bge s0, 1, ask_loop_body 
	j ask_loop_exit
	ask_loop_body: # {
		li a0, 0
		add t0, s0, 1
		move a1, t0
		li v0, 42 
		syscall
		jal swap
		sub s0, s0, 1
		j ask_loop_top
	ask_loop_exit: # }
	pop	ra
jr	ra
# --------------------------------

# --------------------------------
player_wins: 
	.data
	win: .asciiz "You Won!"
	.text
	la a0, win
	jal print_string
	li v0, 10
	syscall
jr ra 
# --------------------------------

# --------------------------------
dealer_wins:
	.data
	lose: .asciiz "You Lost!"
	.text
	la a0, lose
	jal print_string
	li v0, 10
	syscall
jr ra 
# --------------------------------

# --------------------------------
ties:
	.data 
	tie: .asciiz "You Tied!"
	.text
	la a0, tie
	jal print_string
	li v0, 10
	syscall
jr ra
# --------------------------------

# --------------------------------
check_scores:
push ra
	lbu t0, player_total
	lbu t1, dealer_total
	check_player_win: beq t0, 21, check_dealer_lose
	j check_dealer_win 
	check_dealer_lose: bne t1, 21, player_win 
	j tie_game
	check_dealer_win: beq t1, 21, check_player_lose
	j check_player_bust
	check_player_lose: bne t0, 21, dealer_win
	check_player_bust: bgt t0, 21, dealer_win
	check_dealer_bust: bgt t1, 21, player_win
	j exit_check
	player_win:
		jal player_wins
	dealer_win:
		jal dealer_wins 
	tie_game:
		jal ties 

	exit_check: 
pop ra
jr ra
# --------------------------------

# --------------------------------
take_turns:
push ra
	.data
	hit_or_stand: .asciiz "What would you like to do? (0 = stand, 1 = hit): "
	.text
	lbu s1, player_total
	lbu s2, dealer_total
	la a0, hit_or_stand
	jal print_string
	li v0, 5
	syscall

	player_hits: bne v0, 1, dealer_hits
		jal deal_card_to_player 
	dealer_hits: bge s2, 17, compare_scores
		jal deal_card_to_dealer
		j exit_take_turns
	compare_scores: beq v0, 1, exit_take_turns
		bgt s1, s2, player_wins
		bgt s2, s1, dealer_wins
		beq s1, s2, ties 
	exit_take_turns: 

pop ra
jr ra
# --------------------------------

# --------------------------------
.globl main
main:
	jal	shuffle_deck
	jal	deal_card_to_player
	jal	deal_card_to_dealer
	jal	deal_card_to_player
	jal	deal_card_to_dealer
	
_main_loop:
	jal	show_hands
	jal	check_scores
	jal	take_turns
	j	_main_loop
# --------------------------------