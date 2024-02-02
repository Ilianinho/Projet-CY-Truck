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
            echo "Error compiling C scripts for the 't' option"
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
            echo "Error compiling C scripts for the 's' option"
            exit 1
        fi
        cd $ExecutablePath
    fi
}

# Function to check and create necessary directories
checkDirectories() {
    local files="$ExecutablePath/data/data.csv"
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
    echo -e "\e[1m\e[34m${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}\e[0m                   \e[1mOptions disponibles\e[0m                   \e[1m\e[34m${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}\e[0m"

    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-h\e[0m                    Affiche le menu d'aide\e[0m"
    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-d1\e[0m                   Affiche un histogramme des 10 conducteurs avec le plus grand nombre de trajets\e[0m"
    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-d2\e[0m                   Affiche un histogramme des 10 conducteurs avec les trajets les plus longs\e[0m"
    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-l\e[0m                    Affiche un histogramme des 10 trajets les plus longs\e[0m"
    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-t\e[0m                    Affiche un histogramme des 10 villes les plus visitées\e[0m"
    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-s\e[0m                    Affiche un diagramme à barres d'erreur avec les statistiques sur la variation des distances\e[0m"
    echo -e "\e\e[0m                         de chaque trajet, les 50 premières routes avec la plus grande variation de distance de chaque route\e[0m"
      
    echo -e "\e[1m\e[92mNote:\e[0m Utilisez l'option -h pour afficher cette aide."
}


App_d1() # Function to process and visualize data for option -d1
{
    # Extract relevant data, count routes per driver, and output the top 10 drivers with the most routes
    grep '^[^;]*;1;' data/data.csv | awk -v OFS=';' -F';' '{ Traj[$6]++ } END {for (conducteur in Traj) print conducteur, Traj[conducteur] }' | sort -t';' -nrk2,2 | head -n10 > temp/first_d1flag.csv
    # Rearrange columns in the final output file
    awk -v OFS=';' -F';' '{print $2, $1}' temp/first_d1flag.csv > temp/Final_d1.csv

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

    # Rotate the final image
    convert -rotate 90 images/D1.png images/D1.png
    xdg-open images/D1.png
}





App_d2()     # Function to process and visualize data for option -d2
{
    # Extract relevant data, calculate total distance per driver, and output the top 10 drivers with the longest distances
    cut -d';' -f5,6 data/data.csv | awk -v OFS=';' -F';' 'NR>1 { Dist[$2]+=$1} END {for (conducteur in Dist) print conducteur, Dist[conducteur]}' | sort -t';' -nrk2,2 | head -n10 > temp/first_d2.csv
    # Rearrange columns in the final output file
    awk -v OFS=';' -F';' '{print $2, $1}' temp/first_d2.csv > temp/Final_d2.csv

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

    # Rotate, add border, and display the final image
    convert -rotate 90 -bordercolor white -border 70x70 images/D2.png images/D2.png
    xdg-open images/D2.png
}




App_l()  # Function to process and visualize data for option -l
{
    # Extract relevant data, calculate total distance per route, and output the top 10 routes with the longest distances
    cut -d';' -f1,5 data/data.csv | awk -v OFS=';' -F';' 'NR>1 { Long[$1]+= $2;} END {for (Route_id in Long) {print Route_id, Long[Route_id];}}' | sort -t';' -k2nr | head -n10  > temp/first_l.csv
    # Sort the output based on Route_id in descending order
    sort -t';' -k1,1nr temp/first_l.csv > temp/inactive_l.csv
    # Rearrange columns in the final output file
    awk -v OFS='; ' -F';' '{print $2, $1}' temp/inactive_l.csv > temp/Final_l.csv
     
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

    # Open the generated image
    xdg-open images/L.png
}





App_t() # Function to process and visualize data for option -t
{
    # calls the compile function to be able to use the files corresponding to the sorting
    existence_executable
    # Process data using AWK to count trips and generate intermediate CSV
    awk -F";" 'NR > 1 {tab[$1";"$4] +=1; if ($2==1) {tab[$1";"$3]+=1; deb[$1";"$3]=1}} END {for (ville in tab) print ville ";" tab[ville] ";" deb[ville] }' $ExecutablePath/data/data.csv | 
    awk -F";"    '{tab[$2]+=1; 	deb[$2]+=$4} END {for (ville in tab) print ville "," tab[ville] "," deb[ville]}' > $ExecutablePath/temp/t_tri.csv
    ./progc/prog_t $ExecutablePath/temp/t_tri.csv > $ExecutablePath/temp/t_top_non_trie.csv            # Run C program to process the intermediate CSV
    sort -t ',' -k1,1 $ExecutablePath/temp/t_top_non_trie.csv > $ExecutablePath/temp/t_top_10.csv     # Here we sort the intermediate file in alphabetical order

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
        plot 'temp/t_top_10.csv' using (\$0):2:xticlabel(1) with boxes lc rgbcolor 'light-blue' notitle,\
        '' using (\$0+0.2):(\$3) with boxes lc rgbcolor 'cyan' notitle
EOF

    # Open the generated image
    xdg-open images/T.png
}


App_s() # Function to process and visualize data for option -s
{
    existence_executable
    # Sort data by route ID and distance using cut, tail, sort, and sed in first_s.csv
    cut -d';' -f1,5 $ExecutablePath/data/data.csv | tail -n +2  | sort -t';' -k1,1n | sed 's/;/ /g'> $ExecutablePath/temp/first_s.csv
    # Run C program to process the sorted data to Final_s.csv
    ./progc/prog_s
    sed -i '1d' $ExecutablePath/temp/Final_s.csv   #put it on Final_s.csv

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

    # Open the generated image
    xdg-open images/S.png
}




check() {    # Function to check arguments and directories in cmd. How many are good and files directory.
    if [ "$#" -eq 0 ]; then
        log "No arguments provided. Use the -h option to display help."
        return 1  
    elif [ "$#" -gt 2 ]; then
        log "Error: Too many arguments provided. You should specify only one argument."
        exit 1
    fi
    if [ "$1" != "files" ]; then
        log "Error: The first argument must be 'files'."
        exit 1
    fi
    checkDirectories "$1"
}


processOption() {   # Function to process command-line arguments
    local option="$2"

    case "$option" in
        "d1")
            App_d1
            ;;
        "d2")
            App_d2
            ;;
        "l")
            App_l
            ;;
        "t")
            App_t
            ;;
        "s")
            App_s
            ;;
        "-h")
            help
            ;;
        *)
            echo "Invalid option: $option. Use -h to display help."
            exit 1
            ;;
    esac
}




runScript() {    # Function to run the main script
    checkDependencies
    checkDirectories "$1" "temp" "images" || exit 1
    check "$@"
    local valid_options=("d1" "d2" "t" "l" "s")
    # Check if the argument is one of the specified options
    if [[ " ${valid_options[@]} " =~ " $2 " ]]; then
        local init_time=$(date +%s)      	# Get the local time in seconds since the epoch
        processOption "$@"     	# Execute the task (replace this part with your own task)
        local end_time=$(date +%s)     	# Get the time after executing the task
        local duration=$((end_time - init_time))   	# Calculate the execution duration
        log "Task execution duration: $duration seconds"
    elif [ "$2" == "-h" ]; then
        processOption "$@"
        exit 0
    else
        log "Invalid argument. Use one of the following options: d1, d2, t, l, s, -h"
        exit 1
    fi
}


# Call the global function
if [ "$1" == "-x" ]; then
    # Debug mode with profiling
    set -x
    shift  # Remove the -x option from the arguments to avoid an infinite loop
    check "$@" || exit 1
    runScript "$@"
else
    check "$@" || exit 1
    runScript "$@"
fi




