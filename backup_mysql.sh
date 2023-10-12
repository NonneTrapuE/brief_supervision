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


#Nom de la base de données à sauvegarder
MYSQL_BDD_NAME=

#Nom de l'utilisateur
MYSQL_USER_NAME=

#Formatage de la date du jour sous la forme année_mois_jour_heure
DATE_DUMP_SQL=$(date +"%y_%m_%d_%H")

#Chemin du fichier de logs
LOGS_PATH=/home/bastien/backup_mysql.log

#IP distante
IP_BACKUP_SERVER=

#Utilisateur du serveur de backup
BACKUP_SERVER_USER=

#Répertoire du serveur distant sous la forme /path/to/repo
BACKUP_SERVER_PATH=





#####################################
# 		Main		    #
#####################################


# Test du fichier sql existant

if [ ! -f $DATE_DUMP_SQL.sql ]; then 
	
	#Dump de la base de données
	MYSQL_PWD="password" mysqldump $MYSQL_BDD_NAME -u $MYSQL_USER_NAME > $DATE_DUMP_SQL.sql 

		if [ $? == "0" ]; then
			echo "====================" >> $LOGS_PATH
			echo "Dump de la BDD : OK" | tee $LOGS_PATH
			echo "====================" >> $LOGS_PATH
		
			# Création du checksum du fichier
			sha512sum $DATE_DUMP_SQL.sql > $DATE_DUMP_SQL.sha
			
			#Transfert des fichiers vers le serveur de backup
			if [ $? == "0"]; then 
				
				scp $DATE_DUMP_SQL.sha $BACKUP_SERVER_USER@$IP_BACKUP_SERVER:$BACKUP_SERVER_PATH
				scp $DATE_DUMP_SQL.sql $BACKUP_SERVER_USER@$IP_BACKUP_SERVER:$BACKUP_SERVER_PATH
			else
				echo "Création du fichier d'intégrité : NOK" >> $LOGS_PATH
				echo "Fin du programme " >> $LOGS_PATH
				exit 3
			fi
			
			#Fin du programme : Correct
			exit 0
		else 
			echo "Dump de la BDD : NOK" >> $LOGS_PATHS
			exit 2
	 	fi
else
	echo "Fichier SQL déjà présent dans le répertoire" >> $LOGS_PATHS
		exit 1
fi
