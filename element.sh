#!/bin/bash

# variable for using psql queries
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# echo element-info-message to the user
ECHO_INFO_MESSAGE() {
# read info into variables
    echo "$ELEMENT_INFO" | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MP_CELSIUS BP_CELSIUS TYPE
    do
      # echo message
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MP_CELSIUS celsius and a boiling point of $BP_CELSIUS celsius."
    done
}

# echo no argument message
ECHO_NO_ARG_MESSAGE() {
  echo "Please provide an element as an argument."
}

# echo no element found message
ECHO_NO_ELEMENT_FOUND() {
  echo "I could not find that element in the database."
}

# if there isn't an arg provided, message the user
if [[ -z $1 ]]
then
  ECHO_NO_ARG_MESSAGE
else
  # query the argument from elements table
  ELEMENT_INFO=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$1' OR name='$1';")
  if [[ -z $ELEMENT_INFO ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$1;")
    if [[ -z $ELEMENT_INFO ]]
    then
      ECHO_NO_ELEMENT_FOUND
    else
      ECHO_INFO_MESSAGE
    fi
  else
    ECHO_INFO_MESSAGE
  fi
fi
# wrong comment