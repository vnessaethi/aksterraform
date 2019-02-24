resource "azurerm_resource_group" "rgk8scluster" {
    name     = "${var.resource_group_name}"
    location = "${var.location}"
    tags {
        Environment = "Development"
        startstopvm = "on"
        Provisioned = "terraform"
    }
}

resource "azurerm_log_analytics_workspace" "k8sloganalytics" {
    name                = "${var.log_analytics_workspace_name}"
    location            = "${var.log_analytics_workspace_location}"
    resource_group_name = "${azurerm_resource_group.rgk8scluster.name}"
    sku                 = "${var.log_analytics_workspace_sku}"
}

resource "azurerm_log_analytics_solution" "k8slogsolution" {
    solution_name         = "ContainerInsights"
    location              = "${azurerm_log_analytics_workspace.k8sloganalytics.location}"
    resource_group_name   = "${azurerm_resource_group.rgk8scluster.name}"
    workspace_resource_id = "${azurerm_log_analytics_workspace.k8sloganalytics.id}"
    workspace_name        = "${azurerm_log_analytics_workspace.k8sloganalytics.name}"

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_kubernetes_cluster" "k8sclusters" {
    name                = "${var.cluster_name}"
    location            = "${azurerm_resource_group.rgk8scluster.location}"
    resource_group_name = "${azurerm_resource_group.rgk8scluster.name}"
    dns_prefix          = "${var.dns_prefix}"
    kubernetes_version  = "1.12.6"

    linux_profile {
        admin_username = "${var.username}"

        ssh_key {
            key_data = "${file("${var.ssh_public_key}")}"
        }
    }

    agent_pool_profile {
        name            = "poolmachine"
        count           = "${var.agent_count}"
        vm_size         = "Standard_B8ms"
        os_type         = "Linux"
        os_disk_size_gb = 30
    }

    service_principal {
        client_id     = "${var.client_id}"
        client_secret = "${var.client_secret}"
    }

    tags {
        Environment = "Development"
        startstopvm = "on"
        Provisioned = "terraform"
    }
}

