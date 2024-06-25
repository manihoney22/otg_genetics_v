// --- Helper Information --- //
locals {
  // Helpers --- //
  gcp_available_region_names_sorted = sort(keys(var.config_gcp_availability_regions_indexing))
  gcp_available_zones_per_region = zipmap(
    local.gcp_available_region_names_sorted,
    [for region_details in data.google_compute_zones.gcp_available_zones : region_details.names]
  )
  gcp_regions_static_indexing = var.config_gcp_availability_regions_indexing

  // Folders --- //
  #folder_tmp = "/mnt/c/Users/manikantan.arcot/Desktop/Otg_genetics_v"
  #folder_tmp = "C:\\Users\\manikantan.arcot\\Desktop\\tmp_folder"
  folder_tmp = "/mnt/c/Users/manikantan.arcot/Desktop/Otg_genetics_v/terraform-google-genetics-portal"
  #folder_tmp = "C:\\Users\\manikantan.arcot\\Desktop\\Otg_genetics_v"
  #folder_tmp = abspath("${path.module}/tmp")

  // --- DNS --- //
  // The effective DNS name is the one taking into account a possible subdomain that should scope the deployment
  dns_effective_dns_name = (var.config_dns_subdomain_prefix == null ? var.config_dns_managed_zone_dns_name : "${var.config_dns_subdomain_prefix}.${var.config_dns_managed_zone_dns_name}")
  dns_base_name          = "${var.config_dns_base_subdomain}.${local.dns_effective_dns_name}"
  dns_api_dns_name       = "${var.config_dns_api_subdomain}.${local.dns_base_name}"
  dns_webapp_domain_names = [
    "www.${local.dns_base_name}",
    local.dns_base_name
  ]

  // Networking --- // 
  vpc_network_name             = "${var.config_release_name}-vpc"
  vpc_network_main_subnet_name = "main-subnet"
  vpc_network_region_subnet_map = zipmap(
    var.config_deployment_regions,
    [
      for region in var.config_deployment_regions : {
        subnet_name   = local.vpc_network_main_subnet_name
        subnet_region = region
        subnet_ip     = "10.${local.vpc_subnet_index[region]}.0.0/20"
      }
    ]
  )

  vpc_subnet_index = local.gcp_regions_static_indexing

  // Firewall --- //
  // Target Tags
  fw_tag_ssh   = "ssh"
  fw_tag_http  = "http"
  fw_tag_https = "https"

  // --- Global Load Balancer --- //
  // GLB tagging for traffic destination --- //
  tag_glb_target_node         = "glb-serve-target"
  glb_dns_api_dns_names       = [trimsuffix(local.dns_api_dns_name, ".")]
  glb_dns_webapp_domain_names = [for hostname in local.dns_webapp_domain_names : trimsuffix(hostname, ".")]

  // SSL --- //
  ssl_managed_certificate_domain_names = concat(local.dns_webapp_domain_names, [local.dns_api_dns_name])

  // --- Development / Debugging Support --- //
  inspection_enabled                = var.config_enable_inspection
  inspection_conditional_deployment = local.inspection_enabled ? 1 : 0
  dev_ssh_enabled                   = var.config_enable_ssh
  // Dev tags
  dev_fw_tags = local.dev_ssh_enabled ? [local.fw_tag_ssh] : []
}