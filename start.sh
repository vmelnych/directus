#!/bin/bash
#maintainer vasyl.melnychuk@accessholding.com

# Error handling
set -o errexit          # Exit on most errors
set -o errtrace         # Make sure any error trap is inherited
set -o pipefail         # Use last non-zero exit code in a pipeline

declare RED='\033[0;31m'
declare BLUE='\033[0;34m'
declare NC='\033[0m'
declare config='.env'

if [ ! -r $config ]; then 
  cp "_env" $config
fi

if [ -r "$config" ]; then
  source $config
fi

if [ -z ${PGADMIN_LOCATION} ] || [ -z ${APP_FOLDER} ]; then
  printf "${RED}Missing PGADMIN_LOCATION and/or APP_FOLDER parameters. Make sure to fix it and try again.${NC}\n"
  exit 1
fi


printf "===============================================================\n"
printf "  APP_FOLDER:        ${BLUE}${APP_FOLDER}${NC}\n"
printf "  PGADMIN_LOCATION:  ${BLUE}${PGADMIN_LOCATION}${NC}\n"
printf "  DB_LOCATION:       ${BLUE}${DB_LOCATION}${NC}\n"
printf "  HOST_UPLOADS:      ${BLUE}${HOST_UPLOADS}${NC}\n"
printf "  ADMIN_LOGIN:       ${BLUE}${ADMIN_EMAIL}${NC}\n"
printf "  ADMIN_PASSWORD:    ${BLUE}${ADMIN_PASSWORD}   ${RED}(remove this line!)${NC}\n"
printf "===============================================================\n"


if [ ! -d ${APP_FOLDER} ]; then
  printf "${BLUE}Creating app folder ${APP_FOLDER}${NC}\n"
  sudo mkdir -p ${APP_FOLDER}
fi

for fl in "start.sh" "stop.sh" "docker-compose.yml" "$config"
do
  printf "Checking file "${APP_FOLDER}/$fl" ...\n"
  if [ ! -r "${APP_FOLDER}/$fl" ]; then 
    printf "Copying file ${BLUE} $fl ${NC}\n"
    sudo cp $fl ${APP_FOLDER}
    if [ ! -r "${APP_FOLDER}/$fl" ]; then
      printf "Missing file ${RED} "${APP_FOLDER}/$fl" ${NC}. Make sure to fix it and try again.\n"
      exit 1
    fi
    if [ $fl = $config ] && [ -f ${APP_FOLDER}/$config ]; then 
      printf "${RED}Edit setting file ${APP_FOLDER}/$config to your preferences and change passwords later!${NC}\n"
    fi
  fi
done

printf "Setting PGAdmin rights...\n"
sudo mkdir -p ${PGADMIN_LOCATION}
sudo chmod 777 ${PGADMIN_LOCATION}

printf "Setting host uploads rights...\n"
sudo mkdir -p ${HOST_UPLOADS}
sudo chmod 777 ${HOST_UPLOADS}

printf "Changing to the app folder ${APP_FOLDER}...\n"
cd ${APP_FOLDER}

printf "Spinning containers...\n"
docker-compose up -d

printf "${BLUE}Waiting for 10 seconds...\n"
sleep 10
xdg-open http://localhost:$DIR_PORT
