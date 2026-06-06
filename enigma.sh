#!/usr/bin/env bash
#----variables
encrypt_key=3

#----functions
ord() {
        value=$(printf "%d\n" "'$1")
        echo $value
    }

chr() {
        char=$(printf "%b\n" "$(printf "\\%03o" "$1")")
        echo $char
    }

#----main
echo "Welcome to the Enigma!"

while true; do
    echo "0. Exit"
    echo "1. Create a file"
    echo "2. Read a file"
    echo "3. Encrypt a file"
    echo "4. Decrypt a file"
    echo "Enter an option:"
    read menu_option

    if [[ $menu_option == "0" ]]; then echo "See you later!"; exit
    elif [[ $menu_option == "1" ]]; then
        regex_filename="^[a-zA-Z.]+$"
        regex_message="^([A-Z]+\s?)+$"
        echo "Enter the filename:"
        read user_filename
    
        if [[ "$user_filename" =~ $regex_filename ]]; then
            echo "Enter a message:"
            read user_message
            if [[ "$user_message" =~ $regex_message ]]; then
                echo "$user_message" > "$user_filename"
                echo -e "The file was created successfully!\n"
            else 
                echo -e "This is not a valid message!\n"
            fi
        else
            echo -e "File name can contain letters and dots only!\n"
        fi
    elif [[ "$menu_option" == "2" ]]; then
        echo "Enter the filename:"
        read user_filename

        if [[ -f "$user_filename" ]]; then
            echo "File content:"
            cat "$user_filename"
            echo -e "\n"
        else
            echo -e "File not found!\n"
        fi
    elif [[ "$menu_option" == "3" ]]; then
        echo "Enter the filename:"
        read user_filename
        
        if [[ -f "$user_filename" ]]; then
            file_change=$(echo "$user_filename".enc)
            echo "Enter password:"
            read user_password
            openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$user_filename" -out "$file_change" -pass pass:"$user_password" &>/dev/null
            exit_code=$?
            if [[ $exit_code -ne 0 ]]; then
                echo "Fail"
            else
                echo -e "Success\n"
                rm "$user_filename"
            fi
        else
            echo -e "File not found!\n"
        fi
    elif [[ "$menu_option" == "4" ]]; then
        echo "Enter the filename:"
        read user_filename
        if [[ -f "$user_filename" ]]; then
            file_change=$(sed 's/\.enc$//' <<< "$user_filename")
            echo "Enter password:"
            read user_password
            openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$user_filename" -out "$file_change" -pass pass:"$user_password" &>/dev/null
            exit_code=$?
            if [[ $exit_code -ne 0 ]]; then
                echo "Fail"
            else
                echo -e "Success\n"
                rm "$user_filename"
            fi
        else
            echo -e "File not found!\n"
        fi
    else
        echo -e "Invalid option!\n"
    fi
done
