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
	SERVICE_ID_SELECTED=$1
	echo -e "\nWhat's your phone number?"
	read CUSTOMER_PHONE
	PHONE_RESULT=$($PSQL "SELECT customer_id, name FROM customers WHERE phone='$CUSTOMER_PHONE'")
	if [[ -z $PHONE_RESULT ]]
	then
		echo -e "\nI don't have a record for that phone number, what's your name?"
		read CUSTOMER_NAME
		CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
	fi


}


MAIN_MENU
