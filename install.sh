#!/bin/bash

URL=https://download.limesurvey.org/lts-releases/limesurvey3.27.23+211102.zip
LIMESURVEY_FOLDERNAME=limesurvey


download_limesurvey() {
    rm -rf $LIMESURVEY_FOLDERNAME
    echo "downloading limesurvey from $URL..."
    wget -O $LIMESURVEY_FOLDERNAME.zip $URL
    unzip -o $LIMESURVEY_FOLDERNAME.zip
}

usage="$(basename $0) [-h|-help] [URL]

where: 
    URL         the url where the limesurvey instance is downloaded from. If none specified, then version 3.27.23-lts is downloaded.
    -h,-help    show this help text"

while getopts ':hs:' option; do
  case "$option" in
    h|help) echo -e "$usage"
       exit
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo -e "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo -e "$usage" >&2
       exit 1
       ;;
  esac
done


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

# cleanup
echo "cleanup..."
rm -f $LIMESURVEY_FOLDERNAME.zip