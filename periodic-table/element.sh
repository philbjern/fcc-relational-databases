#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
	echo "Please provide an element as an argument."
else

	if [[ ! $1 =~ ^[0-9]+$ ]]
	then
		# argument is not a number
		ATOMIC_NUMBER_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name LIKE '$1%' LIMIT 1")
		if [[ -z $ATOMIC_NUMBER_RESULT ]]
		then
			echo "I could not find that element in the database."
		else	
			echo "$ATOMIC_NUMBER_RESULT" | while IFS=\| read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
			do 
				echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
			done
		fi
	else
		# argument is a number
		ATOMIC_NUMBER_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number='$1'")
		if [[ -z $ATOMIC_NUMBER_RESULT ]]
		then
			echo "I could not find that element in the database."
		else	
			echo "$ATOMIC_NUMBER_RESULT" | while IFS=\| read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
			do 
				echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
			done
		fi
	fi

fi
