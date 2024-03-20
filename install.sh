#!/bin/bash

cd ./software_package
rpm -i ./* --force --nodeps > /dev/null 2>&1

echo -e "\e[32m"installation is complete!" \e[0m"
