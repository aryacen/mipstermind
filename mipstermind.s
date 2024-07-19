########################################################################
# COMP1521 22T1 -- Assignment 1 -- Mipstermind!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/22T1/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by ARYA BODHI GUNAWAN (z5240037)
# on 20-03-2022
#
# Version 1.0 (28-02-22): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
########################################################################

#![tabsize(8)]

# Constant definitions.
# DO NOT CHANGE THESE DEFINITIONS

TURN_NORMAL = 0
TURN_WIN    = 1
NULL_GUESS  = -1


########################################################################
# .DATA
# YOU DO NOT NEED TO CHANGE THE DATA SECTION
.data

# int correct_solution[GUESS_LEN];
.align 2
correct_solution:	.space GUESS_LEN * 4

# int current_guess[GUESS_LEN];
.align 2
current_guess:		.space GUESS_LEN * 4

# int solution_temp[GUESS_LEN];
.align 2
solution_temp:		.space GUESS_LEN * 4


guess_length_str:	.asciiz "Guess length:\t"
valid_guesses_str:	.asciiz "Valid guesses:\t1-"
number_turns_str:	.asciiz "How many turns:\t"
enter_seed_str:		.asciiz "Enter a random seed: "
you_lost_str:		.asciiz "You lost! The secret codeword was: "
turn_str_1:		.asciiz "---[ Turn "
turn_str_2:		.asciiz " ]---\n"
enter_guess_str:	.asciiz "Enter your guess: "
you_win_str:		.asciiz "You win, congratulations!\n"
correct_place_str:	.asciiz "Correct guesses in correct place:   "
incorrect_place_str:	.asciiz "Correct guesses in incorrect place: "

############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################


########################################################################
#
# Implement the following 8 functions,
# and check these boxes as you finish implementing each function
#
#  - [X] main
#  - [X] play_game
#  - [X] generate_solution
#  - [X] play_turn
#  - [X] read_guess
#  - [X] copy_solution_into_temp
#  - [X] calculate_correct_place
#  - [X] calculate_incorrect_place
#  - [X] seed_rand  (provided for you)
#  - [X] rand       (provided for you)
#
########################################################################


########################################################################
# .TEXT <main>
.text
main:
	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$ra, ...]
	# Uses:     [$v0, $a0, ...]
	# Clobbers: [$v0, $a0, ...]
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   main
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

main__prologue:
	begin                   # begin a new stack frame
	push	$ra             # | $ra

main__body:
	# printf("Guess length: %d\n", GUESS_LEN);
	li	$v0, 4          # syscall 4: print_string
	la	$a0, guess_length_str
	syscall                 # printf("Guess length: ");

	li	$v0, 1          # syscall 1: print_int
	li	$a0, GUESS_LEN
	syscall                 # printf("%d", GUESS_LEN);

	li	$v0, 11         # syscall 11: print_char
	li	$a0, '\n'
	syscall                 # printf("\n");


	# printf("Valid guesses: 1-%d\n", GUESS_CHOICES);
	li	$v0, 4          # syscall 4: print_string
	la	$a0, valid_guesses_str
	syscall                 # printf("Valid guesses: 1-");

	li	$v0, 1          # syscall 1: print_int
	li	$a0, GUESS_CHOICES
	syscall                 # printf("%d", GUESS_CHOICES);

	li	$v0, 11         # syscall 11: print_char
	li	$a0, '\n'
	syscall                 # printf("\n");


	# printf("How many turns: %d\n\n", MAX_TURNS);
	li	$v0, 4          # syscall 4: print_string
	la	$a0, number_turns_str
	syscall                 # printf("How many turns: ");

	li	$v0, 1          # syscall 1: print_int
	li	$a0, MAX_TURNS
	syscall                 # printf("%d", MAX_TURNS);

	li	$v0, 11         # syscall 11: print_char
	li	$a0, '\n'
	syscall                 # printf("\n");
	syscall                 # printf("\n");

	# printf("Enter a random seed: );
	li	$v0, 4
	la	$a0, enter_seed_str
	syscall

	# scanf("%d", &random_seed);
	li	$v0, 5
	syscall
	move	$a0, $v0
	# seed_rand(random_seed);
	jal 	seed_rand

	# play_game();
	jal	play_game

main__epilogue:
	pop	$ra             # | $ra
	end                     # ends the current stack frame

	li	$v0, 0
	jr	$ra             # return 0;




########################################################################
# .TEXT <play_game>
.text
play_game:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   play_game
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

play_game__prologue:
	begin
	push 	$s0
	push 	$ra

play_game__body:
	jal 	generate_solution	# generate_solution();
	li 	$s0, 0 			# int turn = 0;

play_game_loop:
	# if turn >= MAX_TURNS, goto play_game_endloop
	bge 	$s0, MAX_TURNS, play_game_endloop

	# int turn_status = play_turn(turn);
	move 	$a0, $s0
	jal 	play_turn
	move 	$t0, $v0

	# if (turn_status == TURN_WIN), goto epilogue
	beq 	$t0, TURN_WIN, play_game__epilogue

	# turn++;
	addi 	$s0, $s0, 1

	j 	play_game_loop

play_game_endloop:
	# printf("You lost! The secret codeword was: ");
	li 	$v0, 4
	la 	$a0, you_lost_str
	syscall

	# int i = 0;
	li 	$t1, 0

	j 	play_game_loop0

play_game_loop0:
	# if (i >= GUESS_LEN), goto play_game_endloop0
	bge 	$t1, GUESS_LEN, play_game_endloop0

	# calculate &correct_solution[i]
	mul 	$t2, $t1, 4
	la 	$t3, correct_solution
	add 	$t4, $t3, $t2

	# printf("%d", correct_solution[i]);
	li 	$v0, 1
	lw 	$a0, ($t4)
	syscall

	# printf(" ");
	li 	$v0, 11  # syscall number for printing character
	li 	$a0, 32
	syscall

	# i++;
	addi 	$t1, $t1, 1

	j 	play_game_loop0

play_game_endloop0:
	# printf("\n");
	li 	$v0, 11
	la 	$a0, '\n'
	syscall

	j 	play_game__epilogue

play_game__epilogue:
	pop 	$ra
	pop 	$s0
	end
	jr	$ra             # return;




########################################################################
# .TEXT <generate_solution>
.text
generate_solution:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   generate_solution
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

generate_solution__prologue:
	begin
	push 	$s0
	push 	$s1
	push 	$s2
	push 	$ra
generate_solution__body:
	li 	$s0, 0 		# int i = 0;
	li 	$t1, GUESS_CHOICES 	# int guess_choice = GUESS_CHOICES

generate_solution_loop:
	# if (i >= GUESS_LEN), goto generate_solution__epilogue
	bge 	$s0, GUESS_LEN, generate_solution__epilogue

	# int rand = rand(GUESS_CHOICES) + 1;
	move 	$a0, $t1
	jal 	rand
	move 	$s1, $v0
	addi 	$s1, $s1, 1

	# calculate &correct_solution[i]
	mul 	$t2, $s0, 4
	la 	$t3, correct_solution
	add 	$s2, $t3, $t2

	# correct_solution[i] = rand(GUESS_CHOICES) + 1;
	sw 	$s1, ($s2)

	# i++;
	addi 	$s0, $s0, 1

	j 	generate_solution_loop

generate_solution__epilogue:
	pop 	$ra
	pop 	$s0
	pop 	$s1
	pop 	$s2
	end
	jr	$ra             # return;




########################################################################
# .TEXT <play_turn>
.text
play_turn:
	# Args:
	#   - $a0: int
	# Returns:
	#   - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   play_turn
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

play_turn__prologue:
	begin
	push 	$ra
	move 	$t0, $a0 	# move turn variable to $t0

play_turn__body:

	# printf("---[Turn ");
	li 	$v0, 4
	la 	$a0, turn_str_1
	syscall

	# printf("%d", turn + 1);
	addi 	$t0, $t0, 1
	li 	$v0, 1
	move 	$a0, $t0
	syscall

	# printf(" ]--\n");
	li 	$v0, 4
	la 	$a0, turn_str_2
	syscall

	# printf("Enter your guess: ")
	li 	$v0, 4
	la 	$a0, enter_guess_str
	syscall

	# read_guess();
	jal 	read_guess
	# copy_solution_into_temp();
	jal 	copy_solution_into_temp

	# int correct_place = calculate_correct_place();
	jal 	calculate_correct_place
	move 	$t1, $v0

	# int incorrect_place = calculate_incorrect_place();
	jal 	calculate_incorrect_place
	move 	$t2, $v0

	# if (correct_place == GUESS_LEN), goto return_win
	beq 	$t1, GUESS_LEN, return_win

	# printf("Correct guesses in correct place:   ");
	li 	$v0, 4	
	la 	$a0, correct_place_str
	syscall

	# printf("%d", correct_place);
	li 	$v0, 1
	move 	$a0, $t1
	syscall

	# printf("\n");
	li	$v0, 11         # syscall 11: print_char
	li	$a0, '\n'
	syscall                 # printf("\n");

	# printf("Correct guesses in incorrect place: ");
	li 	$v0, 4
	la 	$a0, incorrect_place_str
	syscall

	# printf("%d", incorrect_place);
	li 	$v0, 1
	move 	$a0, $t2
	syscall

	# printf("\n");
	li		$v0, 11         # syscall 11: print_char
	li		$a0, '\n'
	syscall                 # printf("\n");

	# return TURN_NORMAL;
	li 	$v0, TURN_NORMAL
	j 	play_turn__epilogue

return_win:
	# printf("You win, congratulations!\n");
	li 	$v0, 4
	la 	$a0, you_win_str
	syscall

	# return TURN_WIN;
	li  	$v0, TURN_WIN
	j 	play_turn__epilogue	

play_turn__epilogue:
	pop	$ra
	end
	jr	$ra             # return;




########################################################################
# .TEXT <read_guess>
.text
read_guess:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   read_guess
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

read_guess__prologue:
read_guess__body:
	li 	$t0, 0 		# int n_guess = 0;

read_guess_loop:
	bge 	$t0, GUESS_LEN, read_guess__epilogue
	li 	$t1, 0 		# int guess = 0;

	# scanf("%d", &guess);
	li 	$v0, 5
	syscall
	move 	$t1, $v0

	# calculate &current_guess[n_guess]
	mul 	$t2, $t0, 4
	la 	$t3, current_guess
	add 	$t4, $t3, $t2

	# current_guess[n_guess] = guess;
	sw 	$t1, ($t4)

	# n_guess++;
	addi 	$t0, $t0, 1

	j 	read_guess_loop

read_guess__epilogue:
	jr	$ra             # return;




########################################################################
# .TEXT <copy_solution_into_temp>
.text
copy_solution_into_temp:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   copy_solution_into_temp
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

copy_solution_into_temp__prologue:
copy_solution_into_temp__body:
	li 	$t0, 0			# int i = 0;

copy_solution_into_temp_loop:
	# if (i >= GUESS_LEN), goto copy_solution_into_temp__epilogue
	bge 	$t0, GUESS_LEN, copy_solution_into_temp__epilogue

	# calculate &correct_solution[i] and &solution_temp[i]
	mul 	$t1, $t0, 4	
	la 	$t2, correct_solution
	la 	$t3, solution_temp
	add 	$t4, $t1, $t2		
	add 	$t5, $t1, $t3		# solution_temp[i] is in $t5
	lw 	$t6, ($t4) 		# correct_solution[i] is in $t6
	sw 	$t6, ($t5) 		# store correct_solution[i] in solution_temp[i]

	addi 	$t0, $t0, 1 		# i++;

	j 	copy_solution_into_temp_loop

copy_solution_into_temp__epilogue:
	jr	$ra             # return;




########################################################################
# .TEXT <calculate_correct_place>
.text
calculate_correct_place:
	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   calculate_correct_place
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

calculate_correct_place__prologue:
	begin
	push 	$s1
	push 	$s2

calculate_correct_place__body:
	li 	$t0, 0 		# int total = 0;
	li 	$t1, 0 		# int guess_index = 0 ;

calculate_correct_place_loop:
	# if (guess_index >= GUESS_LEN), goto calculate_correct_place__epilogue
	bge 	$t1, GUESS_LEN, calculate_correct_place__epilogue
	mul 	$t2, $t1, 4
	la 	$s1, current_guess
	add 	$s1, $s1, $t2 	# calculate &current_guess[guess_index]

	lw 	$t3, ($s1) 	# int guess = current_guess[guess_index];

	la 	$s2, solution_temp
	add 	$s2, $s2, $t2
	lw 	$t4, ($s2) 	# int solution = solution_temp[guess_index];

	# if (solution == guess), goto calculate_correct_place_if
	beq 	$t3, $t4, calculate_correct_place_if

	# guess_index++;
	addi 	$t1, $t1, 1

	j 	calculate_correct_place_loop

calculate_correct_place_if:
	addi 	$t0, $t0, 1 	# total++;

	li 	$t5, NULL_GUESS # int NULL_GUESS = -1;
	sw 	$t5, ($s1)	# current_guess[guess_index] = NULL_GUESS;
	sw 	$t5, ($s2)	# solution_temp[guess_index] = NULL_GUESS;

	# guess_index++;
	addi 	$t1, $t1, 1
	j 	calculate_correct_place_loop

calculate_correct_place__epilogue:
	pop 	$s1
	pop 	$s2
	end
	move 	$v0, $t0
	jr	$ra             # return total;


########################################################################
# .TEXT <calculate_incorrect_place>
.text
calculate_incorrect_place:
	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   calculate_incorrect_place
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

calculate_incorrect_place__prologue:
	begin
	push 	$s3
	push 	$s4
	push 	$s5

calculate_incorrect_place__body:
	li 	$t0, 0 		# int total = 0;
	li 	$s3, 0 		# int guess_index = 0;


calculate_incorrect_place_loop:
	# if (guess_index >= GUESS_LEN), goto calculate_incorrect_place__epilogue
	bge 	$s3, GUESS_LEN, calculate_incorrect_place__epilogue

	# calculate &current_guess[guess_index];
	mul 	$t3, $s3, 4
	la 	$t4, current_guess
	add 	$t4, $t4, $t3
	lw 	$s4, ($t4) 	# int guess = current_guess[guess_index];

	# if (guess != -1), goto calculate_incorrect_place_if
	bne 	$s4, -1, calculate_incorrect_place_if

	# guess_index++;
	addi 	$s3, $s3, 1

	j 	calculate_incorrect_place_loop

calculate_incorrect_place_if:
	li 	$t2, 0 		# int solution_index = 0;
	j 	calculate_incorrect_place_loop0

calculate_incorrect_place_loop0:
	# if solution_index >= GUESS_LEN, goto increment_guess_index
	bge 	$t2, GUESS_LEN, increment_guess_index
	
	# calculate &solution_temp[solution_index]
	mul 	$t5, $t2, 4
	la 	$s5, solution_temp
	add 	$s5, $s5, $t5

	lw 	$t6, ($s5) 	# int solution = solution_temp[solution_index];

	# if (solution_temp[solution_index] == guess), goto increment_total
	beq 	$s4, $t6, increment_total

	# solution_index++;
	addi 	$t2, $t2, 1

	j 	calculate_incorrect_place_loop0

increment_total:
	addi 	$t0, $t0, 1 	# total++;

	li 	$t7, NULL_GUESS # int NULL_GUESS = -1
	sw 	$t7, ($s5) 	# solution_temp[solution_index] = NULL_GUESS;

	# break from inner loop
	j 	increment_guess_index

increment_guess_index:
	# guess_index++;
	addi 	$s3, $s3, 1
	j 	calculate_incorrect_place_loop

calculate_incorrect_place__epilogue:
	pop 	$s3
	pop 	$s4
	pop 	$s5
	end
	move 	$v0, $t0
	jr	$ra             # return total;




########################################################################
####                                                                ####
####        STOP HERE ... YOU HAVE COMPLETED THE ASSIGNMENT!        ####
####                                                                ####
########################################################################

##
## The following are two utility functions, provided for you.
##
## You don't need to modify any of the following.
## But you may find it useful to read through.
## You'll be calling these functions from your code.
##


########################################################################
# .DATA
# DO NOT CHANGE THIS DATA SECTION
.data

# int random_seed;
.align 2
random_seed:		.space 4


########################################################################
# .TEXT <seed_rand>
# DO NOT CHANGE THIS FUNCTION
.text
seed_rand:
	# Args:
	#   - $a0: unsigned int seed
	# Returns: void
	#
	# Frame:    []
	# Uses:     [$a0, $t0]
	# Clobbers: [$t0]
	#
	# Locals:
	# - $t0: offline_seed
	#
	# Structure:
	#   seed_rand

	li	$t0, OFFLINE_SEED # const unsigned int offline_seed = OFFLINE_SEED;
	xor	$t0, $a0          # random_seed = seed ^ offline_seed;
	sw	$t0, random_seed

	jr	$ra               # return;




########################################################################
# .TEXT <rand>
# DO NOT CHANGE THIS FUNCTION
.text
rand:
	# Args:
	#   - $a0: unsigned int n
	# Returns:
	#   - $v0: int
	#
	# Frame:    []
	# Uses:     [$a0, $v0, $t0]
	# Clobbers: [$v0, $t0]
	#
	# Locals:
	# - $t0: random_seed
	#
	# Structure:
	#   rand

	lw	$t0, random_seed  # unsigned int rand = random_seed;
	multu	$t0, 0x5bd1e995   # rand *= 0x5bd1e995;
	mflo	$t0
	addiu	$t0, 12345        # rand += 12345;
	sw	$t0, random_seed  # random_seed = rand;

	remu	$v0, $t0, $a0     # rand % n
	jr	$ra               # return;
