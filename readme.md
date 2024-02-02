Table of Contents

    About the Project
    1. Shell Script and C Program Development
    2. Data Management and Processing
    3. Creating Graphs with Gnuplot
    4. Organization and Storage of Data and Results
    5. Flexibility and Scalability
    6. Technologies Used
    7. Getting Started
    a. Prerequisites
    b. Installation
    Usage
    a. Preparing the Data File
    b. Running the Script
    c. Understanding the Options
    d. Reviewing the Results
    Groups

About the Project
The CY Truck project, led by Eva Ansermin and Romuald Grignon, aims to create a program for managing the logistics of a national road transport company. This project addresses the challenge of manually processing numerous and varied logistics data by automating the analysis of data files and generating graphs summarizing the company's activities.

Shell Script and C Program Development
The project involves developing a Shell script and a C program to analyze the data file and create graphs. The Shell script manages the flow of operations, while the C program focuses on critical tasks in terms of performance.

Data Management and Processing
The program handles a CSV file containing road trip data, including details such as 'RouteID,' 'StepID,' 'Departures,' 'Arrivals,' 'Distance,' and 'Driver Names.'

Creating Graphs with Gnuplot
After data processing, the Shell script uses Gnuplot to create graphs illustrating various aspects of the data, such as drivers who have completed the most trips, the longest distances traveled, the longest trips, and the most traversed cities.

Organization and Storage of Data and Results
Input data, programs, graphs, and intermediate files are organized in specific folders for better management, ensuring clarity and ease of access.

Flexibility and Scalability
The project is designed to be flexible and scalable, allowing for improvements and adaptations to meet specific needs or support future requirements.

Technologies Used : 

    C
    Shell Script
    awk function for Shell

Getting Started
Prerequisites
Make sure you have the following prerequisites installed on your system:

    Gnuplot: Used for generating graphs from data.
    Make: Automation tool for building executable programs and libraries.
    ImageMagick: Software suite for image manipulation.

Installation :

    Clone the repository: https://github.com/Ilianinho/Projet-CY-Truck.git


Navigate to the project directory:

    cd Projet_CY_TRUCK

Usage
Preparing the Data File
Ensure you have a CSV file containing prepared road trip data ready for use. The file should include details such as 'RouteID,' 'StepID,' 'Departures,' 'Arrivals,' 'Distance,' and 'Driver Names.'

Running the Script
Before executing the script, ensure that the main script has the necessary permissions to be executed:

    chmod +x Truck.sh

To run the program, use the following command format in your terminal, replacing [path_to_csv_file] with the actual path to your CSV file and [option] with the desired operation option:

    ./Truck.sh [path_to_csv_file] [option_1] [option_2] ...

Understanding the Options
The [option] represents the different operations you can perform with the script. Available options include:

    -h: Displays a help message explaining the available options.
    d1: Generates a histogram of the top 10 drivers with the most trips.
    d2: Generates a histogram of the top 10 drivers with the longest trips.
    l: Generates a histogram of the top 10 longest trips.
    t: Generates a histogram of the top 10 most visited cities.
    s: Generates a bar chart with statistics on the distance variation for each trip.

Reviewing the Results
After running the script with the chosen option, the results, such as graphs, will be generated and typically saved in a designated output folder (images). These results will also be displayed on the screen for viewing and analysis.

Groups

    Ilian Mestari
    Quentin besognet
    Yasmine moutaouafiq
    

Date of project

   - 01/01/2024: Started the shell file  
   - 10/01/2024: Started  and finish the data gathering for d1, l , d2 . Started the C file 
   - 15/01/2024: Finished -l  Started first_s 
   - 18/01/2024: Finished graph for s 
   - 18/01/2024: Corrected -s 
   - 19/01/2024: Started Trie_s with the avl 
   - 20/01/2024: Tried to fix another seg fault with the avl
   - 21/01/2024: Continue Shell and finish Trie_s
   - 22/01/2024: Continue Shell and Trie_t
   - 24/01/2024: Update function of runScript and check 
   - 26/01/2024: Fixed Trie_s and Trie_t 
   - 27/01/2024: Fixed t gnuplot and all gnuplot 
   - 28/01/2024: Tried to fix t and s problem
   - 29/01/2024: Tried to fix t and makefile problem
   - 30/01/2024: Fixed t and optimization
   - 01/02/2024: Fixed s and optimization
   - 02/02/2024: Add options for the shell (help better, log, verif...) Add README and PDF

