#!/bin/bash
#Initialisation des variables


tout_arguments=$*  #les arguments que l'utilisateur va insérer
mode_tri="avl"

#awk -F [,;] '{print $1";"$2";"$3";"$4";"$5";"$6";"$7";"$8";"$9";"$10";"$11";"$12";"$13";"$14";"$15}' meteo_filtered_data_v1.csv > meteo.csv#pas sur cest sque imad ma dit de faire mai ca marche pas



#teste pour savoir si les fichiers temporaires existent
if [ -d temp_t ]; then
    echo "Le dossier 'temp_t' existe déjà."
else
    mkdir temp_t
fi
if [ -d temp_p ]; then
    echo "Le dossier 'temp_p' existe déjà."
else
    mkdir temp_p
fi
if [ -d temp_w ]; then
    echo "Le dossier 'temp_w' existe déjà."
else
    mkdir temp_w
fi
#Initialisation des fonctions tests pour chaques arguments et options
test_argument_mode() {
    MODE=$OPTARG #"OPTARG" est une variable spéciale pour stocker la valeur associée à l'ption donnée
    if [[ $MODE -ne 1 && $MODE -ne 2 && $MODE -ne 3 ]]; then
        echo "Les arguments sont compris entre 1 et 3 tout inclus/ Vous n'avez pas mis d'argument/ Arguments invalide" >&2
        exit 1
    fi
}
test_options() {
    if [ -z "$MODE" ]; then #vérifie si la variable MODE est vide
        echo "Il faut au moins mettre 1 option parmis -t[ARGUMENTS] -p[ARGUMENTS] -w -m -h" >&2
        exit 1
    fi
}
#filtrage pour l'option -t
filtrage_1() {
    cut -d ';' -f 11,15 meteo_filtered_data_v1.csv >temp_t/donnee_temperature_num.txt # temperature + code commune
} #les colonnes 11 et 15 extraites sont enregistrées dans un nouveau fichier appelé "donnee_temperature_num.txt" situé dans le répertoire "temp_t".
filtrage_2() {
    cut -d ';' -f 11,2 meteo_filtered_data_v1.csv >temp_t/donnee_temperature_date.txt #temp + date
}
filtrage_3() { #recuperer les donner d'une colonne du tableau.csv
    cut -d ';' -f 11,1 meteo_filtered_data_v1.csv >temp_t/donnee_filtree_temperature_et_id.txt #temp + ID OMM
}
#filtrage pour l'option -p
filtrage_1_bis() {
    cut -d ';' -f 7,15 meteo_filtered_data_v1.csv >temp_p/donnee_pression_num.txt #pression + comme code
}
filtrage_2_bis() {
    cut -d ';' -f 7,2 meteo_filtered_data_v1.csv >temp_p/donnee_pression_date.txt #pression + date
}
filtrage_3_bis() {
    cut -d ';' -f 7,1 meteo_filtered_data_v1.csv >temp_p/donnee_filtree_pression_et_id.txt # pression + ID OMM 
}
#filtrage pour l'option -w
filtrage_w() {
    cut -d ';' -f 1,5 meteo_filtered_data_v1.csv >temp_w/donnee_vent_moyenne.txt
}
#execution des arguments pour option -t
execution_mode_t() {
    if [ "$OPTARG" -eq 1 ]; then
        filtrage_1
    elif [ "$OPTARG" -eq 2 ]; then
        filtrage_2
    elif [ "$OPTARG" -eq 3 ]; then
        filtrage_3
    fi
}
#execution des arguments pour option -p
execution_mode_p() {
    if [ "$OPTARG" -eq 1 ]; then
        filtrage_1_bis
    elif [ "$OPTARG" -eq 2 ]; then
        filtrage_2_bis
    elif [ "$OPTARG" -eq 3 ]; then
        filtrage_3_bis
    fi
}
#attribué a mode_tri le mode de tri utilisé
verification_tri() {
    for mode in $tout_arguments; do
        if [ "$mode" == "tab" ]; then
            mode_tri="tab"
            break
        elif [ "$mode" == "abr" ]; then
            mode_tri="abr"
            break
        elif [ "$mode" == "avl" ]; then
            mode_tri="avl"
            break
        fi
    done
}

#while true; do
# Traitement des options de la ligne de commande avec getopt
while getopts ":t:p:wmhFGSAOQ-:" option; do
    if [ "$option" = "-" ]; then
        case $OPTARG in
            abr) mode_tri="abr" ;;
            tab) mode_tri="tab" ;;
            avl) mode_tri="avl" ;;
            help) cat help.txt;;
        esac
    else
        case "$option" in
        #traitement de la temperature accompagné d'une option 1 ou 2 ou 3

        t)
            test_argument_mode
            execution_mode_t
            test_options
            touch temp_t/donnee_t.gnu
            echo -e 'set datafile separator ";"
plot "temp_t/donnee_temperature_date.txt" using 2:1 with linespoint
set title "La température en fonction de la date"
set sample 50
set style data points
set xlabel "date"
set ylabel "température" >> gnuplot
echo "plot '"$6"' using 1:5:3:4 with yerrorbar" >> gnuplot' > temp_t/donnee_t.gnu
            ;;
        p) #traitement de la pression accompagné d'une option 1 ou 2 ou 3
            test_argument_mode
            execution_mode_p
            test_options
            touch temp_p/donnee_p.gnu
            echo -e 'set datafile separator ";"
plot "temp_p/donnee_pression_date.txt" using 1:2 with linespoint
set title "La pression en fonction de la date"
set sample 50
set style data points
set xlabel "date"
set ylabel "pression" >> gnuplot
echo "plot '"$6"' using 1:5:3:4 with yerrorbar" >> gnuplot' > temp_p/donnee_p.gnu
            ;;
        w) #traitement de l'option vent
            filtrage_w
            touch temp_w/donnee_w.gnu
            echo -e 'set datafile separator ";"
plot "temp_w/donnee_vent_moyenne.txt" using 2:1 with linespoint
set title "Le vent en fonction de la date"
set sample 50
set style data points
set xlabel "date"
set ylabel "Vitesse moyenne du vent" >> gnuplot
echo "plot '"$6"' using 1:5:3:4 with yerrorbar" >> gnuplot' > temp_w/donnee_w.gnu
            ;;
        m)
            echo "humidite"
            ;; #traitement de l'option humidite
        h)
            echo "altitude"
            ;; #traitement de l'option altitude
        F)
            echo "France"
            shift
            ;;
        G)
            echo "Guyane française"
            shift
            ;;
        S)
            echo "Saint-Pierre et Miquelon"
            shift
            ;;
        A)
            echo "Antilles"
            shift
            ;;
        O)
            echo "Océan indien"
            shift
            ;;
        Q)
            echo "Antarctique"
            shift
            ;;
        *)
            echo "option invalide"
            ;;
        --) break;;
        esac
    
    fi
done
shift $((OPTIND - 1))


#verification_tri
echo $mode_tri


if [ -d "$temp_p" ] && [ -z "$(ls -A "$temp_p")" ]
then
       echo "Le dossier est vide"
else
#ici il faut cree les fichier gnuplot
    echo "Creation graphique pression"
    gnuplot temp_p/donnee_p.gnu --persist
fi



if [ -d "$temp_t" ] && [ -z "$(ls -A "$temp_t")" ]
then
       echo "Le dossier est vide"
else
    echo "Creation graphique temperature"
	gnuplot temp_t/donnee_t.gnu --persist
fi



if [ -d "$temp_w" ] && [ -z "$(ls -A "$temp_w")" ]
then
       echo "Le dossier est vide"
else
    echo "Creation graphique vent"
	gnuplot temp_w/donnee_w.gnu --persist
fi
