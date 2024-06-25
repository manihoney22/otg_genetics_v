// --- API Module Output Information --- //
output "deployment_regions" {
  value = var.deployment_regions
}

output "map_region_to_instance_group_manager" {
  value = zipmap(
    var.deployment_regions,
    google_compute_region_instance_group_manager.regmig_api.*
  )
}

output "capacity_scalers" {
  value = zipmap(
    var.deployment_regions,
    google_compute_region_autoscaler.autoscaler_api.*
  )
}

output "api_port" {
  // Output the listening port for the Open Targets Platform API
  value = local.api_port
}

output "api_port_name" {
  // Output the custom named port for the instance group
  value = local.api_port_name
}

output "ilb_ip_addresses" {
  value = try(zipmap(
    var.deployment_regions,
    [ for ilb in module.ilb_api: ilb.ip_address ]
  ), null)
}
