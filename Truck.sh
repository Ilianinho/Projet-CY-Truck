#!/bin/bash
#    )__                     (__   ____)
#    _ )_                      (____)
#  __    )__            
#     ______)                   ___   
#  _____)                   ___(   )__
#                          (_       __)
#                           (_  ___)
#                            (___)
#                                                                                                                                           _______________________________________________________
#                                                                                                                                      /    | 							  |
#                                                                                                                                     /     |  Hello ! Here is our Shell Script! I hope you enjoy  |
#                                                                                                                                    /---,  |         the ride when reading the program!           |
#                                                                                                                               -----# ==|  |                  Good reading !                      |
#                                                                                                                               | :) # ==|  |                                                      |
#                                                                                                                          -----'----#   |  |______________________________________________________|
#                                                                                                                             |)___()  '#   |______====____   \___________________________________|
#                                                                                                                            [_/,-,\"--"------ //,-,  ,-,\\\   |/             //,-,  ,-,  ,-,\\ __#
#                                                                                                                              ( 0 )|===******||( 0 )( 0 )||-  o              '( 0 )( 0 )( 0 )||
#-------------------------------------------------------------------------------------------------------------------------------'-'--------------'-'--'-'-----------------------'-'--'-'--'-'----------



inputFile="$1"





# Get the current executable path
ExecutablePath=$(cd `dirname $0`; pwd)


log() {
    echo "$(date +"[%Y-%m-%d %H:%M:%S]") $1"
}

# Function to check the presence of dependencies
checkDependencies() {
    # Check if gnuplot is installed
    if ! command -v gnuplot &> /dev/null; then
        log "Error: gnuplot is not installed. Please install it."
        exit 1
    fi
}

# Function to check the existence of C executables and compile if needed
existence_executable() {
    # Check if the executable prog_t exists; if not, compile it
    if [ ! -f "$ExecutablePath/progc/prog_t" ]; then
        cd $ExecutablePath/progc
        make prog_t
        result=$?
        if [ "$result" -ne 0 ]; then
            log "Error compiling C scripts for the 't' option"
            exit 1
        fi
        cd $ExecutablePath
    fi

    # Check if the executable prog_s exists; if not, compile it
    if [ ! -f "$ExecutablePath/progc/prog_s" ]; then
        cd $ExecutablePath/progc
        make prog_s
        result=$?
        if [ "$result" -ne 0 ]; then
            log "Error compiling C scripts for the 's' option"
            exit 1
        fi
        cd $ExecutablePath
    fi
}

# Function to check and create necessary directories
checkDirectories() {
    local files="$1"
    local tempDir="temp"
    local imageDir="images"

    # Check if the data.csv file exists
    [ ! -f "$files" ] && { log "Error: The file data.csv does not exist or has been renamed. Please insert it into the data directory."; exit 1; }

    # Check and create the Temp directory if it doesn't exist
    [ ! -d "$tempDir" ] && mkdir "$tempDir" || rm -f "$tempDir"/*

    # Check and create the Image directory if it doesn't exist
    [ ! -d "$imageDir" ] && mkdir "$imageDir" || rm -f "$imageDir"/*
}




help() {
    frame_char="*"
    frame_width=60
    echo "                         "
    echo -e "\e[1m\e[31m                   ${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}\e[0m                   \e[1m\e[91mCommande à éxécuter\e[0m                   \e[1m\e[31m${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}                           \e[0m"
    echo "                                           "
    echo "                              ./Truck.sh <chemin_vers_csv> <argument_1> <argument_2> ...                                                            " 
    echo "------------------------------------------------------------------------------------------------------------------------------------------"
    echo "                                           "
    echo -e "\e[1m\e[32m                   ${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}\e[0m                   \e[1m\e[92mOptions disponibles\e[0m                   \e[1m\e[32m${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}\e[0m"
    echo "                                           "
    echo -e "\e[1m\e[92m${frame_char}\e[0m\e[34m  \e[1m-h\e[0m                    Affiche le menu d'aide\e[0m"
    echo -e "\e[1m\e[92m${frame_char}\e[0m\e[34m  \e[1m-d1\e[0m                   Affiche un histogramme des 10 conducteurs avec le plus grand nombre de trajets\e[0m"
    echo -e "\e[1m\e[92m${frame_char}\e[0m\e[34m  \e[1m-d2\e[0m                   Affiche un histogramme des 10 conducteurs avec les trajets les plus longs\e[0m"
    echo -e "\e[1m\e[92m${frame_char}\e[0m\e[34m  \e[1m-l\e[0m                    Affiche un histogramme des 10 trajets les plus longs\e[0m"
    echo -e "\e[1m\e[92m${frame_char}\e[0m\e[34m  \e[1m-t\e[0m                    Affiche un histogramme des 10 villes les plus visitées\e[0m"
    echo -e "\e[1m\e[92m${frame_char}\e[0m\e[34m  \e[1m-s\e[0m                    Affiche un diagramme à barres d'erreur avec les statistiques sur la variation des distances\e[0m"
    echo -e "\e[1m\e[92m                         \e[0m                         de chaque trajet, les 50 premières routes avec la plus grande variation de distance de chaque route\e[0m"
    echo "                                      "  
    echo -e "\e[1m\e[92mNote:\e[0m Utilisez ./Truck.sh -h pour afficher cette aide plus rapidement."
    echo "------------------------------------------------------------------------------------------------------------------------------------------"
    echo "            "
}



App_d1() # Function to process and visualize data for option -d1
{   
    log "reading csv file... $(tput setaf 1)15%$(tput sgr0)"
    # Extract relevant data, count routes per driver, and output the top 10 drivers with the most routes
    grep '^[^;]*;1;' "$inputFile" | awk -v OFS=';' -F';' '{ Traj[$6]++ } END {for (conducteur in Traj) print conducteur, Traj[conducteur] }' | sort -t';' -nrk2,2 | head -n10 > temp/first_d1.csv
    log "first sort for d1... $(tput setaf 214)40%$(tput sgr0)"
    # Rearrange columns in the final output file
    awk -v OFS=';' -F';' '{print $2, $1}' temp/first_d1.csv > temp/Final_d1.csv
    log "final sort for d2... $(tput setaf 3)70%$(tput sgr0)"
    
    # Generate a horizontal histogram using gnuplot
    gnuplot <<-EOF
        set terminal png size 900,1000
        set output 'images/D1.png'
        set label "Option -d1: Nb routes = f(Driver)" at -1.5,95 rotate by 90
        set ylabel "NB ROUTES" offset 87
        set xlabel "DRIVER NAMES"
        set style data histograms
        set style fill solid border -1
        set yrange [0:250]
        set boxwidth 2.0  
        set xtic rotate 90
        set ytic rotate 90 offset 83
        set ytic 50
        set style line 1 lc rgb "#8dd3c7"
        set style line 2 lc rgb "#ffffb3"
        set style line 3 lc rgb "#bebada"
        set style line 4 lc rgb "#fb8072"
        set style line 5 lc rgb "#80b1d3"
        set style line 6 lc rgb "#fdb462"
        set style line 7 lc rgb "#b3de69"
        set style line 8 lc rgb "#fccde5"
        set style line 9 lc rgb "#d9d9d9"
        set style line 10 lc rgb "#bc80bd"
            
        plot 'temp/Final_d1.csv' using 1:xtic(2) notitle ls 1
EOF
    log "images for d1 done... $(tput setaf 2)100%$(tput sgr0)"
    # Rotate the final image
    convert -rotate 90 images/D1.png images/D1.png
    xdg-open images/D1.png
}





App_d2()     # Function to process and visualize data for option -d2
{ 
    log "reading csv file... $(tput setaf 1)15%$(tput sgr0)"
    # Extract relevant data, calculate total distance per driver, and output the top 10 drivers with the longest distances
    cut -d';' -f5,6 "$inputFile" | awk -v OFS=';' -F';' 'NR>1 { Dist[$2]+=$1} END {for (conducteur in Dist) print conducteur, Dist[conducteur]}' | sort -t';' -nrk2,2 | head -n10 > temp/first_d2.csv
    log "first sort for d2... $(tput setaf 214)40%$(tput sgr0)"
    # Rearrange columns in the final output file
    awk -v OFS=';' -F';' '{print $2, $1}' temp/first_d2.csv > temp/Final_d2.csv
    log "final sort for d2... $(tput setaf 3)70%$(tput sgr0)"
    # Generate a horizontal histogram using gnuplot
    gnuplot <<-EOF
        set terminal png size 1000,1200
        set output 'images/D2.png'
        set label "Option -d2: Distance = f(Driver)" at -1.5,58000 rotate by 90
        set ylabel "DISTANCE(Km)" offset 98
        set xlabel "DRIVER NAMES" 
        set style data histograms
        set style fill solid border -1
        set yrange [0:160000]
        set boxwidth 2.0  
        set xtic rotate 90
        set ytic rotate 90 offset 93
        set ytic 20000
        set style line 1 lc rgb "#8dd3c7"
        set style line 2 lc rgb "#ffffb3"
        set style line 3 lc rgb "#bebada"
        set style line 4 lc rgb "#fb8072"
        set style line 5 lc rgb "#80b1d3"
        set style line 6 lc rgb "#fdb462"
        set style line 7 lc rgb "#b3de69"
        set style line 8 lc rgb "#fccde5"
        set style line 9 lc rgb "#d9d9d9"
        set style line 10 lc rgb "#bc80bd"
		    
        plot 'temp/Final_d2.csv' using 1:xtic(2) notitle ls 1
EOF
   log "images for d2 done... $(tput setaf 2)100%$(tput sgr0)"
    # Rotate, add border, and display the final image
    convert -rotate 90 -bordercolor white -border 70x70 images/D2.png images/D2.png
    xdg-open images/D2.png
}




App_l()  # Function to process and visualize data for option -l
{
    # Extract relevant data, calculate total distance per route, and output the top 10 routes with the longest distances
    cut -d';' -f1,5 "$inputFile" | awk -v OFS=';' -F';' 'NR>1 { Long[$1]+= $2;} END {for (Route_id in Long) {print Route_id, Long[Route_id];}}' | sort -t';' -k2nr | head -n10  > temp/first_l.csv
    log "first sort for l... $(tput setaf 1)15%$(tput sgr0)"
    # Sort the output based on Route_id in descending order
    sort -t';' -k1,1nr temp/first_l.csv > temp/inactive_l.csv
    log "inactive sort for l... $(tput setaf 214)40%$(tput sgr0)"
    # Rearrange columns in the final output file
    awk -v OFS='; ' -F';' '{print $2, $1}' temp/inactive_l.csv > temp/Final_l.csv
    log "Alphabetic sort for l... $(tput setaf 3)90%$(tput sgr0)"
    
     
    # Generate a vertical histogram using gnuplot
    gnuplot <<-EOF
        set terminal png size 900,1000  
        set output 'images/L.png'
        set title "Option -l: Distance = f(Route)"
        set ylabel "DISTANCE (Km)"
        set xlabel "ROUTE ID"
        set style data histograms
        set style fill solid border -1
        set style line 1 lc rgb "#8dd3c7"
        set style line 2 lc rgb "#ffffb3"
        set style line 3 lc rgb "#bebada"
        set style line 4 lc rgb "#fb8072"
        set style line 5 lc rgb "#80b1d3"
        set style line 6 lc rgb "#fdb462"
        set style line 7 lc rgb "#b3de69"
        set style line 8 lc rgb "#fccde5"
        set style line 9 lc rgb "#d9d9d9"
        set style line 10 lc rgb "#bc80bd"
        set style histogram clustered gap 0.5  
        set boxwidth 0.7
        set yrange [0:3000]
        set ytic 600
    
        plot 'temp/Final_l.csv' using 1:xtic(2) notitle ls 1
EOF
log "images for l done... $(tput setaf 2)100%$(tput sgr0)"
    # Open the generated image
    xdg-open images/L.png
}





App_t() # Function to process and visualize data for option -t
{
    # calls the compile function to be able to use the files corresponding to the sorting
    existence_executable
    log "Compilation for t... $(tput setaf 1)15%$(tput sgr0)"
    # Process data using AWK to count trips and generate intermediate CSV
    awk -F";" 'NR > 1 {tab[$1";"$4] +=1; if ($2==1) {tab[$1";"$3]+=1; deb[$1";"$3]=1}} END {for (ville in tab) print ville ";" tab[ville] ";" deb[ville] }' "$inputFile" | 
    awk -F";"    '{tab[$2]+=1; 	deb[$2]+=$4} END {for (ville in tab) print ville "," tab[ville] "," deb[ville]}' > $ExecutablePath/temp/first_t.csv
    log "first sort for t... $(tput setaf 214)30%$(tput sgr0)"
    ./progc/prog_t $ExecutablePath/temp/first_t.csv > $ExecutablePath/temp/inactive_t.csv 
    log "final sort for t done... $(tput setaf 3)70%$(tput sgr0)"           # Run C program to process the intermediate CSV
    sort -t ',' -k1,1 $ExecutablePath/temp/inactive_t.csv > $ExecutablePath/temp/Final_t.csv     # Here we sort the intermediate file in alphabetical order
    log "Alphabetic sort for t... $(tput setaf 3)90%$(tput sgr0)"

    # Generate a grouped histogram using gnuplot
    gnuplot <<-EOF
        set terminal pngcairo enhanced font 'arial,10' size 800,600
        set output 'images/T.png'

        # Set CSV delimiters
        set datafile separator ","

        # Define grouped histogram style
        set style data histograms
        set style histogram clustered gap 1
        set style fill solid border -1

        # Rotate x-axis labels
        set xtics rotate by -45 
        set xtics auto
        set xlabel "Villes"
        set boxwidth 0.45 absolute   # Adjust this value according to preference
        set style histogram clustered gap 0.02  # Adjust this value according to preference

        # Set y-axis labels
        set ylabel "Nombre de trajets"

        # Graph title
        set title "Histogramme regroupé du nombre de trajets par ville"

        # Load data from CSV file
        plot 'temp/Final_t.csv' using (\$0):2:xticlabel(1) with boxes lc rgbcolor 'light-blue' notitle,\
        '' using (\$0+0.2):(\$3) with boxes lc rgbcolor 'cyan' notitle
EOF
    log "images for T.png done... $(tput setaf 2)100%$(tput sgr0)"
    # Open the generated image
    xdg-open images/T.png
}


App_s() # Function to process and visualize data for option -s
{
    
    existence_executable
    log "Compilation done... $(tput setaf 1)15%$(tput sgr0)"
    # Sort data by route ID and distance using cut, tail, sort, and sed in first_s.csv
    cut -d';' -f1,5 "$inputFile" | tail -n +2  | sort -t';' -k1,1n | sed 's/;/ /g'> $ExecutablePath/temp/first_s.csv
    # Run C program to process the sorted data to Final_s.csv
    log "first sort for s... $(tput setaf 214)40%$(tput sgr0)"
    ./progc/prog_s
    sed -i '1d' $ExecutablePath/temp/Final_s.csv   #put it on Final_s.csv
    log "Alphabetic sort for s... $(tput setaf 3)90%$(tput sgr0)"

    # Generate a combined plot using gnuplot
    gnuplot -persist <<EOF
        set terminal pngcairo enhanced font 'arial,10' size 1200, 600
        set output 'images/S.png'
        set title "Option -S : Distance = f(Route)"
        set ylabel 'DISTANCE (km)'
        set xlabel 'RIOT id'
        set yrange [0:]
        set xtics rotate by 45 right
        set bmargin 3

        plot 'temp/Final_s.csv' using 0:(\$2):(\$4) with filledcurve lc rgbcolor 'skyblue' title "Distance Max/Min (Km)",\
        '' using 3:xtic(1) smooth mcspline lc rgbcolor 'dark-blue' title "Distance average (Km)"
EOF
   log "images for s done... $(tput setaf 2)100%$(tput sgr0)"
    # Open the generated image
    xdg-open images/S.png
}




# Function: check
# Arguments: Accepts command-line options passed to the script
# Purpose: Check arguments and directories in the command line. If an invalid element is found,
#          or if the first argument is not a valid path to a .csv file, the program stops execution.

check() {
    local valid_elements=("d1" "d2" "t" "l" "s" "-h")  # Array of valid elements

    # Check if no arguments are provided
    if [ "$#" -eq 0 ]; then
        log "No arguments provided. Please check the help :"
        help
        exit 1
    fi

    local first_arg="$1"

    # Check if the first argument is the path to a .csv file
    if [ ! -f "$first_arg" ] || [ "${first_arg##*.}" != "csv" ]; then
        log "Error: The first argument must be a valid path to a .csv file. Please check your syntaxe or the name of the file "
        exit 1
    fi

    # Loop through the command-line arguments starting from the second element (index 2)
    for ((i=2; i<=$#; i++)); do
        local element="${!i}"  # Get the current element

        # Check if the element is valid
        if [[ ! " ${valid_elements[@]} " =~ " $element " ]]; then
            log "Invalid element: $element. Use one of the following options: d1, d2, t, l, s, -h"
            exit 1
        fi
    done

    checkDirectories "$first_arg"  # Call the checkDirectories function with the first argument
}



# Function: processOptions
# Arguments: Accepts an array of command-line options passed to the script
# Purpose: Process multiple options in parallel by forking separate background processes for each option.
#          Each option corresponds to a specific function that performs a specific task.
#          After forking processes, the function waits for all background processes to finish before returning.
#          If an invalid option is encountered, the function prints an error message and exits.

processOptions() {
    local options=("$@")        # Store all command-line options in an array
    local num_options=${#options[@]}  # Get the number of options provided
    local pids=()               # Array to store process IDs (PIDs) of background processes
    local valid_options=("d1" "d2" "t" "l" "s" "-h")  # Array of valid options
    local invalid_option_found=false  # Flag to track if an invalid option is encountered

    # Loop through the options starting from the second element (index 1) in the array
    for ((i=1; i<$num_options; i++)); do
        local option="${options[$i]}"  # Get the current option

        # Check if the option is valid
        if [[ ! " ${valid_options[@]} " =~ " $option " ]]; then
            log "Invalid option: $option. Use -h to display help."
            invalid_option_found=true
            break  # Stop processing options if an invalid option is found
        fi

        # Use a case statement to determine which function to execute based on the option
        case "$option" in
            "d1")
                App_d1 &  # Execute App_d1 function in the background and store its PID
                pids+=($!)  # Add the PID of the background process to the array
                ;;
            "d2")
                App_d2 &  # Execute App_d2 function in the background and store its PID
                pids+=($!)  # Add the PID of the background process to the array
                ;;
            "l")
                App_l &  # Execute App_l function in the background and store its PID
                pids+=($!)  # Add the PID of the background process to the array
                ;;
            "t")
                App_t &  # Execute App_t function in the background and store its PID
                pids+=($!)  # Add the PID of the background process to the array
                ;;
            "s")
                App_s &  # Execute App_s function in the background and store its PID
                pids+=($!)  # Add the PID of the background process to the array
                ;;
            "-h")
                help &  # Execute help function in the background and store its PID
                pids+=($!)  # Add the PID of the background process to the array
                ;;
        esac
    done

    # Wait for all background processes to finish only if no invalid option is found
    if [ "$invalid_option_found" = false ]; then
        for pid in "${pids[@]}"; do
            wait "$pid"
        done
    fi
}

# Function to run the main script
runScript() {
    checkDependencies
    checkDirectories "$1" "temp" "images" || exit 1
    check "$@"
    local valid_options=("d1" "d2" "t" "l" "s")
    
    # Check if the argument is one of the specified options
    if [[ " ${valid_options[@]} " =~ " $2 " ]]; then
        local init_time=$(date +%s)      	# Get the local time in seconds since the epoch
        processOptions "$@"     	# Execute the task (replace this part with your own task)
        local end_time=$(date +%s)     	# Get the time after executing the task
        local duration=$((end_time - init_time))   	# Calculate the execution duration
        log "Task execution duration: $(tput bold)$(tput setaf 4)$duration seconds$(tput sgr0)"
    elif [ "$2" == "-h" ]; then
        processOptions "$@"
        exit 0
    else
        log "Invalid argument. Use one of the following options: d1, d2, t, l, s, -h"
        exit 1
    fi
}



# Call the global function
if [ "$1" == "-h" ]; then
    help
    shift  # Remove the -x option from the arguments to avoid an infinite loop
else
    check "$@" || exit 1
    runScript "$@"
fi




