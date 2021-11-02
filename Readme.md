# Docker Container for Limesurvey

This is a docker-compose setup to encapsulate all necessary functionality of the limesurvey server into docker containers. There are seperate docker containers for the apache2 webserver, the php-fpm and the mysql database.

## Necessary Configuration

* You should definetly change the database password and username before initiating the limesurvey instance. You can find those entries in the ```.env``` file.

* It might be necessary to change the ports the webserver can use. You can change these in the ```docker-compose.yml``` in the apache block

* You should also adjust the limesurvey.conf file located in the apache folder. This is the apache2 configuration file for the website.

## Installlation

To install and run this container follow these steps:

1. clone this repository
2. run ```install.sh``` to download a Limesurvey instance and setting it up
3. run ```docker-compose up``` to start the limesurvey server
4. after installation you can login via "http://www.example.com/limesurvey/admin". The default admin accounts username is "admin" and its password is "password".

## References

This container is a fork of the webserver created by mzazon (https://github.com/mzazon/php-apache-mysql-containerized).