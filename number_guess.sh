#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$(( (RANDOM % 1000) + 1))
#variables needed: number_of_guesses (input into database when game is over)
NUMBER_OF_GUESSES=null

# prompt for username: "Enter username:"
echo "Enter username:"
read USERNAME

#search database for username
SEARCH_USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")
#if user doesn't exist:
if [[ -z $SEARCH_USERNAME ]]
  then
  echo "Welcome, $( echo $USERNAME | sed -e 's/^ +| $+//g') It looks like this is your first time here."
  ADD_NAME_TO_DATABASE=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
fi

# if user exists: 
# get following data: username, games_played, best_game
# Print: Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses.



#Print: Guess the secret number between 1 and 1000:
#read user input

#if guess is higher, print: It's higher than that, guess again:
#if guess is lower, print: It's lower than that, guess again:
#if guess isn't an integer, print: That is not an integer, guess again:
#keep asking for input until they guess right

#if right:
#1 - print: You guessed it in <number_of_guesses> tries. The secret number was <secret_number>. Nice job!
#2 - input number_of_guesses to database