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
    BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE username='$USERNAME'")
    echo "Welcome back, $(echo "$USERNAME" | sed -r 's/^ *| *$//')! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    else
    echo -e "Welcome, $(echo "$USERNAME" | sed -r 's/^ *| *$//')! It looks like this is your first time here."
    ADD__TO_USERS_DATABASE=$($PSQL "INSERT INTO users(username, games_played) VALUES('$USERNAME', 0)")
  fi

  #Print: Guess the secret number between 1 and 1000:
  echo "Guess the secret number between 1 and 1000:"
  USER_GUESS
}



USER_GUESS() {
  
  read GUESS
  echo $RANDOM_NUMBER
  if ! [[ $GUESS =~ ^[0-9]+$ ]]
    then
    ((NUMBER_OF_GUESSES++))
    echo "That is not an integer, guess again:"
    USER_GUESS
  fi
  if [[ $GUESS -gt $RANDOM_NUMBER ]]
    then
     ((NUMBER_OF_GUESSES++))
    echo "It's lower than that, guess again:"
    USER_GUESS
    return
    elif [[ $GUESS -lt $RANDOM_NUMBER ]]
      then
       ((NUMBER_OF_GUESSES++))
      echo "It's higher than that, guess again:"
      USER_GUESS
      return
    else
      ((GAMES_PLAYED++))
      ((NUMBER_OF_GUESSES++))
      UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE username = '$USERNAME'")
      UPDATE_NUMBER_OF_GUESSES=$($PSQL "INSERT INTO games(username, number_of_guesses) VALUES('$USERNAME', $NUMBER_OF_GUESSES)")
      echo -e "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"
  fi
  exit 0
}

START