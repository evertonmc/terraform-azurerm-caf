module "domain_name_registrations" {
  source   = "./modules/networking/domain_name_registrations"
  for_each = try(local.networking.domain_name_registrations, {})

  base_tags           = try(local.global_settings.inherit_tags, false) ? local.resource_groups[each.value.resource_group_key].tags : {}
  dns_zone_id         = try(each.value.dns_zone.lz_key, null) == null ? local.combined_objects_dns_zones[local.client_config.landingzone_key][each.value.dns_zone.key].id : local.combined_objects_dns_zones[each.value.dns_zone.lz_key][each.value.dns_zone.key].id
  name                = try(each.value.name, "") == "" ? try(local.combined_objects_dns_zones[local.client_config.landingzone_key][each.value.dns_zone.key].name, local.combined_objects_dns_zones[each.value.dns_zone.lz_key][each.value.dns_zone.key].name) : ""
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(local.client_config.landingzone_key, each.value.resource_group.lz_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  settings            = each.value
}

output "domain_name_registrations" {
  value = module.domain_name_registrations
}

