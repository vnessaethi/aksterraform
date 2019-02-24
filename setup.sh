#!/bin/bash -x

# Terraform, azure cli e aks

#brew install terraform && brew update && brew install azure-cli

# Para rodar esse script, é necessário exportar as seguintes variáveis:
# export client_id=app_id_do_application_no_AD
# export client_secret=app_secret_do_application_no_AD

# Create ssh keys
echo -ne '\n' | ssh-keygen

# Criar storage account para guardar o arquivo tfstate do terraform
resourceGroup="rgtfstate"
region="eastus"
storagename="sttfstate"
sku="Standard_GRS"

RGACCOUNT=$(az group exists -n $resourceGroup)
if [ $RGACCOUNT == "true" ]; then
    printf "\\nO resource group especificado já existe\\n";
else
    az group create --name "$resourceGroup" --location "$region"
fi

STACCOUNT=$(az storage account list -g "$resourceGroup" | jq -r '.[].name')
if [ $STACCOUNT == $storagename ]; then
    printf "\\nO storage account especificado já existe\\n";
else
    az storage account create --location "$region" --name "$storagename" --resource-group "$resourceGroup" --sku "$sku"
fi

# Após criado o storage account, serão geradas duas chaves de acesso: key1 e key2, que poderão ser obtidas através do comando abaixo:
keyvalue=$(az storage account keys list -g "$resourceGroup" -n "$storagename" | grep -m1 value | awk '{print $2}')
echo "$keyvalue"

# As chaves geradas através do comando anterior, serão usadas para criar o container onde ficará o arquivo tfstate do terraform:
az storage container create -n tfstate --account-name "$storagename" --account-key "$keyvalue"

#Se todos os passos anteriores tiverem ocorrido com sucesso, podemos criar o cluster usando o terraform:
TF_LOG=DEBUG terraform init -backend-config="storage_account_name=$storagename" -backend-config="container_name=tfstate" -backend-config="access_key=$keyvalue" -backend-config="key=aks.tfstate" 

#Criar o plano terraform com o comando terraform plan para definir os elementos da infraestrutura, onde var.client_id é o appId e var.client_secret é a chave de acesso:
TF_LOG=DEBUG terraform plan -out aks.plan -var client_id=$client_id -var client_secret=$client_secret

#Criar o cluster kubernetes usando o comando terraform apply:
TF_LOG=DEBUG terraform apply aks.plan

#Para gerenciar o cluster pela UI do kubernetes:
#az aks browse --resource-group rgk8spoc --name k8spoc