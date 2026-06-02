#!/usr/bin/env bash

echo -e "File Janitor, 2026\nPowered by Bash"

if [[ "$1" == "help" ]]; then
    echo ""
    while IFS= read -r line; do
        echo "$line"
    done <./file-janitor-help.txt
elif [[ "$1" == "list" ]]; then
    if [[ "$2" == "" ]]; then
        echo -e "\nListing files in the current directory\n"
        ls -A
    elif [[ ! -e "$2" ]]; then
        echo -e "\n$2 is not found"
    elif [[ ! -d "$2" ]]; then
        echo -e "\n$2 is not a directory\n"
    elif [[ -d "$2" ]]; then
        echo -e "\nListing files in $2\n"
        ls -A $2
    fi  
elif [[ "$1" == "report" ]]; then

    if [[ "$2" == "" ]]; then
        count_tmp=$(find . -maxdepth 1 -type f -name "*.tmp" | wc -l)
        count_log=$(find . -maxdepth 1 -type f -name "*.log" | wc -l)
        count_py=$(find . -maxdepth 1 -type f -name "*.py" | wc -l)
    
        size_tmp=$(find . -maxdepth 1 -type f -name "*.tmp" -exec du -bc {} +| tail -n 1 | awk '{print $1}')
        size_log=$(find . -maxdepth 1 -type f -name "*.log" -exec du -bc {} +| tail -n 1 | awk '{print $1}')
        size_py=$(find . -maxdepth 1 -type f -name "*.py" -exec du -bc {} +| tail -n 1 | awk '{print $1}')
    
        echo -e "\nThe current directory contains:"
        echo "$count_tmp tmp file(s), with total size of $size_tmp bytes"
        echo "$count_log log file(s), with total size of $size_log bytes"
        echo "$count_py py file(s), with total size of $size_py bytes"
    elif [[ ! -e "$2" ]]; then
        echo -e "\n$2 is not found"
    elif [[ ! -d "$2" ]]; then
        echo -e "\n$2 is not a directory\n"
    elif [[ -d "$2" ]]; then
        count_tmp=$(find "./$2" -maxdepth 1 -type f -name "*.tmp" | wc -l)
        count_log=$(find "./$2" -maxdepth 1 -type f -name "*.log" | wc -l)
        count_py=$(find "./$2" -maxdepth 1 -type f -name "*.py" | wc -l)
    
        size_tmp=$(find "./$2" -maxdepth 1 -type f -name "*.tmp" -exec du -bc {} +| tail -n 1 | awk '{print $1}')
        size_log=$(find "./$2" -maxdepth 1 -type f -name "*.log" -exec du -bc {} +| tail -n 1 | awk '{print $1}')
        size_py=$(find "./$2" -maxdepth 1 -type f -name "*.py" -exec du -bc {} +| tail -n 1 | awk '{print $1}')

        if [[ $size_tmp == "" ]]; then size_tmp=0; fi
        if [[ $size_log == "" ]]; then size_log=0; fi
        if [[ $size_py == "" ]]; then size_py=0; fi
        
        echo -e "\n$2 contains:"
        echo "$count_tmp tmp file(s), with total size of $size_tmp bytes"
        echo "$count_log log file(s), with total size of $size_log bytes"
        echo "$count_py py file(s), with total size of $size_py bytes"
    fi
elif [[ "$1" == "clean" ]]; then
    if [[ "$2" == "" ]]; then          
        echo -e "\nCleaning the current directory..."
        
        echo -n "Deleting old log files..."
        count_rm_log=$(find . -maxdepth 1 -mtime +3 -type f -name "*.log" | wc -l)
        find . -maxdepth 1 -mtime +3 -type f -name "*.log" -exec rm {} \;
        if [[ $count_rm_log == "" ]]; then count_rm_log=0; fi
        echo "  done! $count_rm_log files have been deleted"
        
        echo -n "Deleting temporary files..."
        count_rm_tmp=$(find . -maxdepth 1 -type f -name "*.tmp" | wc -l)
        find . -maxdepth 1 -type f -iname "*.tmp" -exec rm {} \;
        if [[ $count_rm_tmp == "" ]]; then count_rm_tmp=0; fi
        echo "  done! $count_rm_tmp files have been deleted"
        
        echo -n "Moving python files..."
        
        count_rm_py=$(find . -maxdepth 1 -type f -name "*.py" | wc -l)
        if [[ $count_rm_py != 0 ]]; then
            if [[ ! -d ./python_scripts ]]; then
                mkdir ./python_scripts
            fi
        fi      
        find . -maxdepth 1 -type f -name "*.py" -exec mv {} ./python_scripts \;
        echo "  done! $count_rm_py files have been moved"

        echo -e "\nClean up of the current directory is complete!"
        
    elif [[ ! -e "$2" ]]; then
        echo -e "\n$2 is not found"
    elif [[ ! -d "$2" ]]; then
        echo -e "\n$2 is not a directory\n"
    elif [[ -d "$2" ]]; then
        echo -e "\nCleaning $2..."
        
        echo -n "Deleting old log files..."
        count_rm_log=$(find "$2" -maxdepth 1 -mtime +3 -type f -name "*.log" | wc -l)
        find "$2" -maxdepth 1 -mtime +3 -type f -name "*.log" -exec rm {} \;
        if [[ $count_rm_log == "" ]]; then count_rm_log=0; fi
        echo "  done! $count_rm_log files have been deleted"
        
        echo -n "Deleting temporary files..."
        count_rm_tmp=$(find "$2" -maxdepth 1 -type f -name "*.tmp" | wc -l)
        find "$2" -maxdepth 1 -type f -name "*.tmp" -exec rm {} \;
        if [[ $count_rm_tmp == "" ]]; then count_rm_tmp=0; fi
        echo "  done! $count_rm_tmp files have been deleted"
        
        echo -n "Moving python files..."
        count_rm_py=$(find "$2" -maxdepth 1 -type f -name "*.py" | wc -l)
        if [[ $count_rm_py != 0 ]]; then
            if [[ ! -d "$2"/python_scripts ]]; then
                mkdir "$2"/python_scripts
            fi
        fi
        find "$2" -maxdepth 1 -type f -name "*.py" -exec mv {} "$2"/python_scripts \;
        echo "  done! $count_rm_py files have been moved"

        echo -e "\nClean up of $2 is complete!"
    fi 
else
    echo -e "\nType file-janitor.sh help to see available options"
fi
