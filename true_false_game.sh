#!/usr/bin/env bash

echo -e "Welcome to the True or False Game!\n"

while true; do
    echo "0. Exit"
    echo "1. Play a game"
    echo "2. Display scores"
    echo "3. Reset scores"
    echo "Enter an option:"
    
    read menu_choice
    
    if [[ "$menu_choice" == "0" ]]; then
        echo "See you later!"
        exit
    elif [[ "$menu_choice" == "1" ]]; then
        api_login=$(curl --silent -u rihanna:785bdf267c5244 --cookie-jar cookie.txt http://127.0.0.1:8000/login)
        echo "What is your name?"
        read player_name

    RANDOM=4096
    points=0
    correct_answers=0
    while true; do
        api_output=$(curl --silent --cookie cookie.txt http://127.0.0.1:8000/game)
        #question=$(echo "$api_output" | sed 's/.*"question": *"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')
        api_question=$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('question', ''))" "$api_output")
        api_answer=$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('answer', ''))" "$api_output")
        echo "$api_question"
        echo "True or False?"
        read user_answer
    
        if [[ "$user_answer" == "$api_answer" ]]; then
            ((points+=10))
            ((correct_answers+=1))
            words=("Perfect!" "Awesome!" "You are a genius!" "Wow!" "Wonderful!")
            random_string="${words[$((RANDOM % ${#words[@]}))]}"
            echo -e "$random_string\n"
        else
            echo "Wrong answer, sorry!"
            echo "$player_name you have $correct_answers correct answer(s)."
            echo -e "Your score is $points points."
            echo "User: $player_name, Score: $points, Date: $(date +%Y-%m-%d)" >> scores.txt
            break
        fi
    done
        
    elif [[ "$menu_choice" == "2" ]]; then
        if [[ -f scores.txt && -s scores.txt ]]; then echo -e "Player scores"; cat scores.txt
        else echo "File not found or no scores in it!"
        fi
    elif [[ "$menu_choice" == "3" ]]; then
        if [[ -f scores.txt ]]; then
            rm scores.txt
            echo "File deleted successfully!"
        else echo "File not found or no scores in it!"
        fi
    else
        echo -e "Invalid option!\n"
    fi
done
