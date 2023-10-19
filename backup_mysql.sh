#!/bin/bash


#################################################
#						#
#	Script de sauvegarde de base mysql	#
#						#
#################################################################
#								#
#	Codes de sortie du programme				#
#								#
# + Code 0 : Programme exécuté sans rencontrer d'erreur		#
# + Code 1 : Le dump SQL est déjà présent			#
# + Code 2 : Le dump SQL n'a pas pu être effectué		#
# + Code 3 : Le fichier d'intégrité n'a pas pu être créé	#
#								#
#################################################################




	#############
	# Variables #
	#############

#Utilisateur de la base de données
#DATABASE_USER=

#Mot de passe de l'utilisateur de la base de données
#DATABASE_USER_PASSWORD=

#Formatage de la date du jour sous la forme année_mois_jour_heure
DATE_DUMP_SQL=$(date +"%y_%m_%d_%H")

#Chemin du fichier de logs
LOGS_PATH=

#IP distante
IP_BACKUP_SERVER=$1

#Utilisateur du serveur de backup
BACKUP_SERVER_USER=

#Répertoire du serveur distant sous la forme /path/to/repo
BACKUP_SERVER_PATH=





#####################################
# 		Main		    #
#####################################


# Test du fichier sql existant

if [ ! -f $BACKUP_SERVER_PATH/$DATE_DUMP_SQL.sql ]; then 

	#Dump de la base de données à distance
	ssh -t $BACKUP_SERVER_USER@$IP_BACKUP_SERVER sudo mysqldump --all-databases > $BACKUP_SERVER_PATH/$DATE_DUMP_SQL.sql 

		if [ $? == "0" ]; then

			echo "Dump de la BDD : OK" >> $LOGS_PATH

			#Création du checksum du fichier
			sha512sum $DATE_DUMP_SQL.sql > $DATE_DUMP_SQL.sha

			# Test du fichier checksum
			if [$? == "0"]; then

				#Création du dump chiffré des bases SQL
				openssl enc -e -aes-256-cbc -in $BACKUP_SERVER_PATH/$DATE_DUMP_SQL.sql -out $BACKUP_SERVER_PATH/$DATE_DUMP_SQL.chi -pass pass:motdepasse

				#Suppression du dump non chiffré 
				cat /dev/null > $BACKUP_SERVER_PATH/$DATE_DUMP_SQL.sql && rm $BACKUP_SERVER_PATH/$DATE_DUMP_SQL.sql

				#Fin du programme : Correct
				exit 0
			else 

				#Fin du programme : Création du fichier de signature impossible
				echo "Création du fichier de signature impossible"
				exit 3
		else 
			echo "Dump de la BDD : NOK" >> $LOGS_PATHS
			exit 2
	 	fi
else
	echo "Fichier SQL déjà présent dans le répertoire" >> $LOGS_PATHS
		exit 1
fi
