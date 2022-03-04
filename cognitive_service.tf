module "cognitive_services_account" {
  source   = "./modules/cognitive_services/cognitive_services_account"
  for_each = local.cognitive_services.cognitive_services_account

  client_config       = local.client_config
  global_settings     = local.global_settings
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(local.client_config.landingzone_key, each.value.resource_group.lz_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(local.client_config.landingzone_key, each.value.resource_group.lz_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  settings            = each.value
}

output "cognitive_services_account" {
  value = module.cognitive_services_account
}
