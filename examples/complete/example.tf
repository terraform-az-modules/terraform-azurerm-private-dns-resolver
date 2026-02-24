provider "azurerm" {
  features {}
}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "terraform-az-modules/resource-group/azurerm"
  version     = "1.0.3"
  name        = "core"
  environment = "dev"
  location    = "centralus"
  label_order = ["name", "environment", "location"]
}

# ------------------------------------------------------------------------------
# Virtual Network
# ------------------------------------------------------------------------------
module "vnet" {
  source              = "terraform-az-modules/vnet/azurerm"
  version             = "1.0.3"
  name                = "core"
  environment         = "dev"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

# ------------------------------------------------------------------------------
# Subnet
# ------------------------------------------------------------------------------
module "subnet" {
  source               = "terraform-az-modules/subnet/azurerm"
  version              = "1.0.1"
  environment          = "dev"
  label_order          = ["name", "environment", "location"]
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  enable_route_table   = true
  subnets = [
    {
      name             = "subnet1"
      subnet_prefixes  = ["10.0.1.0/24"]
      route_table_name = "rt1"
      delegations = [
        {
          name = "delegation1"
          service_delegations = [
            {
              name    = "Microsoft.Network/dnsResolvers"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      ]
    },
    {
      name             = "subnet2"
      subnet_prefixes  = ["10.0.2.0/24"]
      route_table_name = "rt2"
      delegations = [
        {
          name = "delegation1"
          service_delegations = [
            {
              name    = "Microsoft.Network/dnsResolvers"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      ]
    },
    {
      name             = "pvt-dns-outbound-subnet"
      subnet_prefixes  = ["10.0.3.0/28"]
      route_table_name = "rt3"
      delegations = [
        {
          name = "delegation1"
          service_delegations = [
            {
              name    = "Microsoft.Network/dnsResolvers"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      ]
    },
    {
      name             = "pvt-dns-outbound-subnet-2"
      subnet_prefixes  = ["10.0.4.0/28"]
      route_table_name = "rt4"
      delegations = [
        {
          name = "delegation1"
          service_delegations = [
            {
              name    = "Microsoft.Network/dnsResolvers"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      ]
    }
  ]
  route_tables = [
    {
      name                          = "rt1"
      bgp_route_propagation_enabled = false
      routes = [
        {
          name           = "internet"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      ]
    },
    {
      name                          = "rt2"
      bgp_route_propagation_enabled = false
      routes = [
        {
          name           = "internet"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      ]
    },
    {
      name                          = "rt3"
      bgp_route_propagation_enabled = false
      routes = [
        {
          name           = "internet"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      ]
    },
    {
      name                          = "rt4"
      bgp_route_propagation_enabled = false
      routes = [
        {
          name           = "internet"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      ]
    }
  ]
}

# ------------------------------------------------------------------------------
# Private DNS Resolver
# ------------------------------------------------------------------------------
module "dns-private-resolver" {
  source              = "../.."
  name                = "core"
  environment         = "dev"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  virtual_network_id  = module.vnet.vnet_id
  inbound_endpoint_map = {
    inbound1 = {
      inbound_endpoint_name        = "inbound-01"
      inbound_subnet_id            = module.subnet.subnet_ids["subnet1"]
      private_ip_allocation_method = "Dynamic"
    }
    inbound2 = {
      inbound_endpoint_name        = "inbound-02"
      inbound_subnet_id            = module.subnet.subnet_ids["subnet2"]
      private_ip_allocation_method = "Dynamic"
    }
  }
  outbound_endpoint_map = {
    outbound1 = {
      outbound_endpoint_name = "outbound-01"
      outbound_subnet_id     = module.subnet.subnet_ids["pvt-dns-outbound-subnet"]
    }
    outbound2 = {
      outbound_endpoint_name = "outbound-02"
      outbound_subnet_id     = module.subnet.subnet_ids["pvt-dns-outbound-subnet-2"]
    }
  }
  outbound_endpoint_forwarding_rule_sets = [
    {
      outbound_endpoint_name  = "outbound-01"
      forwarding_ruleset_name = "frs-outbound-01"
      outbound_endpoint_id    = module.dns-private-resolver.outbound_endpoint_ids["outbound1"]
    },
    {
      outbound_endpoint_name  = "outbound-02"
      forwarding_ruleset_name = "frs-outbound-02"
      outbound_endpoint_id    = module.dns-private-resolver.outbound_endpoint_ids["outbound2"]
    }
  ]
}