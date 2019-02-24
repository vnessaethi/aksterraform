variable "client_id" {}
variable "client_secret" {}

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
