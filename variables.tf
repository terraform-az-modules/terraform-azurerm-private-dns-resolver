##-----------------------------------------------------------------------------
## Variables
##-----------------------------------------------------------------------------
variable "label_order" {
  type        = list(any)
  default     = ["name", "environment", "location"]
  description = "Label order, e.g. `name`,`application`,`centralus`."
}

variable "custom_name" {
  type        = string
  default     = null
  description = "Override default naming convention"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/terraform-az-modules/terraform-azurerm-private-dns-resolver"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "deployment_mode" {
  type        = string
  default     = "terraform"
  description = "Specifies how the infrastructure/resource is deployed"
}

variable "extra_tags" {
  type        = map(string)
  default     = null
  description = "Variable to pass extra tags."
}

variable "resource_position_prefix" {
  type        = bool
  default     = true
  description = <<EOT
  Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.

  - If true, the keyword is prepended: "vnet-core-dev".
  - If false, the keyword is appended: "core-dev-vnet".

  This helps maintain naming consistency based on organizational preferences.
  EOT
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "virtual_network_id" {
  type        = string
  description = "ID of the Virtual Network where DNS Resolver will be deployed"
}

variable "managedby" {
  type        = string
  default     = "terraform-az-modules"
  description = "ManagedBy, eg 'terraform-az-modules'."
}

variable "name" {
  type        = string
  description = "Name of the Private DNS Resolver"

}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which the resolver will be deployed"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "dns_resolver_inbound_endpoints" {
  type = list(object({
    inbound_endpoint_name = string
    inbound_subnet_id     = string
  }))
  default     = []
  description = "List of inbound endpoints with names and subnet IDs"
}

variable "dns_resolver_outbound_endpoints" {
  type = list(object({
    outbound_endpoint_name = string
    outbound_subnet_id     = string
  }))
  default     = []
  description = "List of outbound endpoints with names and subnet IDs"
}

variable "dns_forwarding_rules" {
  type = list(object({
    name               = string
    domain_name        = string
    target_dns_servers = list(string)
  }))
  default     = []
  description = "Optional DNS forwarding rules"
}
