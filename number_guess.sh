#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$(( (RANDOM % 1000) + 1))
#variables needed: number_of_guesses (input into database when game is over)
NUMBER_OF_GUESSES=0

START() {
  # prompt for username: "Enter username:"
  echo "Enter your username:"
  read USERNAME

  #search database for username
  SEARCH_USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")
  #if user doesn't exist:
  if [[ $SEARCH_USERNAME ]]
    then
    # if user exists: 
    # get following data: games_played, best_game
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
    BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
    echo "Welcome back, $SEARCH_USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    # Print: Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses.
    else
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    ADD_NAME_TO_DATABASE=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 0, 999)")
  fi

  #Print: Guess the secret number between 1 and 1000:
  echo "Guess the secret number between 1 and 1000:"
  USER_GUESS

}



USER_GUESS() {
  
  #read user input
  read GUESS
  echo $RANDOM_NUMBER

  if [[ ! $GUESS =~ ^[1-9][1-9]* ]]
    then
    echo "That is not an integer, guess again:"
    USER_GUESS
  fi
  if [[ $GUESS -gt $RANDOM_NUMBER ]]
    then
     ((NUMBER_OF_GUESSES++))
    echo "It's lower than that, guess again:"
    USER_GUESS
    elif [[ $GUESS -lt $RANDOM_NUMBER ]]
      then
       ((NUMBER_OF_GUESSES++))
      echo "It's higher than that, guess again:"
      USER_GUESS
    else
      ((GAMES_PLAYED++))
      UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE username = '$USERNAME'")
      echo "games played: $GAMES_PLAYED"

      if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
        then
        UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES WHERE username = '$USERNAME'")
      fi
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"
  fi
  
}

START