## Creating an AKS (Azure Kubernetes Services) using terraform

#### Exemplifying the terraform manifesto:
1. aks.tf: Contains all clustering features in Azure.

2. main.tf: Contains the cloud azure provider and also the terraform backend to store tfstate in an Azure blob storage.

3. variables.tf: Contains all the variables that will be used in aks.tf file.

4. setup.sh: Shell script to make cluster setup easier.

#### What is required to run terraform on the Azure cloud provider:

  For the implementation of terraform for the creation of a cluster of kubernetes as a service in Azure, it is necessary to export the following keys: client_id and secret_id

  To get the client_id and client_secret variables data:

  You can follow this Azure documentation: [Create Service Principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal) I saw it, cli. To do this, it is necessary to have the blue installed:

[Installation of the plugin here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

Main Service Creation:

```shell
    $ az ad sp create-for-rbac --name ServicePrincipalName
```

In the output of the previous command, there will be all the information you need, where appId is the client_id and the password is the client_secret.

1. Export client_id and client_secret:

```shell
    $ export client_id = xxxxxxx
    $ export client_secret = xxxxxx
```

2. Running the script that will generate the aks in Azure:

```shell
    $ chmod + x setup.sh
    $ ./setup.sh
```

3. Wait for the creation of the cluster to finish.