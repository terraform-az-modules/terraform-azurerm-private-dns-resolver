provider "azurerm" {
  features {}
}

##-----------------------------------------------------------------------------
## Resource Group
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "terraform-az-modules/resource-group/azurerm"
  version     = "1.0.3"
  name        = "pdr"
  environment = "dev"
  label_order = ["environment", "name", "location"]
  location    = "canadacentral"
}

##-----------------------------------------------------------------------------
## Virtual Network
##-----------------------------------------------------------------------------
module "vnet" {
  depends_on          = [module.resource_group]
  source              = "terraform-az-modules/vnet/azurerm"
  version             = "1.0.3"
  name                = "app"
  environment         = "dev"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

##-----------------------------------------------------------------------------
## Subnets
##-----------------------------------------------------------------------------
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
      name                    = "subnet1"
      subnet_prefixes         = ["10.0.1.0/24"]
      default_outbound_access = true

      delegations = [
        {
          name = "Microsoft.Network/dnsResolvers"

          service_delegations = [
            {
              name = "Microsoft.Network/dnsResolvers"
              actions = [
                "Microsoft.Network/virtualNetworks/subnets/join/action"
              ]
            }
          ]
        }
      ]
    },
    {
      name                    = "subnet2"
      subnet_prefixes         = ["10.0.2.0/24"]
      default_outbound_access = true

      delegations = [
        {
          name = "Microsoft.Network/dnsResolvers"

          service_delegations = [
            {
              name = "Microsoft.Network/dnsResolvers"
              actions = [
                "Microsoft.Network/virtualNetworks/subnets/join/action"
              ]
            }
          ]
        }
      ]
    }
  ]

  route_tables = [
    {
      name                          = "pub"
      bgp_route_propagation_enabled = true
      routes = [
        {
          name           = "rt-test"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      ]
    }
  ]
}

##-----------------------------------------------------------------------------
## Private DNS Resolver Module Call
##-----------------------------------------------------------------------------
module "private_dns_resolver" {
  source              = "../.."
  name                = "app"
  environment         = "dev"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  virtual_network_id  = module.vnet.vnet_id

  dns_resolver_inbound_endpoints = [
    {
      inbound_endpoint_name = "inbound1"
      inbound_subnet_id     = module.subnet.subnet_ids["subnet1"]
    }
  ]

  dns_resolver_outbound_endpoints = [
    {
      outbound_endpoint_name = "outbound1"
      outbound_subnet_id     = module.subnet.subnet_ids["subnet2"]
    }
  ]

  dns_forwarding_rules = [
    {
      name               = "google-dns"
      domain_name        = "google.com."
      target_dns_servers = ["8.8.8.8"]
    }
  ]
}
