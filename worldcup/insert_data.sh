#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
	if [[ $YEAR != year ]]
	then
		# get winner team_id
		WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		
		# if not found
		if [[ -z $WINNER_ID ]]
		then
			# insert winner team
			INSERT_WINNER_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
			if [[ $INSERT_WINNER_TEAM_RESULT == "INSERT 0 1" ]]
			then
				echo "Inserted into teams, $WINNER"
			fi
			# get new winner_id
			WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		fi

		# get opponent team team_id
		OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

		# if not found
		if [[ -z $OPPONENT_ID ]]
		then
			# insert opponent team
			INSERT_OPPONENT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
			if [[ $INSERT_OPPONENT_TEAM_RESULT == "INSERT 0 1" ]]
			then
				echo "Inserted into teams, $OPPONENT"
			fi
			# get new opponent_id
			OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		fi

		# insert game
		INSERT_GAME_RES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) \
			VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
		if [[ $INSERT_GAME_RES == "INSERT 0 1" ]]
		then
			echo "Inserted into games, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS"
		fi
	fi
done
