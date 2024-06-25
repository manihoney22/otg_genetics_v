// Helper information
locals {

  // Disk
  elastic_search_disk = "${var.vm_elastic_search_disk_project}/${var.vm_elastic_search_disk_name}"
  disk_type           = "pd-ssd"
  disk_mode           = "READ_WRITE"
  disk_size           = 50
  // name used to find disk in running image
  disk_mount_name = "es-disk"
  // Ports
  elastic_search_port_requests      = 9200
  elastic_search_port_comms         = 9300
  elastic_search_port_requests_name = "esportrequests"
  elastic_search_port_comms_name    = "esportcomms"
  // Firewall tags
  fw_tag_elasticsearch_requests = "elasticsearchrequests"
  fw_tag_elasticsearch_comms    = "elasticsearchcomms"

  // Elastic Search instance template values
  elastic_search_template_tags = concat(
    var.vm_firewall_tags,
    [
      local.fw_tag_elasticsearch_requests,
      local.fw_tag_elasticsearch_comms
    ]
  )
  elastic_search_template_machine_type = "custom-${var.vm_elastic_search_vcpus}-${var.vm_elastic_search_mem}"
  elastic_search_template_source_image = "${var.vm_elastic_search_container_project}/${var.vm_elastic_search_image}"
  // Compute Zones internal parameters
  compute_zones_n_total = length(data.google_compute_zones.gcp_available_zones.names)
}
