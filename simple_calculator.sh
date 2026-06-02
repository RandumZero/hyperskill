#!/usr/bin/env bash
log="./operation_history.txt"
if [[ -f "$log" ]]; then rm "$log"; fi
touch "$log"

printf "%s\n" "Welcome to the basic calculator!" | tee -a "$log"

while true; do
    operand_1_valid=0
    operand_2_valid=0
    operator_valid=0
    total_values_valid=0
    
    printf "%s\n" "Enter an arithmetic operation or type 'quit' to quit:" | tee -a "$log"
    read -a user_input
    
    if [[ $user_input == "quit" ]]; then printf "%s\n" "quit" >> $log; printf "Goodbye!" | tee -a "$log"; break; fi
    
    total_values=${#user_input[@]}
    operand_1=${user_input[0]}
    operator=${user_input[1]}
    operand_2=${user_input[2]}
    

    echo "${user_input[@]}" >> "$log"
    
    is_integer="^-?[0-9]+$"
    is_float="^-?[0-9]+\.[0-9]+$"
    
    if [[ $operand_1 =~ $is_integer || $operand_1 =~ $is_float ]]; then operand_1_valid=1; fi
    if [[ $operator == "+" || $operator == "-" || $operator == "/" || $operator == "*" || $operator == "^" ]]; then operator_valid=1; fi
    if [[ $operand_2 =~ $is_integer || $operand_2 =~ $is_float ]]; then operand_2_valid=1; fi
    if [[ $total_values == 3 ]]; then total_values_valid=1; fi
    
    if [[ $operand_1_valid == 1 && $operator_valid == 1 && $operand_2_valid == 1 && $total_values_valid == 1 ]]; then    
        arithmetic_result=$( echo "scale=2; $operand_1 $operator $operand_2" | bc -l )
        echo "$arithmetic_result" | tee -a "$log"
    else
        echo "Operation check failed!" | tee -a "$log"
    fi
done

exit
    
