Sommaire

À propos du projet
Développement du script Shell et du programme C
Gestion et traitement des données
Création de graphiques avec Gnuplot
Organisation et stockage des données et des résultats
Flexibilité et évolutivité
Technologies utilisées
Pour commencer
Prérequis
Installation
Utilisation
Préparation du fichier de données
Exécution du script
Compréhension des options
Consultation des résultats
À propos du projet

Le projet CY Truck, dirigé par Eva Ansermin et Romuald Grignon, consiste à créer un programme pour gérer la logistique d'une entreprise de transport routier national. Ce projet vise à relever le défi du traitement manuel de données logistiques nombreuses et variées en automatisant l'analyse des fichiers de données et la génération de graphiques résumant les activités de l'entreprise.

Développement du script Shell et du programme C

Le projet implique le développement d'un script Shell et d'un programme C pour analyser le fichier de données et créer des graphiques. Le script Shell gère le flux d'opérations, tandis que le programme C se concentre sur les tâches critiques en termes de performances.

Gestion et traitement des données

Le programme gère un fichier CSV contenant des données de trajet routier, comprenant des détails tels que 'RouteID', 'StepID', 'Départs', 'Arrivées', 'Distance' et 'Noms des conducteurs'.

Création de graphiques avec Gnuplot

Après le traitement des données, le script Shell utilise Gnuplot pour créer des graphiques illustrant différents aspects des données, tels que les conducteurs ayant réalisé le plus de trajets, les distances les plus longues parcourues, les trajets les plus longs et les villes les plus traversées.

Organisation et stockage des données et des résultats

Les données d'entrée, les programmes, les graphiques et les fichiers intermédiaires sont organisés dans des dossiers spécifiques pour une meilleure gestion, assurant ainsi clarté et facilité d'accès.

Flexibilité et évolutivité

Le projet est conçu pour être flexible et évolutif, permettant des améliorations et des adaptations pour répondre à des besoins spécifiques ou pour prendre en charge des exigences futures.

Technologies utilisées

C
Script Shell
Pour commencer

Prérequis
Assurez-vous d'avoir les prérequis suivants installés sur votre système :

Gnuplot : Utilisé pour générer des graphiques à partir de données.
Make : Outil d'automatisation de construction pour la création de programmes exécutables et de bibliothèques.
ImageMagick : Suite logicielle pour la manipulation d'images.
Installation
Clonez le dépôt :
bash
Copy code
git clone https://github.com/guinat/Projet_CY_Truck_preIng2_2023_2024.git
Accédez au répertoire du projet :
bash
Copy code
cd Projet_CY_Truck_preIng2_2023_2024/
Utilisation

Préparation du fichier de données
Assurez-vous d'avoir un fichier CSV contenant des données de trajet routier préparé et prêt à être utilisé. Le fichier doit inclure des détails tels que 'RouteID', 'StepID', 'Départs', 'Arrivées', 'Distance' et 'Noms des conducteurs'.

Exécution du script
Avant d'exécuter le script, assurez-vous que le script principal a les permissions nécessaires pour être exécuté :

bash
Copy code
chmod +x main.sh
Pour exécuter le programme, utilisez le format de commande suivant dans votre terminal, en remplaçant [chemin_vers_fichier_csv] par le chemin réel de votre fichier CSV et [option] par l'option d'opération souhaitée :

bash
Copy code
./main.sh [chemin_vers_fichier_csv] [option]
Compréhension des options
L'[option] représente les différentes opérations que vous pouvez effectuer avec le script. Les options disponibles comprennent :

-h : Affiche un message d'aide expliquant les options disponibles.
-d1 : Génère un histogramme des 10 conducteurs ayant effectué le plus de trajets.
-d2 : Génère un histogramme des 10 conducteurs ayant effectué les trajets les plus longs.
-l : Génère un histogramme des 10 trajets les plus longs.
-t : Génère un histogramme des 10 villes les plus visitées.
-s : Génère un graphique à barres avec des statistiques sur la variation des distances pour chaque trajet.
Consultation des résultats
Après avoir exécuté le script avec l'option choisie, les résultats, tels que les graphiques, seront générés et généralement enregistrés dans un dossier de sortie désigné (images). Ces résultats seront également affichés à l'écran pour la visualisation et l'analyse.
