Assembly Language Mastermind Game
Overview
This project is an implementation of a Mastermind-style game using MIPS assembly language. The game challenges the player to guess a secret code within a limited number of turns. The player receives feedback on the number of correct guesses both in the correct position and in incorrect positions.

Features
Random Code Generation: The game generates a random code using a custom random number generator.
User Interaction: Prompts the user for guesses and provides feedback on the correctness of their guesses.
Feedback Mechanism: Provides feedback on the number of correct guesses in the correct and incorrect positions.
Game Loop: Manages the game state, handling turns and determining win/loss conditions.
Functions
main: The entry point of the game. Initializes the game, prompts the user for a random seed, and starts the game loop.
play_game: Manages the game loop, iterating through turns and checking win/loss conditions.
generate_solution: Generates the random secret code that the player must guess.
play_turn: Handles a single turn of the game, including reading the player's guess and providing feedback.
read_guess: Reads the player's guess from the input.
copy_solution_into_temp: Copies the generated solution into a temporary array for comparison during the game.
calculate_correct_place: Calculates the number of guesses that are correct and in the correct position.
calculate_incorrect_place: Calculates the number of guesses that are correct but in the incorrect position.
seed_rand: Seeds the custom random number generator (provided).
rand: Generates a random number using a linear congruential generator (provided).
How to Run
To run this game, you need a MIPS simulator such as SPIM or MARS. Load the assembly code into the simulator, assemble it, and run the program. Follow the prompts to enter a random seed and start making guesses to deduce the secret code.
