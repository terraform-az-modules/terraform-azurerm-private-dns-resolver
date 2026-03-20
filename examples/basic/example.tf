provider "azurerm" {
  features {}
}

module "private-dns-resolver" {
  source = "../../"
}
