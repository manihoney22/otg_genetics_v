/// --- Open Targets Genetics Portal Infrastructure      --- //
//  Author: Manuel Bernal Llinares <mbdebian@gmail.com> --- //

// --- Provider Configuration --- //
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.70.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "3.70.0"
    }
  }
}

provider "google" {
  region  = var.config_gcp_default_region
  project = var.config_project_id
  credentials = "./keys.json"
}

provider "google-beta" {
  region  = var.config_gcp_default_region
  project = var.config_project_id
  credentials = "./keys.json"
}

// Availability Regions --- //
data "google_compute_regions" "gcp_available_regions" {
  project = var.config_project_id
}
// Availability Zones --- //
data "google_compute_zones" "gcp_available_zones" {
  count   = length(local.gcp_available_region_names_sorted)
  project = var.config_project_id

  region = local.gcp_available_region_names_sorted[count.index]
}

// [--- Components ---] //
// --- Elastic Search --- //
module "backend_elastic_search" {
  source = "./modules/elasticsearch"
  count  = length(var.config_deployment_regions)

  depends_on = [
    module.vpc_network
  ]
  project_id               = var.config_project_id
  module_wide_prefix_scope = "${var.config_release_name}-es-${local.gcp_regions_static_indexing[var.config_deployment_regions[count.index]]}"
  network_name             = module.vpc_network.network_name
  network_self_link        = module.vpc_network.network_self_link
  network_subnet_name      = local.vpc_network_main_subnet_name
  network_source_ranges = [
    local.vpc_network_region_subnet_map[var.config_deployment_regions[count.index]].subnet_ip
  ]
  // Elastic Search configuration
  vm_elastic_search_version = var.config_vm_elastic_search_version
  vm_elastic_search_vcpus   = var.config_vm_elastic_search_vcpus
  // Memory size in MiB
  vm_elastic_search_mem               = var.config_vm_elastic_search_mem
  vm_elastic_search_image             = var.config_vm_elastic_search_image
  vm_elastic_search_image_project     = var.config_vm_elastic_search_image_project
  vm_elastic_search_boot_disk_size    = var.config_vm_elastic_search_boot_disk_size
  vm_elastic_search_container_project = var.config_vm_elastic_search_container_project
  vm_elastic_search_disk_name         = var.config_vm_elastic_search_disk_name
  vm_elastic_search_disk_project      = var.config_vm_elastic_search_disk_project
  vm_flag_preemptible                 = var.config_vm_elasticsearch_flag_preemptible
  // Additional firewall tags if development mode is 'ON'
  vm_firewall_tags       = local.dev_fw_tags
  deployment_region      = var.config_deployment_regions[count.index]
  deployment_target_size = 1
}

// --- Clickhouse Backend --- //
module "backend_clickhouse" {
  source = "./modules/clickhouse"
  count  = length(var.config_deployment_regions)

  depends_on               = [module.vpc_network]
  module_wide_prefix_scope = "${var.config_release_name}-ch-${local.gcp_regions_static_indexing[var.config_deployment_regions[count.index]]}"
  project_id               = var.config_project_id
  network_name             = module.vpc_network.network_name
  network_self_link        = module.vpc_network.network_self_link
  network_subnet_name      = local.vpc_network_main_subnet_name
  network_source_ranges = [
    local.vpc_network_region_subnet_map[var.config_deployment_regions[count.index]].subnet_ip
  ]
  vm_clickhouse_vcpus             = var.config_vm_clickhouse_vcpus
  vm_clickhouse_mem               = var.config_vm_clickhouse_mem
  vm_clickhouse_image             = var.config_vm_clickhouse_image
  vm_clickhouse_image_project     = var.config_vm_clickhouse_image_project
  vm_clickhouse_container_project = var.config_vm_clickhouse_container_project
  vm_clickhouse_disk_project      = var.config_vm_clickhouse_disk_project
  vm_clickhouse_disk_name         = var.config_vm_clickhouse_disk_name
  vm_clickhouse_boot_disk_size    = var.config_vm_clickhouse_boot_disk_size
  vm_flag_preemptible             = var.config_vm_clickhouse_flag_preemptible
  // Additional firewall tags if development mode is 'ON'
  vm_firewall_tags       = local.dev_fw_tags
  deployment_region      = var.config_deployment_regions[count.index]
  deployment_target_size = 1
}

// --- API --- //
module "backend_api" {
  source     = "./modules/api"
  project_id = var.config_project_id
  depends_on = [
    module.vpc_network,
    module.backend_elastic_search,
    module.backend_clickhouse
  ]
  gcp_available_region_names = local.gcp_available_region_names_sorted
  module_wide_prefix_scope   = "${var.config_release_name}-api"
  network_name               = module.vpc_network.network_name
  network_self_link          = module.vpc_network.network_self_link
  network_subnet_name        = local.vpc_network_main_subnet_name
  network_source_ranges_map = zipmap(
    var.config_deployment_regions,
    [
      for region in var.config_deployment_regions : {
        source_range = local.vpc_network_region_subnet_map[region].subnet_ip
      }
    ]
  )
  // We are using a root module defined GLB, so we need this tag to be appended to api nodes, for them to be visible to the GLB. Include development mode firewall tags
  vm_firewall_tags = concat([local.tag_glb_target_node], local.dev_fw_tags)
  // API VMs configuration
  vm_api_image_version  = var.config_vm_api_image_version
  vm_api_vcpus          = var.config_vm_api_vcpus
  vm_api_mem            = var.config_vm_api_mem
  vm_api_image          = var.config_vm_api_image
  vm_api_image_project  = var.config_vm_api_image_project
  vm_api_boot_disk_size = var.config_vm_api_boot_disk_size
  vm_flag_preemptible   = var.config_vm_api_flag_preemptible
  backend_connection_map = zipmap(
    var.config_deployment_regions,
    [
      for idx, region in var.config_deployment_regions : {
        host_clickhouse     = module.backend_clickhouse[idx].ilb_ip_address
        host_elastic_search = module.backend_elastic_search[idx].ilb_ip_address
      }
    ]
  )
  deployment_regions     = var.config_deployment_regions
  deployment_target_size = 1
  // This can be
  //  INTERNAL   - ILB
  //  NONE      - To not attach a load balancer to the instance groups
  load_balancer_type = "NONE"
  data_major         = var.config_release_year
  data_minor         = var.config_release_month
}

// --- Web Application --- //
module "web_app" {
  source     = "./modules/webapp"
  project_id = var.config_project_id
  depends_on = [
    module.vpc_network
  ]
  gcp_available_region_names = local.gcp_available_region_names_sorted
  module_wide_prefix_scope   = "${var.config_release_name}-web"
  folder_tmp                 = local.folder_tmp
  webapp_bucket_location     = var.config_webapp_bucket_location
  webapp_repo_name           = var.config_webapp_repo_name
  webapp_release             = var.config_webapp_release
  webapp_deployment_context  = var.config_webapp_deployment_context_map
  webapp_robots_profile      = var.config_webapp_robots_profile
  // Web Servers Configuration --- //
  network_name        = module.vpc_network.network_name
  network_self_link   = module.vpc_network.network_self_link
  network_subnet_name = local.vpc_network_main_subnet_name
  network_source_ranges_map = zipmap(
    var.config_deployment_regions,
    [
      for region in var.config_deployment_regions : {
        source_range = local.vpc_network_region_subnet_map[region].subnet_ip
      }
    ]
  )
  //network_sources_health_checks = DEFAULT
  webserver_deployment_regions   = var.config_deployment_regions
  webserver_firewall_tags        = concat([local.tag_glb_target_node], local.dev_fw_tags)
  webserver_docker_image_version = var.config_webapp_webserver_docker_image_version
  webserver_vm_vcpus             = var.config_webapp_webserver_vm_vcpus
  webserver_vm_mem               = var.config_webapp_webserver_vm_mem
  webserver_vm_image             = var.config_webapp_webserver_vm_image
  webserver_vm_image_project     = var.config_webapp_webserver_vm_image_project
  webserver_vm_boot_disk_size    = var.config_webapp_webserver_vm_boot_disk_size
  vm_flag_preemptible            = var.config_vm_webserver_flag_preemptible
  deployment_target_size         = 1
}






