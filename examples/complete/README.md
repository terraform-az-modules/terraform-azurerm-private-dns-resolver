<!-- BEGIN_TF_DOCS -->

# Terraform Azure Private DNS Resolver Module

This directory contains an example usage of the **terraform-azure-private-dns-resolver**. It demonstrates how to use the module with inbound and outbound endpoints along with DNS forwarding rulesets.

---

## 📋 Requirements

| Name      | Version   |
|-----------|-----------|
| Terraform | >= 1.6.6  |
| Azurerm   | >= 3.116.0|

---

## 🔌 Providers

None specified in this example.

---

## 📦 Modules

| Name                    | Source                                      | Version |
|-------------------------|---------------------------------------------|---------|
| resource_group          | terraform-az-modules/resource-group/azurerm | 1.0.3   |
| vnet                    | terraform-az-modules/vnet/azurerm           | 1.0.3   |
| subnet                  | terraform-az-modules/subnet/azurerm         | 1.0.1   |
| dns-private-resolver    | ../..                                       |         |

---

## 🏗️ Resources

No resources are directly created in this example.

---

## 🔧 Inputs

No input variables are defined in this example.

---

## 📤 Outputs

| Name                        | Description                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| dns_resolver_id             | The resource ID of the Azure Private DNS Resolver                           |
| dns_resolver_name           | The name of the Azure Private DNS Resolver                                  |
| dns_inbound_ips             | Map of inbound endpoint keys to their assigned private IP addresses         |
| dns_inbound_endpoint_ids    | Map of inbound endpoint keys to their resource IDs                          |
| dns_inbound_endpoint_names  | Map of inbound endpoint keys to their names                                 |
| dns_outbound_ids            | Map of outbound endpoint keys to their resource IDs                         |
| dns_outbound_endpoint_names | Map of outbound endpoint keys to their names                                |
| dns_forwarding_ruleset_ids  | Map of DNS forwarding ruleset keys to their resource IDs                    |
| dns_forwarding_ruleset_names| Map of DNS forwarding ruleset keys to their names                           |

<!-- END_TF_DOCS -->