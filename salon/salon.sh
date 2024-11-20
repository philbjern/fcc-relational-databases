#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
	if [[ $1 ]]
	then
		echo -e "\n$1"
	else
		echo -e "Welcome to My Salon, how can I help you?\n"
	fi

	SERVICES_RESULT=$($PSQL "SELECT service_id, name FROM services")
	echo "$SERVICES_RESULT" | while read SERVICE_ID BAR SERVICE_NAME
	do
		echo "$SERVICE_ID) $SERVICE_NAME"
	done
	read SERVICE_ID_SELECTED
	case $SERVICE_ID_SELECTED in
		1) SERVICE_MENU "cut" ;;
		2) SERVICE MENU "color" ;;
		3) SERVICE_MENU "perm" ;;
		4) SERVICE_MENU "style" ;;
		5) SERVICE_MENU "trim" ;;
		*) MAIN_MENU "I could not find that service. What would you like today?" ;;
	esac
}

SERVICE_MENU() {
	if [[ -z $1 ]]
	then
		MAIN_MENU "I could not find that service. What would you like today?"
	else
		SERVICE_NAME=$1
		echo -e "\nWhat's your phone number?"
		read CUSTOMER_PHONE
		CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
		if [[ -z $CUSTOMER_ID ]]
		then
			echo -e "\nI don't have a record for that phone number, what's your name?"
			read CUSTOMER_NAME
			if [[ -z $CUSTOMER_NAME ]]
			then
				MAIN_MENU "You need to input valid name"
			else
				CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
				CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
			fi
		fi
		
		CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id='$CUSTOMER_ID'")
		CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -r 's/^ *//')
		SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE name='$SERVICE_NAME'")
		echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME_FORMATTED?"
		read SERVICE_TIME
		APPOINTENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID', '$SERVICE_TIME')")
		echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED.\n"
	
	fi

}


MAIN_MENU
