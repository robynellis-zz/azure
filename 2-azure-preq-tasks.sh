#!/bin/bash


###login to Bastion host using public IP###

######download and install AZ on bastion from MS repo#######
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo sh -c 'echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

sudo yum -y install azure-cli

#######test login to azure using tennant credentials#########
#az login -u $AZ_USER -p $AZ_PASS (NOT WORKING!!!!  FIX THIS)

#######Get Azure Subscription ID and Tennant ID#######
##### Working 2020OCT05

export AZ_SUB_ID=$(az account show | jq ".id" -j)
export AZ_TEN_ID=$(az account show | jq ".tenantId" -j)

#######Create AAD Service Principal, and grant appropriate permissions for user impersonation####
export AZ_SP_NAME=robyntest
export AZ_SP_PASS=$(az ad sp create-for-rbac --role Contributor --name $AZ_SP_NAME | jq ".password" -j)
export AZ_SP_ID=$(az ad sp show --id 'http://$AZ_SP_NAME' | jq ".appId" -j)
export AZ_SP_OBJ=$(az ad sp list --filter "appId eq '$AZ_SP_ID'" | jq '.[0].objectId' -r)
az role assignment create --role "User Access Administrator" --assignee-object-id $AZ_SP_OBJ
az ad app permission grant --id $AZ_SP_ID --api 00000002-0000-0000-c000-000000000000

###create SSH Key on bastion host for OCP core user###

###Curl pull-secret from redhat cloud portal####
$RHC_PULL_SECRET=


#######create dir, create install-config, make backup of install-config########
mkdir ~/openshift-azure
mkdir ~/openshift-azure/backup


