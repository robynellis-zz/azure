#!/bin/bash

$RgNAME="sample"
$LOCATION="eastus2"

###Download and install AZ on local linux box from MS repo###
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo sh -c 'echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

sudo yum -y install azure-cli

###test login to azure###
az login
#This will open your default web browser and do an https login.  Needs revision for accepting vars at CLI#

###setup user accounts in default directory###
#use GUI and bulk import the users in appropriate CSV file.  Example in repo.
##later implementation:  use ps script to import users

###grant user accounts owner rights on the main subscription###
##use GUI
##later implementation use powershell to bulk grant permissions

###setup sample resource group in tennancy###
az group create \
  --name $RgNAME 
  --location $LOCATION

###setup main vnet and subnet in tennancy###
az network vnet create \
  --name mainVNET \
  --resource-group $RgName \
  --location $LOCATION \
  --address-prefix 20.0.0.0/16 \
  --subnet-name mainSNET \
  --subnet-prefix 20.0.0.0/25

###setup premium tier storage account###
##Used GUI
##Future implementation:  use az or powershell for this. 

###setup standard tier storage account###
az storage account create \
    --name samplestoragestandard \
    --resource-group $RgNAME \
    --location $LOCATION \
    --sku Standard_RAGRS \
    --kind StorageV2

###configure redhat cloud access for azure subscription###
# az account show and get ID for subscription
# with this value, go to redhat customer portal, and activate license for cloud 
# full instructions @ https://access.redhat.com/documentation/en-us/red_hat_subscription_management/1/html/red_hat_cloud_access_reference_guide/con-program-overview

### ###

###create a linux bastion host using redhat provided gold images###
- give it a public IP
- Create an NSG to allow only 22/tcp from pre-defined IPs
- register and attach it via sunscription-manager
- get and inject other authorized_keys into root account
***setup trackable and loggable accounts using azure AD*****
- wait 20 mins for bastion to be available
- generate new azure SSH Key for bastion host azureuser account; download to local ~/.ssh

###continue onto preq script###





