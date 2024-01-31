#!/bin/bash
chmod +x Truck.sh
CSV_FILE="$1"
TEMP_DIR="temp"
IMAGE_DIR="images"


log() {
    echo "$(date +"[%Y-%m-%d %H:%M:%S]") $1"
}

checkDependencies() {
    # Vérifier la présence de gnuplot
    if ! command -v gnuplot &> /dev/null; then
        log "Erreur : gnuplot n'est pas installé. Veuillez l'installer."
        exit 1
    fi
}



checkDirectories() {
    local files="data/data.csv"
    local tempDir="temp"
    local imageDir="images"

    # Vérifier si le fichier $csvFile existe
    [ ! -f "$files" ] && { log "Erreur : Le fichier data.csv n'existe pas ou est renommée. Veuillez l'insérer dans le répertoire data"; exit 1; }

    # Vérifier et créer le dossier Temp s'il n'existe pas
    [ ! -d "$tempDir" ] && mkdir "$tempDir" || rm -f "$tempDir"/*

    # Vérifier et créer le dossier Image s'il n'existe pas
    [ ! -d "$imageDir" ] && mkdir "$imageDir" || rm -f "$imageDir"/*
}






help() {
    # Définir les caractères de cadre
    frame_char="*"
    frame_width=60

    # Afficher le cadre supérieur
    echo -e "\e[1m\e[34m${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}\e[0m                   \e[1mOptions disponibles\e[0m                   \e[1m\e[34m${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}${frame_char}\e[0m"

    # Afficher le contenu avec un style volumétrique
    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-h\e[0m                    Affiche le menu d'aide\e[0m"
    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-d1\e[0m                   Affiche un histogramme des 10 conducteurs avec le plus grand nombre de trajets\e[0m"
    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-d2\e[0m                   Affiche un histogramme des 10 conducteurs avec les trajets les plus longs\e[0m"
    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-l\e[0m                    Affiche un histogramme des 10 trajets les plus longs\e[0m"
    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-t\e[0m                    Affiche un histogramme des 10 villes les plus visitées\e[0m"
    echo -e "\e[1m${frame_char}\e[0m\e[34m  \e[1m-s\e[0m                    Affiche un diagramme à barres d'erreur avec les statistiques sur la variation des distances\e[0m"
    echo -e "\e\e[0m                         de chaque trajet, les 50 premières routes avec la plus grande variation de distance de chaque route\e[0m"
      
    # Note
    echo -e "\e[1m\e[92mNote:\e[0m Utilisez l'option -h pour afficher cette aide."
}

App_d1() 
{
    grep '^[^;]*;1;' data/data.csv | awk -v OFS=';' -F';' '{ Traj[$6]++ } END {for (conducteur in Traj) print conducteur, Traj[conducteur] }' | sort -t';' -nrk2,2 | head -n10 > temp/first_d1flag.csv
    awk -v OFS=';' -F';' '{print $2, $1}' temp/first_d1flag.csv > temp/Final_d1.csv

    # Generate horizontal histogram using gnuplot
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

# Rotation finale de l'image
convert -rotate 90 images/histogram_d1.png images/histogram_d1.png

    
}
App_d2() 
{
    cut -d';' -f5,6 data/data.csv | awk -v OFS=';' -F';' 'NR>1 { Dist[$2]+=$1} END {for (conducteur in Dist) print conducteur, Dist[conducteur]}' | sort -t';' -nrk2,2 | head -n10 > temp/first_d2.csv
    awk -v OFS=';' -F';' '{print $2, $1}' temp/first_d2.csv > temp/Final_d2.csv

    # fzefezefzefz
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

convert -rotate 90 -bordercolor white -border 70x70 images/D2.png images/D2.png

}
App_l() 
{
    cut -d';' -f1,5 data/data.csv | awk -v OFS=';' -F';' 'NR>1 { Long[$1]+= $2;} END {for (Route_id in Long) {print Route_id, Long[Route_id];}}' | sort -t';' -k2nr | head -n10  > temp/First_l.csv
    sort -t';' -k1,1nr temp/first_l.csv > temp/inactive_l.csv
    awk -v OFS='; ' -F';' '{print $2, $1}' temp/inactive_l.csv > temp/Final_l.csv
     
    # zqdqzdqgzgqzg
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

  
}



App_t() 
{
    log "pas encore..."
  
}
App_s() 
{
    clog "pas encore..."
  
}

check() {
    if [ "$#" -eq 0 ]; then
        log "Aucun argument fourni. Utilisez l'option -h pour afficher l'aide."
        return 1  # Retourne un code d'erreur pour indiquer que quelque chose s'est mal passé
    elif [ "$#" -gt 2 ]; then
        log "Erreur : Trop d'arguments fournis. Vous ne devez spécifier qu'un seul argument."
        exit 1
    fi
    if [ "$1" != "files" ]; then
        log "Erreur : Le premier argument doit être 'files'."
        exit 1
    fi
    checkDirectories "$1"
}
processOption() {
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
            echo "Option invalide : $option. Utilisez -h pour afficher l'aide."
            exit 1
            ;;
    esac
}
runScript() {

    checkDependencies
    checkDirectories "$CSV_FILE" "$TEMP_DIR" "$IMAGE_DIR" || exit 1
    check "$@"
    local valid_options=("d1" "d2" "t" "l" "s")

    # Vérifier si l'argument est l'une des options spécifiées
    if [[ " ${valid_options[@]} " =~ " $2 " ]]; then
        # Obtenir l'heure locale en secondes depuis l'époque
        local init_time=$(date +%s)

        # Exécuter la tâche (remplacez cette partie par votre propre tâche)
        processOption "$@"

        # Obtenir le temps après l'exécution de la tâche
        local end_time=$(date +%s)

        # Calculer la durée d'exécution
        local duration=$((end_time - init_time))
        log "Durée d'exécution de la tâche : $duration secondes"
    elif [ "$2" == "-h" ]; then
    # Exécuter processOption avec l'option -h
   
    processOption "$@"
    exit 0

    else
        # Afficher un message d'erreur pour un argument invalide
        log "Argument invalide. Utilisez l'une des options suivantes : d1, d2, t, l, s, -h"
        exit 1
    fi
    
}

# Appeler la fonction
if [ "$1" == "-x" ]; then
    # Mode debug avec profilage
    set -x
    shift  # Supprimer l'option -x des arguments pour éviter une boucle infinie
    check "$@" || exit 1
    runScript "$@"
else
    check "$@" || exit 1
    runScript "$@"
fi





























#COMPILATION : 
 #for executable in "${executables[@]}"; do
    #chemin_complet="$executable_parent/$executable"
   # if [ ! -f "$chemin_complet" ]; then
       # echo "L'exécutable $executable n'est pas présent. Compilation en cours..."
        
        # Compiler le code source
       # make -C progc
        
        # Vérifier si la compilation s'est bien déroulée
       # if [ $? -ne 0 ]; then
            #echo "Erreur lors de la compilation."
            #exit 1
        #fi
    #fi
#done












