variable "client_id" {}
variable "client_secret" {}

variable log_analytics_workspace_name {
    default = "k8sloganalytics"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "eastus"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerNode"
}

variable "agent_count" {
    default = 3
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8scluster"
}

variable cluster_name {
    default = "k8scluster"
}

variable resource_group_name {
    default = "rgk8scluster"
}

variable location {
    default = "eastus"
}

variable username {
    default = "aksusername"
}
