#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME
GAMES_COUNT=0
BEST_SCORE=0

USER_RESULT=$($PSQL "SELECT * FROM users WHERE username='$USERNAME' LIMIT 1")
if [[ -z $USER_RESULT ]]
then
	echo "Welcome, $USERNAME! It looks like this is your first time here."
	INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 0, 0)")
	USER_RESULT=$($PSQL "SELECT * FROM users WHERE username='$USERNAME' LIMIT 1")
fi
echo "$USER_RESULT" | while IFS=\| read USER_ID USERNAME_FROM_DB GAMES_PLAYED BEST_GAME
do
	echo "Welcome back, $USERNAME_FROM_DB! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
	GAMES_COUNT=$GAMES_PLAYED
	BEST_SCORE=$BEST_GAME

done

NUMBER=$(( RANDOM % 1000 ))
echo $NUMBER

echo "Guess the secret number between 1 and 1000:"
read GUESS
NUMBER_OF_GUESSES=1
while [[ $GUESS != $NUMBER ]]
do
	((NUMBER_OF_GUESSES++))
	if [[ ! $GUESS =~ ^[0-9]+$ ]]
	then
		echo "That is not an integer, guess again:"
		read GUESS
		continue
	fi

	if [[ $GUESS > $NUMBER ]]
	then
		echo "It's lower than that, guess again:"
		read GUESS
		continue
	fi
	
	if [[ $GUESS < $NUMBER ]]
	then
		echo "It's higher than that, guess again:"
		read GUESS
		continue
	fi

done

echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!"

NEW_GAMES_PLAYED=$((GAMES_COUNT++))

if [[ $NUMBER_OF_GUESSES < $BEST_SCORE ]]
then
	NEW_BEST_GAME=$NUMBER_OF_GUESSES
else
	NEW_BEST_GAME=$BEST_SCORE
fi

echo "$NEW_GAMES_PLAYED $NEW_BEST_GAME"

UPDATE_RESULT=$($PSQL "UPDATE users SET games_played='$NEW_GAMES_PLAYED', best_game='$NEW_BEST_GAME' WHERE username='$USERNAME'")
echo "$UPDATE_RESULT"

