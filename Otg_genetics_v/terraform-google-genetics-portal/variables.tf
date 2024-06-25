// Open Targets Genetics Portal Deployment Input Parameters //
// --- Underlying GCP infrastructure --- //
variable "config_gcp_availability_regions_indexing" {
  description = "This parameters contains a static subindexing for supported availability regions, because sometimes, google API returns less regions than the really available ones, and it messes things up"
  type        = map(any)
  default = {
    "asia-east1"              = 0
    "asia-east2"              = 1
    "asia-northeast1"         = 2
    "asia-northeast2"         = 3
    "asia-northeast3"         = 4
    "asia-south1"             = 5
    "asia-southeast1"         = 6
    "asia-southeast2"         = 7
    "australia-southeast1"    = 8
    "europe-central2"         = 9
    "europe-north1"           = 10
    "europe-west1"            = 11
    "europe-west2"            = 12
    "europe-west3"            = 13
    "europe-west4"            = 14
    "europe-west6"            = 15
    "northamerica-northeast1" = 16
    "southamerica-east1"      = 17
    "us-central1"             = 18
    "us-east1"                = 19
    "us-east4"                = 20
    "us-west1"                = 21
    "us-west2"                = 22
    "us-west3"                = 23
    "us-west4"                = 24
  }
}

// --- RELEASE INFORMATION --- //
variable "config_release_name" {
  description = "Deployment name used for scoping of resources created. It should have a useful meaning for easy spotting of resources in the GCP Project."
  type        = string
  default     = "production"
}

variable "config_release_year" {
  description = "Release year"
  type        = string
  default     = "2024"
}
variable "config_release_month" {
  description = "Release month"
  type        = string
  default     = "March"
}
// --- DEPLOYMENT CONFIGURATION --- //
variable "config_gcp_default_region" {
  description = "Default deployment region to use when not specified"
  type        = string
  default     = "us-east1"
}

variable "config_gcp_default_zone" {
  description = "Default zone to use when not specified"
  type        = string
  default     = "us-east1"
}

variable "config_project_id" {
  description = "Default project to use when not specified"
  type        = string
  default     = "excelra-rnd-gsk-otg-2024"
}

variable "config_deployment_regions" {
  description = "A list of regions where to deploy the OT Platform"
  type        = list(string)
  default     = ["us-east1"]
}

// --- Platform Configuration --- //
// --- DNS configuration               --- //
// --- DNS Configuration --- //
variable "config_dns_project_id" {
  description = "Project ID to use when making changes to Cloud DNS service"
  type        = string
  default     = "excelra-rnd-gsk-otg-2024"
}

variable "config_dns_managed_zone_name" {
  description = "Name of the Cloud DNS managed zone to use for DNS changes"
  type        = string
  default     = "opentargets-org"
}

variable "config_dns_managed_zone_dns_name" {
  description = "Domain name that is being managed in the given managed DNS zone, a.k.a. Cloud DNS -> Managed Zone -> DNS Name"
  type        = string
  default     = "opentargets.org."
}

variable "config_dns_subdomain_prefix" {
  description = "DNS subdomain prefix to use for anything this deployment definition adds to the DNS information"
  default     = null
}

variable "config_dns_api_subdomain" {
  description = "Subdomain for API DNS entry, default 'api'"
  type        = string
  default     = "api"
}

variable "config_dns_base_subdomain" {
  description = "Subdomain for Open Targets Genetics Portal Web App, default 'genetics'"
  type        = string
  default     = "api"
}

// --- Elastic Search configuration    --- //
variable "config_vm_elastic_search_image_project" {
  description = "GCP project hosting the Elastic Search Image."
  type        = string
  default     = "open-targets-genetics-dev"
}

variable "config_vm_elastic_search_vcpus" {
  description = "CPU count configuration for the deployed Elastic Search Instances"
  type        = number
  default     = 2
}

variable "config_vm_elastic_search_mem" {
  description = "RAM configuration for the deployed Elastic Search Instances"
  type        = number
  default     = 13000
}

variable "config_vm_elastic_search_image" {
  description = "Disk image to use for the deployed Elastic Search Instances"
  type        = string
  default     = "cos-stable"
}

variable "config_vm_elastic_search_version" {
  description = "Elastic search version to deploy"
  type        = string
  default     = "7.9.0"
}

variable "config_vm_elastic_search_boot_disk_size" {
  description = "Boot disk size to use for the deployed Elastic Search Instances"
  type        = string
  default     = "100000"
}
// --- Clickhouse configuration        --- //
variable "config_vm_clickhouse_vcpus" {
  description = "CPU count for Clickhouse instances"
  type        = number
  default     = 2
}

variable "config_vm_clickhouse_mem" {
  description = "Amount of memory allocated for Clickhouse instances"
  type        = number
  default     = 100000
}

variable "config_vm_clickhouse_image" {
  description = "Image to use for launching Clickhouse instances"
  type        = string
  default     = "clickhouse-server"
}

variable "config_vm_clickhouse_container_project" {
  description = "Project hosting container optimised machine images to deploy"
  type        = string
  default     = "gcr.io/excelra-rnd-gsk-otg-2024/clickhouse/clickhouse-server:v1"
}

variable "config_vm_clickhouse_disk_project" {
  description = "Project hosting disk snapshots to deploy"
  type        = string
  default     = "excelra-rnd-gsk-otg-2024"
}

variable "config_vm_elastic_search_container_project" {
  description = "Project hosting container optimised machine images to deploy"
  type        = string
  default     = "cos-cloud"
}

variable "config_vm_clickhouse_disk_name" {
  description = "Disk snapshot for Clickhouse data."
  type        = string
  default     = "clickhouse-instance"
}
variable "config_vm_elastic_search_disk_project" {
  description = "Project hosting disk snapshots to deploy"
  type        = string
  default     = "open-targets-genetics-dev"
}

variable "config_vm_elastic_search_disk_name" {
  description = "Disk snapshot for elastic_search data."
  type        = string
  default     = "es-disk-30eqaqyw-image"
}

/*variable "config_vm_elastic_search_image" {
  description = "Image to use for launching Clickhouse instances"
  type        = string
  default     = "cos-stable"
}*/
variable "config_vm_clickhouse_image_project" {
  description = "Project where to find the instance image to use"
  type        = string
  default     = "excelra-rnd-gsk-otg-2024"
}

variable "config_vm_clickhouse_boot_disk_size" {
  description = "Boot disk size to be used in Clickhouse instances"
  type        = string
  default     = "100000"
}

// --- API configuration               --- //
variable "config_vm_api_image_version" {
  description = "API docker image version to use"
  type        = string
  default     = "21.06.0"
}
variable "config_vm_api_vcpus" {
  description = "CPU count for API nodes"
  type        = number
  default     = 1
}
variable "config_vm_api_mem" {
  description = "Memory allocation for API VMs (MiB)"
  type        = number
  default     = 13000
}
variable "config_vm_api_image" {
  description = "VM image to use for running API nodes"
  type        = string
  default     = "cos-stable"
}
variable "config_vm_api_image_project" {
  description = "Project hosting the API VM image"
  type        = string
  default     = "cos-cloud"
}
variable "config_vm_api_boot_disk_size" {
  description = "Boot disk size for API VM nodes"
  type        = string
}

// --- Web Application configuration   --- //
variable "config_webapp_repo_name" {
  description = "Web Application repository name"
  type        = string
  default     = "opentargets/genetics-app"
}

variable "config_webapp_release" {
  description = "Release version of the web application to deploy"
  type        = string
  default     = "21.06.2"
}

variable "config_webapp_deployment_context_map" {
  description = "A map with values for those parameters that need to be customized in the deployment of the web application, see module defaults as an example"
  type        = any
  default     = {
"DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_API_URL"="'https://api.genetics.opentargets.org/graphql'",
"DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_GOOGLE_TAG_MANAGER_ID"="'GTM-PNQWZ2V'"
}
  #default     = {"\"DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_API_URL\"=\"'https://api.genetics.opentargets.org/graphql'\",\"DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_GOOGLE_TAG_MANAGER_ID\"=\"'GTM-PNQWZ2V'\""}
  #default     = "{DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_API_URL = 'https://api.genetics.opentargets.org/graphql', DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_GOOGLE_TAG_MANAGER_ID = 'GTM-PNQWZ2V' }"
}
/*variable "config_webapp_deployment_context_map" {
  description = "A map with values for those parameters that need to be customized in the deployment of the web application, see module defaults as an example"
  type        = string
  default     = " \"{
 
  DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_API_URL = "'https://api.genetics.opentargets.org/graphql'"
 
  DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_GOOGLE_TAG_MANAGER_ID = "'GTM-PNQWZ2V'" \
 
}\" "*/

variable "config_webapp_bucket_location" {
  description = "This input parameter defines the location of the Web Application (bucket), default 'EU'"
  type        = string
  default     = "EU"
}

variable "config_webapp_robots_profile" {
  description = "This input parameter defines the 'robots.txt' profile to be used when deploying the web application, default 'default', which means that no changes to existing 'robots.txt' file will be made"
  type        = string
  default     = "default"
}

// Web Application Web Servers --- //
variable "config_webapp_webserver_docker_image_version" {
  description = "NginX Docker image version to use in deployment"
  type        = string
  default     = "1.21.3"
}

variable "config_webapp_webserver_vm_vcpus" {
  description = "CPU count, default '1'"
  type        = number
  default     = 1
}

variable "config_webapp_webserver_vm_mem" {
  description = "Amount of memory allocated Web Server nodes (MiB), default '13000'"
  type        = number
  default     = 13000
}

variable "config_webapp_webserver_vm_image" {
  description = "VM image to use for Web Server nodes, default 'cos-stable'"
  type        = string
  default     = "cos-stable"
}

variable "config_webapp_webserver_vm_image_project" {
  description = "Project hosting the VM image, default 'cos-cloud'"
  type        = string
  default     = "cos-cloud"
}

variable "config_webapp_webserver_vm_boot_disk_size" {
  description = "Boot disk size for Web Server nodes, default '100000'"
  type        = string
  default     = "100000"
}

// --- Development / Debugging Support --- //
variable "config_enable_inspection" {
  description = "If 'true', it will deploy additional VMs for infrastructure inspection, default 'false'"
  default     = false
}

variable "config_enable_ssh" {
  description = "if 'true' it will enable SSH traffic to all the deployed VMs, default 'false'"
  default     = false
}

// Inspection VM config --- //
variable "config_inspection_vm_machine_type" {
  description = "Machine type to use for inspection VM instances, default 'n1-standard-1'"
  default     = "n1-standard-1"
  type        = string
}

variable "config_inspection_vm_image" {
  description = "Disk image to use for booting up the inspection VMs, default 'debian-cloud/debian-10'"
  default     = "debian-cloud/debian-10"
  type        = string
}

// --- Preemptible options --- //
variable "config_vm_elasticsearch_flag_preemptible" {
  description = "Use this flag for deploying Elastic Search nodes on preemptible VMs, default 'false'"
  type        = bool
  default     = false
}

variable "config_vm_clickhouse_flag_preemptible" {
  description = "Use this flag for deploying Clickhouse nodes on preemptible VMs, default 'false'"
  type        = bool
  default     = false
}

variable "config_vm_api_flag_preemptible" {
  description = "Use this flag for deploying API nodes on preemptible VMs, default 'false'"
  type        = bool
  default     = false
}

variable "config_vm_webserver_flag_preemptible" {
  description = "Use this flag for deploying Web nodes on preemptible VMs, default 'false'"
  type        = bool
  default     = false
}

// gcloud //
variable "use_tf_google_credentials_env_var" {
  # Description: Whether to use environment variables for GCP credentials (default: true)
  description = "Whether to use environment variables for GCP credentials (default: true)"
  default     = true
}

variable "create_cmd_entrypoint" {
  # Description: The command-line tool to use for creating named ports (default: gcloud)
  description = "The command-line tool to use for creating named ports (default: gcloud)"
  default     = "gcloud"
}

/* Existing variables likely defined elsewhere (assuming you follow typical naming conventions)
variable "REDACTED" {
default = "excelra-rnd-gsk-otg-2024"
}
variable "port_name" {
  default = "http:30000"
}
variable "node_port" {
  default = "32000"
}*/
