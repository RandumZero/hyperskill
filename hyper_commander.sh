#! /usr/bin/env bash

echo -e "Hello $USER!\n"

while true; do
    echo "------------------------------"
    echo "| Hyper Commander            |"
    echo "| 0: Exit                    |"
    echo "| 1: OS info                 |"
    echo "| 2: User info               |"
    echo "| 3: File and Dir operations |"
    echo "| 4: Find Executables        |"
    echo "------------------------------"
    
    read menu_choice
    
    if [[ "$menu_choice" == '0' ]]; then
        echo "Farewell!"
        exit
    elif [[ "$menu_choice" == '1' ]]; then
        echo -e "$(uname -on)\n"
    elif [[ "$menu_choice" == '2' ]]; then
        echo -e "$(whoami)\n"
    elif [[ "$menu_choice" == '3' ]]; then
        while true; do
            pwd_contents=(*)
            
            echo -e "The list of files and directories:\n"
            for item in "${pwd_contents[@]}"; do
                if [[ -f "$item" ]]; then
                    echo "F $item"
                elif [[ -d "$item" ]]; then
                    echo "D $item"
                fi
            done
    
            echo -e "\n---------------------------------------------------"
            echo "| 0 Main menu | 'up' To parent | 'name' To select |"
            echo "---------------------------------------------------"
    
            read menu_choice
            regex_string=$(IFS='|'; echo "${pwd_contents[*]}")
            if [[ "$menu_choice" == '0' ]]; then
                break
            elif [[ "$menu_choice" == 'up' ]]; then
                cd ..
                continue
            elif [[ "$menu_choice" =~ ^($regex_string)$ ]]; then
                if [[ -d "$menu_choice" ]]; then
                    cd "$menu_choice"
                    continue
                elif [[ -f "$menu_choice" ]]; then
                    while true; do
                        echo -e "\n---------------------------------------------------------------------"
                        echo -e "| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"
                        echo -e "---------------------------------------------------------------------"
    
                        read filemenu_choice
    
                        if [[ $filemenu_choice == "0" ]]; then
                            break
                        elif [[ $filemenu_choice == "1" ]]; then
                            rm $menu_choice
                            echo -e "$menu_choice has been deleted.\n"
                            break
                        elif [[ $filemenu_choice == "2" ]]; then
                            echo "Enter the new file name:"
                            read new_filename
                            mv "$menu_choice" "$new_filename"
                            echo -e "$menu_choice has been renamed as $new_filename\n"
                            break
                        elif [[ $filemenu_choice == "3" ]]; then
                            chmod ugo+rw $menu_choice
                            echo "Permissions have been updated."
                            ls -l "$menu_choice"
                            echo -e "\n"
                            break
                        elif [[ $filemenu_choice == "4" ]]; then
                            chmod ug+rw "$menu_choice"
                            chmod o=r "$menu_choice"
                            echo "Permissions have been updated."
                            ls -l "$menu_choice"
                            echo -e "\n"
                            break
                        else
                            continue
                        fi
                    done
                fi
            else
                echo -e "Invalid input!\n"
            fi
        done
    elif [[ "$menu_choice" == '4' ]]; then
        echo "Enter an executable name:"
        read exe_name

        exe_path=$(find /usr/bin -type f -name "$exe_name" -print -quit)
        if [[ "$exe_path" == "" ]]; then
            echo -e "The executable with that name does not exist!\n"
        else
            #exe_path=find "$PWD" -type f -name "$exe_name"
            echo -e "Located in: $exe_path\n"
            echo "Enter arguments:"
            read -a exe_arguments
            bash "$exe_path/$exe_name ${exe_arguments[@]}"
            echo "End of the project, congratulations!"
        fi            
    else
        echo "Invalid option!"
    fi
done
