##-----------------------------------------------------------------------------
# Global
##-----------------------------------------------------------------------------

variable "enabled" {
  type        = bool
  default     = true
  description = "Enable or disable creation of all Private DNS Resolver"
}

variable "name" {
  type        = string
  description = "Base name for resources."
}

variable "custom_name" {
  type        = string
  default     = null
  description = "Optional custom name to override the base name in tags."
}

variable "location" {
  type        = string
  default     = null
  description = "Azure region where resources will be deployed."
}

variable "environment" {
  type        = string
  default     = null
  description = "Deployment environment (e.g., dev, stage, prod)."
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "Name of the resource group where resources will be deployed."
}

variable "managedby" {
  type        = string
  default     = "terraform"
  description = "Tag to indicate the tool or team managing the resources."
}

variable "repository" {
  type        = string
  default     = "https://github.com/terraform-az-modules/terraform-azurerm-private-dns-resolver.git"
  description = "Repository URL or identifier for traceability."
}

variable "deployment_mode" {
  type        = string
  default     = "terraform"
  description = "Deployment mode identifier (e.g., blue/green, canary)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment", "location"]
  description = "Order of labels to be used in naming/tagging."
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to all resources."
}

variable "resource_position_prefix" {
  type        = bool
  default     = false
  description = "If true, prefixes resource names instead of suffixing."
}

##-----------------------------------------------------------------------------
# Inbound Endpoint
##-----------------------------------------------------------------------------

variable "inbound_endpoint_map" {
  type = map(object({
    inbound_endpoint_name        = string
    private_ip_allocation_method = string
    private_ip_address           = optional(string)
    inbound_subnet_id            = string
  }))
  default     = {}
  description = "Map of inbound DNS resolver endpoints to create. Each key is a unique identifier for the endpoint."
}

##-----------------------------------------------------------------------------
# Outbound Endpoint
##-----------------------------------------------------------------------------

variable "outbound_endpoint_map" {
  type = map(object({
    outbound_endpoint_name = string
    outbound_subnet_id     = string
  }))
  default     = {}
  description = "Map of outbound DNS resolver endpoints to create. Each key is a unique identifier for the endpoint."
}

##-----------------------------------------------------------------------------
# Forwarding Ruleset 
##-----------------------------------------------------------------------------

variable "outbound_endpoint_forwarding_rule_sets" {
  type = list(object({
    outbound_endpoint_key   = string
    forwarding_ruleset_name = string
  }))
  default     = []
  description = "List of DNS forwarding rulesets to associate with outbound endpoints. Each entry requires the outbound endpoint name, ruleset name, and outbound endpoint resource ID."
}

variable "virtual_network_id" {
  type        = string
  default     = null
  description = "The ID of the Virtual Network where this Private DNS Resolver should be located in."
}