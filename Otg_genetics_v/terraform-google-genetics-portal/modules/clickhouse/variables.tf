// --- Module Input Parameters --- //
// General deployment input parameters --- //
variable "module_wide_prefix_scope" {
  description = "The prefix provided here will scope names for those resources created by this module, default 'mbdevgenesch'"
  type        = string
  default     = "mbdevgenesch"
}

variable "project_id" {
  description = "Project ID where resources will be deployed"
  type        = string
}

variable "network_name" {
  description = "Name of the network resources will be connected to, default 'default'"
  type        = string
  default     = "default"
}

variable "network_self_link" {
  description = "Self link to the network where resources should be connected when deployed, default 'default'"
  type        = string
  default     = "default"
}

variable "network_subnet_name" {
  description = "Name of the subnet, within the 'network_name', and the given region, where instances should be connected to, default 'main-subnet'"
  type        = string
  default     = "main-subnet"
}

variable "network_source_ranges" {
  description = "CIDR that represents which IPs we want to grant access to the deployed resources, default '10.0.0.0/9'"
  type        = list(string)
  default     = ["10.0.0.0/9"]
}

variable "network_sources_health_checks" {
  description = "Source CIDR for health checks, default '[ 130.211.0.0/22, 35.191.0.0/16 ]'"
  default = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]
}

variable "deployment_region" {
  description = "Region where resources should be deployed"
  type        = string
}

// --- Clickhouse Instance Configuration --- //
variable "vm_firewall_tags" {
  description = "Additional tags to attach to deployed Clickhouse nodes, by default, no additional tags will be attached"
  type        = list(string)
  default     = []
}

variable "vm_clickhouse_vcpus" {
  description = "CPU count for Clickhouse instances, default '2'"
  type        = number
  default     = 2
}

variable "vm_clickhouse_mem" {
  description = "Amount of memory allocated for Clickhouse instances (MiB), default '13000'"
  type        = number
  default     = 13000
}

variable "vm_clickhouse_image" {
  description = "VM image to use for Clickhouse nodes"
  type        = string
  default     = "clickhouse/clickhouse-server"
}

variable "vm_clickhouse_version" {
  description = "Clickhouse Docker Image version to use"
  type        = string
  default     = "v1"
}

variable "vm_clickhouse_image_project" {
  description = "Project hosting Clickhouse VM image"
  type        = string
  default     = "excelra-rnd-gsk-otg-2024"
}

variable "vm_clickhouse_boot_disk_size" {
  description = "Clickhouse VM boot disk size, default '100000'"
  type        = string
  default     = "100000"
}
variable "vm_clickhouse_container_project" {
  description = "Project hosting container optimised images"
  type        = string
  default     = "gcr.io/excelra-rnd-gsk-otg-2024/clickhouse/clickhouse-server@sha256:5411e7c8c4c4d7d8b62917d405f0d3fa857e997041098e19b05e3f75a4242687"
  #default     = "gcr.io/excelra-rnd-gsk-otg-2024/clickhouse/clickhouse-server:v1"
}
variable "vm_clickhouse_disk_project" {
  description = "Project hosting snapshot created by GOS"
  type        = string
  default     = "excelra-rnd-gsk-otg-2024"
}
variable "vm_clickhouse_disk_name" {
  description = "Clickhouse disk snapshot created by GOS"
  type        = string
  default     = "ch"
}

variable "vm_flag_preemptible" {
  description = "Use this flag to tell the module to use a preemptible instance, default: 'false'"
  type        = bool
  default     = false
}

variable "deployment_target_size" {
  description = "This number configures how many instances should be running, default '1'"
  type        = number
  default     = 1
}
