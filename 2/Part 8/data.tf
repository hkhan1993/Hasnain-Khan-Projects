data "azurerm_policy_definition" "require_tag" {

  display_name = "Require a tag on resources"

}

data "azurerm_subscription" "current" {}