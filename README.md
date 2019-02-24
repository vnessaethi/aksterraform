## Criando um AKS (Azure Kubernetes Services) usando terraform

#### Exemplificando o manifesto terraform:
1. aks.tf: Contém todos os recursos de criação do cluster na Azure.

2. main.tf: Contém o provider da cloud azure e também o backend do terraform para guardar o tfstate em um blob storage da Azure.

3. variables.tf: Contém todas as variavéis que serão usadas no aks.tf.

4. setup.sh: Shell script para facilitar o setup do cluster.

#### O que é necessário para rodar o terraform no cloud provider Azure:

  Para a execução do terraform para a criação de um cluster de kubernetes como serviço na Azure, é necessário exportar as seguintes chaves: client_id e secret_id

  Para conseguir os dados das variáveis client_id e client_secret:

  Você pode seguir essa documentação da Azure: [Criar Service Principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal) ou, fazê-lo via az cli. Para isso, é necessário ter o az cli instalado:

[Instalação do az cli aqui](https://docs.microsoft.com/pt-br/cli/azure/install-azure-cli?view=azure-cli-latest)

Criação do Service Principal:
```shell
$ az ad sp create-for-rbac --name ServicePrincipalName
```
No output do comando anterior, haverá todas as informações que você precisará, sendo que appId é o client_id e o password é o client_secret.

1. Export client_id e client_secret:
    ```shell
    $ export client_id=xxxxxxx
    $ export client_secret=xxxxxx
    ```
2. Execução do script que irá gerar o aks na Azure:
    ```shell
    $ chmod +x setup.sh
    $ ./setup.sh
    ```
3. Aguardar a finalização da criação do cluster.

