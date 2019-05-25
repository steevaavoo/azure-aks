# Build and deploy to Azure Kubernetes Service
# https://docs.microsoft.com/en-us/azure/devops/pipelines/languages/aks-template?view=azure-devops

# Open https://shell.azure.com/ and choose a BASH shell
# Copy/paste commands below

# Vars
# no dashes or spaces allowed in prefix, and MUST be lowercase as some character restrictions for some resources
UNIQUE_PREFIX="adamrushuk"
# Shouldn't need to change anything below
AKS_CLUSTER_NAME="${UNIQUE_PREFIX}-aks-cluster01"
ACR_NAME="${UNIQUE_PREFIX}acr01"
AKS_RESOURCE_GROUP="akspipeline"
LOCATION="eastus"
VERSION=$(az aks get-versions -l $LOCATION --query 'orchestrators[-1].orchestratorVersion' -o tsv)
SQL_SERVER_NAME="${UNIQUE_PREFIX}azsqlserver01"

# Create a Resource Group
az group create --name $AKS_RESOURCE_GROUP --location $LOCATION

# Deploy Azure Container Registry (ACR)
az acr create --resource-group $AKS_RESOURCE_GROUP --name $ACR_NAME --sku Basic

# Create AKS using the latest version available
# AKS cluster name MUST be unique, eg: matthorgan-aks-cluster01
az aks create --resource-group $AKS_RESOURCE_GROUP --name $AKS_CLUSTER_NAME --enable-addons monitoring --generate-ssh-keys --node-count 1


# Cleanup
# TODO: work out how to dynamically build Resource Group names
az group delete --name $AKS_RESOURCE_GROUP
az group delete --name akshandsonlab
az group delete --name MC_akshandsonlab_adamrushuk-aks-cluster01_eastus
az group delete --name DefaultResourceGroup-EUS
az group delete --name NetworkWatcherRG
