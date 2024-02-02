Sommaire

About the project:

CY-Truc is a programm created in order to make the logistic management of a national road transport company (wich uses trucks)
To achieve that goal, the programm process a data file in different ways and provide graphs to better understand how the company run






Requirements:

A CSV file is required, and the datas inside the file data is required must be arranges as the folowing:

Travel_ID; Step_ID; Start; Finish; Distance; Driver_Name

/!\ Make sure the CSV file is named data.CSV, otherwise the programm wont work

Développement du script Shell et du programme C
Gestion et traitement des données
Création de graphiques avec Gnuplot
Organisation et stockage des données et des résultats
Flexibilité et évolutivité
Languages used:
C and Shell
Pour commencer Prérequis Installation 
Utilisation Préparation du fichier de données Exécution du script Compréhension des options Consultation des résultats


Evolution of the project:

note: we started to code the project in 8/01/2023, there were no work done on the project before this date

Sommaire
1. À propos du projet
2. Développement du script Shell et du programme C
3. Gestion et traitement des données
4. Création de graphiques avec Gnuplot
5. Organisation et stockage des données et des résultats
6. Flexibilité et évolutivité
7. Technologies utilisées
8. Pour commencer
o Prérequis
o Installation
9. Utilisation
o Préparation du fichier de données
o Exécution du script
o Compréhension des options
o Consultation des résultats
10. Groupes

À propos du projet
Le projet CY Truck, dirigé par Eva Ansermin et Romuald Grignon, consiste à créer
un programme pour gérer la logistique d&#39;une entreprise de transport routier national.
Ce projet vise à relever le défi du traitement manuel de données logistiques
nombreuses et variées en automatisant l&#39;analyse des fichiers de données et la
génération de graphiques résumant les activités de l&#39;entreprise.
Développement du script Shell et du programme C
Le projet implique le développement d&#39;un script Shell et d&#39;un programme C pour
analyser le fichier de données et créer des graphiques. Le script Shell gère le flux
d&#39;opérations, tandis que le programme C se concentre sur les tâches critiques en
termes de performances.
Gestion et traitement des données

Le programme gère un fichier CSV contenant des données de trajet routier,
comprenant des détails tels que &#39;RouteID&#39;, &#39;StepID&#39;, &#39;Départs&#39;, &#39;Arrivées&#39;, &#39;Distance&#39; et
&#39;Noms des conducteurs&#39;.
Création de graphiques avec Gnuplot
Après le traitement des données, le script Shell utilise Gnuplot pour créer des
graphiques illustrant différents aspects des données, tels que les conducteurs ayant
réalisé le plus de trajets, les distances les plus longues parcourues, les trajets les
plus longs et les villes les plus traversées.
Organisation et stockage des données et des résultats
Les données d&#39;entrée, les programmes, les graphiques et les fichiers intermédiaires
sont organisés dans des dossiers spécifiques pour une meilleure gestion, assurant
ainsi clarté et facilité d&#39;accès.
Flexibilité et évolutivité
Le projet est conçu pour être flexible et évolutif, permettant des améliorations et des
adaptations pour répondre à des besoins spécifiques ou pour prendre en charge des
exigences futures.
Technologies utilisées
 C
 Script Shell
Pour commencer
Prérequis
Assurez-vous d&#39;avoir les prérequis suivants installés sur votre système :
 Gnuplot : Utilisé pour générer des graphiques à partir de données.
 Make : Outil d&#39;automatisation de construction pour la création de programmes
exécutables et de bibliothèques.
 ImageMagick : Suite logicielle pour la manipulation d&#39;images.
Installation
1. Clonez le dépôt :
bashCopy code
git clone https://github.com/guinat/Projet_CY_Truck_preIng2_2023_2024.git
2. Accédez au répertoire du projet :
bashCopy code

cd Projet_CY_Truck_preIng2_2023_2024/
Utilisation
Préparation du fichier de données
Assurez-vous d&#39;avoir un fichier CSV contenant des données de trajet routier préparé
et prêt à être utilisé. Le fichier doit inclure des détails tels que &#39;RouteID&#39;, &#39;StepID&#39;,
&#39;Départs&#39;, &#39;Arrivées&#39;, &#39;Distance&#39; et &#39;Noms des conducteurs&#39;.
Exécution du script
Avant d&#39;exécuter le script, assurez-vous que le script principal a les permissions
nécessaires pour être exécuté :
bashCopy code
chmod +x main.sh
Pour exécuter le programme, utilisez le format de commande suivant dans votre
terminal, en remplaçant [chemin_vers_fichier_csv] par le chemin réel de votre
fichier CSV et [option] par l&#39;option d&#39;opération souhaitée :
bashCopy code
./main.sh [chemin_vers_fichier_csv] [option]
Compréhension des options
L&#39;[option] représente les différentes opérations que vous pouvez effectuer avec le
script. Les options disponibles comprennent :
 -h : Affiche un message d&#39;aide expliquant les options disponibles.
 -d1 : Génère un histogramme des 10 conducteurs ayant effectué le plus de
trajets.
 -d2 : Génère un histogramme des 10 conducteurs ayant effectué les trajets
les plus longs.
 -l : Génère un histogramme des 10 trajets les plus longs.
 -t : Génère un histogramme des 10 villes les plus visitées.
 -s : Génère un graphique à barres avec des statistiques sur la variation des
distances pour chaque trajet.
Consultation des résultats
Après avoir exécuté le script avec l&#39;option choisie, les résultats, tels que les
graphiques, seront générés et généralement enregistrés dans un dossier de sortie
désigné (images). Ces résultats seront également affichés à l&#39;écran pour la
visualisation et l&#39;analyse.

Groupes
Illian
Quentin
Yasmine

8-14 january 2024:
15-21 january 2024:
22-27 january 2024:
29-2 january-febuary 2024:
