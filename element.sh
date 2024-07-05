#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
# If input blank
if [[ -z $1 ]]
then
    echo "Please provide an element as an argument."
else
    if [[ ! $1 =~ ^[0-9]+$ ]]
    # if $1 not number
    then
            if [[ ${#1} -le 2 ]] 
            # if  $1 is symbol
            then
            ATOMNUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
            NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1'")
            SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")   
            else
            # if  $1 is name
            ATOMNUM=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
            NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
            SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$1'")
            fi 
    else
    # if $1 is number
            ATOMNUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$1'")
            NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = '$1'")
            SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = '$1'")
    fi
TYPEID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = '$ATOMNUM'")
TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPEID")
MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = '$ATOMNUM'")
MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = '$ATOMNUM'")
BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$ATOMNUM'")
    # if not find in elements table
    if [[ -z $BOIL ]]
    then
    echo  "I could not find that element in the database."
    else
    echo  "The element with atomic number $ATOMNUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    fi
fi