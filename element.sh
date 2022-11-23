#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

ARGUMENT=$1

CHECK_ARG(){
  if [[ -n $ARGUMENT ]]
    then
      CHECK_OPTION
    else
      echo -e "Please provide an element as an argument."
  fi
}

CHECK_OPTION(){
  RE='^[0-9]+$'
  if [[ $ARGUMENT =~ $RE ]];
    then
      GET_DETAILS_NUMBER
    else
      GET_DETAILS_STRING
  fi
}

GET_DETAILS_NUMBER(){
  ATOMIC_NUMBER_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ARGUMENT;")
  if [[ -n $ATOMIC_NUMBER_RESULT ]]
    then
      ELEMENTS_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$ARGUMENT;")
      PROPERTIES_RESULT=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ARGUMENT;")
      SHOW_DETAIL
    else
      echo "I could not find that element in the database."
  fi
}

GET_DETAILS_STRING(){
  SYMBOL_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ARGUMENT';")
  NAME_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ARGUMENT';")
  if [[ -n $SYMBOL_RESULT ]]
    then
      ELEMENTS_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$SYMBOL_RESULT;")
      PROPERTIES_RESULT=$($PSQL "SELECT * FROM properties WHERE atomic_number=$SYMBOL_RESULT;")
      SHOW_DETAIL
    elif [[ -n $NAME_RESULT ]]
      then 
        ELEMENTS_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$NAME_RESULT;")
        PROPERTIES_RESULT=$($PSQL "SELECT * FROM properties WHERE atomic_number=$NAME_RESULT;")
        SHOW_DETAIL  
    else
      echo "I could not find that element in the database."
  fi
}

SHOW_DETAIL(){
  echo "$ELEMENTS_RESULT | $PROPERTIES_RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_NUMBER BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE_ID
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
}

CHECK_ARG
