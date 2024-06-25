// --- Helper Information --- //
locals {

  // Disk
  clickhouse_disk = "${var.vm_clickhouse_disk_project}/${var.vm_clickhouse_disk_name}"
  disk_type       = "pd-ssd"
  disk_mode       = "READ_WRITE"
  disk_size       = 100
  // Used when mounted into COS container under /mnt/disks/by-id/<device_name>
  disk_device_name = "ch"
  // Ports
  clickhouse_http_req_port      = 8123
  clickhouse_cli_req_port       = 9000
  clickhouse_http_req_port_name = "portclickhousehttp"
  clickhouse_cli_req_port_name  = "portclickhousereq"
  // Firewall tags
  fw_tag_clickhouse_node = "clickhousenode"

  // Clickhouse instance template values
  clickhouse_template_tags         = concat(var.vm_firewall_tags, [local.fw_tag_clickhouse_node])
  clickhouse_template_machine_type = "custom-${var.vm_clickhouse_vcpus}-${var.vm_clickhouse_mem}"
  clickhouse_template_source_image = "${var.vm_clickhouse_container_project}/${var.vm_clickhouse_image}"

  // Compute Zones internal parameters
  compute_zones_n_total = length(data.google_compute_zones.gcp_available_zones.names)
}
