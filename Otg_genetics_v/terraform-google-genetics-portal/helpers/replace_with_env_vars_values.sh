#!/bin/bash

# Given an environment file that defines values for keys, replace them in the destination file

# Input
envfile=$1
dstfile=$2

echo "[TERRAFORM] Loading environment from '${envfile}'"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    for key in $( cat ${envfile} | awk '{$1=$1};1' | egrep -o "TF_VAR_[_A-Za-z]+" ) ; do
        source ${envfile} ; echo -e "\t[TERRAFORM] Injecting '${key}=${!key}'" ;
        source ${envfile} ; sed -r -i "s/${key}(\W|$)/\"${!key}\"/g" ${dstfile} ;
    done
elif [[ "$OSTYPE" == "darwin"* ]]; then
    for key in $( cat ${envfile} | awk '{$1=$1};1' | egrep -o "TF_VAR_[_A-Za-z]+" ) ; do
        source ${envfile} ; echo -e "\t[TERRAFORM] Injecting '${key}=${!key}'" ;
        source ${envfile} ; sed -E -i ".bak" "s/${key}(\W|$)/\"${!key}\"/g" ${dstfile} ;
    done
    echo "[HOUSEKEEPING] Clean unneeded backup file '${dstfile}"
    rm -f ${dstfile}.bak
else
    echo "Unsupported OS: please use Mac or Linux"
fi
