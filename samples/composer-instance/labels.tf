module "labels_composer_instance" {
  source = "./modules/labels/"

  labels       = local.common_labels
  extra_labels = local.extra_labels
}

# Labels
locals {
  common_labels = {
    product      = "bigdata"
    application  = "composer"
    environment  = var.environment
  }

  cmdb_suffix = var.environment == "develop" ? "d" : var.environment == "staging" ? "h" : var.environment == "production" ? "p" : "s"

  extra_labels = {
    inventory_id = "bigdata-data-composer-orchestrator-${local.cmdb_suffix}"
  }
}
