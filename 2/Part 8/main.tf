resource "azurerm_policy_definition" "audit_tagging" {
  name         = "audit_or_deny_tagging"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Check for Required Tag on Resources"
  description  = "Audits or denies resources that are missing a required tag key."


  parameters = jsonencode({
    tagName = {
      type     = "String"
      metadata = { displayName = "Tag Name" }

    }
    effect = {
      type          = "String"
      defaultValue  = "Audit"
      allowedValues = ["Audit", "Deny", "Disabled"]
      metadata      = { displayName = "Effect" }
    }

  })

  policy_rule = jsonencode({
    if = {
      field  = "[concat('tags[', parameters('tagName'), ']')]"
      exists = "false"
    }
    then = {
      effect = "[parameters('effect')]"
    }
  })

}


resource "azurerm_policy_set_definition" "mandatory_tagging_policy" {
  name         = "enforce_mandatory_tagging_policy"
  policy_type  = "Custom"
  display_name = "Enforce Mandatory Tagging Policy"
  description  = "Requires owner, cost-center, project, environment, and tier"

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.audit_tagging.id
    reference_id         = "RequireApplicationTag"
    parameter_values = jsonencode({
      tagName = { value = "Application" }
      effect  = { value = "Audit" }
    })
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.audit_tagging.id
    reference_id         = "RequireCostCenterTag"
    parameter_values = jsonencode({
      tagName = { value = "Cost-Center" }
      effect  = { value = "Audit" }
    })
  }


  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.audit_tagging.id
    reference_id         = "RequireSupportGroupTag"
    parameter_values = jsonencode({
      tagName = { value = "Support-Group" }
      effect  = { value = "Audit" }
    })
  }


  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.audit_tagging.id
    reference_id         = "RequireEnvironmentTag"
    parameter_values = jsonencode({
      tagName = { value = "Environment" }
      effect  = { value = "Audit" }
    })
  }


  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.audit_tagging.id
    reference_id         = "RequireTierTag"
    parameter_values = jsonencode({
      tagName = { value = "Tier" }
      effect  = { value = "Audit" }
    })
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.audit_tagging.id
    reference_id         = "RequireBackupRequiredTag"
    parameter_values = jsonencode({
      tagName = { value = "Backup-Required" }
      effect  = { value = "Audit" }
    })
  }



}

resource "azurerm_subscription_policy_assignment" "enforce_mandatory_tagging_policy" {
  name                 = "subscription_level_mandatory_tagging"
  policy_definition_id = azurerm_policy_set_definition.mandatory_tagging_policy.id
  subscription_id      = data.azurerm_subscription.current.id
  description          = "Enforce Mandatory Tagging Policy"
  display_name         = "Enforce Mandatory Tagging Policy"

  not_scopes = [
    "${data.azurerm_subscription.current.id}/resourceGroups/NetworkWatcherRG",
    "${data.azurerm_subscription.current.id}/resourceGroups/Default-Storage-EastUS"
  ]

  non_compliance_message {
    content                        = "Resource is missing the required tag: 'Application'"
    policy_definition_reference_id = "RequireApplicationTag"
  }

  non_compliance_message {
    content                        = "Resource is missing the required tag: 'Cost-Center'"
    policy_definition_reference_id = "RequireCostCenterTag"
  }

  non_compliance_message {
    content                        = "Resource is missing the required tag: 'Environment' - development, staging, production, qa, training, demo, dr"
    policy_definition_reference_id = "RequireEnvironmentTag"
  }

  non_compliance_message {
    content                        = "Resource is missing the required tag: 'Support-Group'"
    policy_definition_reference_id = "RequireSupportGroupTag"
  }

  non_compliance_message {
    content                        = "Resource is missing the required tag: 'Tier' - 0-4 value"
    policy_definition_reference_id = "RequireTierTag"
  }

  non_compliance_message {
    content                        = "Resource is missing the required tag: 'Backup-Required'"
    policy_definition_reference_id = "RequireBackupRequiredTag"
  }

}

resource "azurerm_resource_group" "rg" {
  name     = "rg-test-storage-account"
  location = "East US"
  tags     = var.mandatory_tags

}

resource "azurerm_storage_account" "test_sa" {
  name                     = "teststorageaccount786129"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.all_storage_tags

  depends_on = [azurerm_subscription_policy_assignment.enforce_mandatory_tagging_policy]




}