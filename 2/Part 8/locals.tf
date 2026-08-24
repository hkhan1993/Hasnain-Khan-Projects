locals {

  storage_specific_tags = {
    data-classification = "confidential"

  }

  all_storage_tags = merge(local.storage_specific_tags, var.mandatory_tags)
}