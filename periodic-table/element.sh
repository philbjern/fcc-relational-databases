#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
	echo "Please provide an element as an argument."
fi

if [[ ! $1 =~ ^[0-9]+$ ]]
then
	# argument is not a number
	ATOMIC_NUMBER_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name LIKE '$1%' LIMIT 1")
	if [[ -z $ATOMIC_NUMBER_RESULT ]]
	then
		echo "I could not find that element in the database"
	fi
	echo $ATOMIC_NUMBER_RESULT
else
	# argument is a number
	ATOMIC_NUMBER_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number='$1'")
	if [[ -z $ATOMIC_NUMBER_RESULT ]]
	then
		echo "I could not find that element in the database"
	fi
	echo $ATOMIC_NUMBER_RESULT
fi
