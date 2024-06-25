// --- DEBUG --- //
output "gcp_available_regions" {
  value = data.google_compute_regions.gcp_available_regions
}
output "gcp_available_zones_per_region" {
  value = local.gcp_available_zones_per_region
}

output "subnet_indexing" {
  value = local.vpc_subnet_index
}

output "subnetting_per_deployment_region" {
  value = local.vpc_network_region_subnet_map
}

// Inspection VMs --- //
output "inspection_vms" {
  value = local.inspection_enabled ? [for vm in google_compute_instance.inspection_vm : {
    project = vm.project
    name    = vm.name
    zone    = vm.zone
    network = [for netiface in vm.network_interface : {
      name       = netiface.name
      network    = netiface.network
      network_ip = netiface.network_ip
    }]
  }] : []
}

// Elastic Search Deployment details --- //
output "elastic_search_deployments" {
  value = zipmap(
    var.config_deployment_regions,
    module.backend_elastic_search
  )
}

// Clickhouse deployment details --- //
output "clickhouse_deployments" {
  value = zipmap(
    var.config_deployment_regions,
    module.backend_clickhouse
  )
}

// API deployment details --- //
output "api_deployments" {
  value = module.backend_api
}

// Web Application Deployment details --- //
output "webapp_deployment" {
  value = module.web_app
}

output "glb" {
  value = module.glb
}

output "dns_records" {
  value = concat(
    [google_dns_record_set.dns_a_api_glb],
    google_dns_record_set.dns_a_webapp_glb
  )
}
