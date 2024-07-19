# Assembly Language Mastermind Game

## Overview
This project is an implementation of a Mastermind-style game using MIPS assembly language. The game challenges the player to guess a secret code within a limited number of turns. The player receives feedback on the number of correct guesses both in the correct position and in incorrect positions. This assignment was awarded a 100% mark, reflecting its completeness and accuracy.

## Features
- **Random Code Generation**: The game generates a random code using a custom random number generator.
- **User Interaction**: Prompts the user for guesses and provides feedback on the correctness of their guesses.
- **Feedback Mechanism**: Provides feedback on the number of correct guesses in the correct and incorrect positions.
- **Game Loop**: Manages the game state, handling turns and determining win/loss conditions.

## Functions
1. **main**: The entry point of the game. Initializes the game, prompts the user for a random seed, and starts the game loop.
2. **play_game**: Manages the game loop, iterating through turns and checking win/loss conditions.
3. **generate_solution**: Generates the random secret code that the player must guess.
4. **play_turn**: Handles a single turn of the game, including reading the player's guess and providing feedback.
5. **read_guess**: Reads the player's guess from the input.
6. **copy_solution_into_temp**: Copies the generated solution into a temporary array for comparison during the game.
7. **calculate_correct_place**: Calculates the number of guesses that are correct and in the correct position.
8. **calculate_incorrect_place**: Calculates the number of guesses that are correct but in the incorrect position.
9. **seed_rand**: Seeds the custom random number generator (provided).
10. **rand**: Generates a random number using a linear congruential generator (provided).

## How to Run
To run this game, you need a MIPS simulator such as SPIM or MARS. Load the assembly code into the simulator, assemble it, and run the program.
