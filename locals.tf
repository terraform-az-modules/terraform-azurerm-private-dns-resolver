##-----------------------------------------------------------------------------
## Locals (Inbound Only Module)
##-----------------------------------------------------------------------------
locals {
  label_order = var.label_order
  name        = var.custom_name != null ? var.custom_name : module.labels.id
}
