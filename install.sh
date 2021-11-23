#!/bin/bash
# terminate on error
# set -e

# include variables from .env
export $(cat .env | grep "^[^#;]" | xargs)

VERSION=3.27.23+211102
LIMESURVEY_FOLDERNAME=`basename ${PROJECT_ROOT}`

download_limesurvey() {
    rm -rf $LIMESURVEY_FOLDERNAME
    echo "downloading limesurvey from $URL..."
    wget -O $LIMESURVEY_FOLDERNAME.zip $URL
    if [ ! -f $LIMESURVEY_FOLDERNAME.zip ] 
    then
        echo "ERROR: The following url does not contain a limesurvey version:
        $URL"
        exit
    fi

    unzip -o $LIMESURVEY_FOLDERNAME.zip
    mv ./LimeSurvey* ./$LIMESURVEY_FOLDERNAME
}

usage="$(basename $0) [-v|-h|-t VERSION]

where: 
    -t [VERSION]    the git version tag of limesurvey to be downloaded. Default: $VERSION
    -h,-help        show this help text"

while getopts 'ht:' option; do
  case "$option" in
    h) echo -e "$usage"
       exit
       ;;
    t) VERSION=${OPTARG}
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo -e "$usage" >&2
       exit 1
       ;;
  esac
done

URL=https://github.com/LimeSurvey/LimeSurvey/archive/${VERSION}.zip
echo $URL
echo $VERSION
# script has to run as root
if [ `whoami` != root ]; then
    echo Please run this script as root or using sudo
    exit
fi


if [ ! -d $LIMESURVEY_FOLDERNAME ] 
then
    download_limesurvey
else
    read -n1 -p "Do you want to override the limesurvey folder with a downloaded version? [y/n]" doit 
    case $doit in  
        y|Y) echo -e "\n"; download_limesurvey ;; 
        *) echo -e "\n" ;; 

    esac
fi

# ownership and rights
echo "Fixxing ownership rights..."
chmod -R 755 $LIMESURVEY_FOLDERNAME
chown -R 82:82 $LIMESURVEY_FOLDERNAME # 82 is id of www-data in httpd container

# setting up database
echo "setting up database settings for the limesurvey instance..."
if [ ! -e $LIMESURVEY_FOLDERNAME/application/config/config.php ]
then
    cp $LIMESURVEY_FOLDERNAME/application/config/config-sample-mysql.php $LIMESURVEY_FOLDERNAME/application/config/config.php
fi

sed -i -e "/'connectionString' =>/ s/=> .*/=> 'mysql:host=mysql;port=${DB_PORT_IN};dbname=${DB_NAME};',/" $LIMESURVEY_FOLDERNAME/application/config/config.php
sed -i -e "/'username' =>/ s/=> .*/=> 'root',/" $LIMESURVEY_FOLDERNAME/application/config/config.php
sed -i -e "/'password' =>/ s/=> .*/=> '${DB_ROOT_PASSWORD}',/" $LIMESURVEY_FOLDERNAME/application/config/config.php
sed -i -e "/'urlFormat' =>/ s/=> .*/=> 'path',/" $LIMESURVEY_FOLDERNAME/application/config/config.php

# installing mysql database

# docker-compose build
# docker-compose up -d
# sleep 5

# docker exec -it limesurvey-php-fpm php /var/www/html/application/commands/console.php ${LIMESURVEY_ADMIN_USER_NAME} ${LIMESURVEY_ADMIN_USER_PASSWORD} ${LIMESURVEY_ADMIN_FULL_NAME} ${LIMESURVEY_ADMIN_EMAIL}

# docker-compose stop

# cleanup
echo "cleanup..."
rm -f $LIMESURVEY_FOLDERNAME.zip