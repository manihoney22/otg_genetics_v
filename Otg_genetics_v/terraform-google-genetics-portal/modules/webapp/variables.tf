// --- Web Application Module Input Parameters --- //
// Underlying GCP Infrastructure Details --- //
variable "gcp_available_region_names" {
  // I have to do this due to a weird dependency in Terraform's computed graph
  description = "List of GCP Available Regions for use by the module"
  type = list(string) 
}

// General Deployment Information --- //
variable "module_wide_prefix_scope" {
  description = "Scoping prefix for naming resources in this deployment, default 'mbdevgenwebapp'"
  type = string
  default = "mbdevgenwebapp"
}

variable "project_id" {
  description = "Project ID where resources will be deployed"
  type = string
}

variable "webapp_bucket_location" {
  description = "This input value sets the bucket's location. Multi-Region or Regional buckets location values are supported, see https://cloud.google.com/storage/docs/locations#location-mr for more information. By default, the bucket is regional, location 'EUROPE-WEST4'"
  type = string
  default = "EUROPE-WEST4"
}

// --- Web APP Configuration --- //
// Vanilla Bundle Information --- //
variable "webapp_repo_name" {
  description = "Web Application repository name"
  type = string
}

variable "webapp_release" {
  description = "Release version of the web application to deploy"
  type = string
}
// Operational Context --- //
variable "webapp_deployment_context" {
  description = "Values for parameterising the deployment of the web application, see defaults as an example"
  type = any
  default = {
"DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_API_URL"="'https://api.genetics.opentargets.org/graphql'",
"DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_GOOGLE_TAG_MANAGER_ID"="'GTM-PNQWZ2V'"
}
  #default = {"\"DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_API_URL\"=\"'https://api.genetics.opentargets.org/graphql'\",\"DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_GOOGLE_TAG_MANAGER_ID\"=\"'GTM-PNQWZ2V'\""}
  #default = "{DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_API_URL = 'https://api.genetics.opentargets.org/graphql', DEVOPS_CONTEXT_PLATFORM_APP_CONFIG_GOOGLE_TAG_MANAGER_ID = 'GTM-PNQWZ2V' }"
  /*default = {
    DEVOPS_CONTEXT_GENETICS_CONFIG_EXAMPLE = "undefined" */
  }

// Robots Profile --- //
variable "webapp_robots_profile" {
  description = "This defines which 'robots.txt' profile to deploy with the web application, default is 'default', which means no changes will be made to the main 'robots.txt' file set in the web application bundle"
  type = string
  default = "default"
}

// TODO Remove this in the next iteration, where the bucket is created in a different way
variable "website_not_found_page" {
  description = "It defines the website 'not found' page, default 'index.html', this no longer needs to be setup, because the bucket will not be serving the web application"
  type = string
  default = "index.html"
}

// --- Web Servers Configuration --- //
// Networking --- //
variable "network_name" {
  description = "Name of the network where resources should be connected to, default 'default'"
  type = string
  default = "default"
}

variable "network_self_link" {
  description = "Self link to the network where resources should be connected when deployed"
  type = string
  default = "default"
}

variable "network_subnet_name" {
  description = "Name of the subnet, within the 'network_name', and the given region, where instances should be connected to, default 'main-subnet'"
  type = string
  default = "main-subnet"
}

variable "network_source_ranges_map" {
  description = "CIDR that represents which IPs we want to grant access to the deployed resources"
  type = any
/*[
    region = {
      subnet_ip = "CIDR"
    }
  ]
 */
}

variable "network_sources_health_checks" {
  description = "Source CIDR for health checks, default '[ 130.211.0.0/22, 35.191.0.0/16 ]'"
  default = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]
}
// Compute Instances (VMs) --- //
variable "webserver_deployment_regions" {
  description = "List of regions where to deploy the web servers"
  type = list(string)
}

variable "webserver_firewall_tags" {
  description = "List of additional tags to attach to API nodes"
  type = list(string)
  default = [ ]
}

variable "webserver_docker_image_version" {
  description = "NginX Docker image version to use in deployment"
  type = string
}

variable "webserver_vm_vcpus" {
  description = "CPU count, default '1'"
  type = number
  default = "1"
}

variable "webserver_vm_mem" {
  description = "Amount of memory allocated Web Server nodes (MiB), default '3840'"
  type = number
  default = "3840"
}

variable "webserver_vm_image" {
  description = "VM image to use for Web Server nodes, default 'cos-stable'"
  type = string
  default = "cos-stable"
}

variable "webserver_vm_image_project" {
  description = "Project hosting the VM image, default 'cos-cloud'"
  type = string
  default = "cos-cloud"
}

variable "webserver_vm_boot_disk_size" {
  description = "Boot disk size for Web Server nodes, default '100000'"
  type = string
  default = "100000"
}

variable "vm_flag_preemptible" {
  description = "Use this flag to tell the module to use a preemptible instance, default: 'false'"
  type = bool
  default = false
}

variable "deployment_target_size" {
  description = "Initial Web Server instance count per region"
  type = number
  default = 1
}

// --- Temporary assets --- //
variable "folder_tmp" {
  description = "Path to a temporary folder where to deploy working directories"
  type = string
  default = "/mnt/c/Users/manikantan.arcot/Desktop/tmp_folder"
  #default = "C:\\Users\\manikantan.arcot\\Desktop\\tmp_folder"
}
