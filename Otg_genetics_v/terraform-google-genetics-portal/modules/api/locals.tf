// --- Helper information --- //
locals {
    gcp_available_region_names_sorted = sort(var.gcp_available_region_names)
  gcp_available_zones_per_region = zipmap(
    local.gcp_available_region_names_sorted,
    [for region_details in data.google_compute_zones.gcp_available_zones : region_details.names]
  )
  // API Communication Ports
  api_port = 8080
  api_port_name = "otgpapiport"
  // Firewall
  fw_tag_api_node = "otgpapinode"
  // Load Balancer types
  lb_type_internal = "INTERNAL"
  lb_type_none = "NONE"
  input_validation_load_balancer_type_allowed_values = [
    local.lb_type_internal,
    local.lb_type_none
  ]
  // API VM instance template values
  api_template_tags = concat(
    var.vm_firewall_tags,
    [
      local.fw_tag_api_node
    ]
  )
  api_template_machine_type = "custom-${var.vm_api_vcpus}-${var.vm_api_mem}"
  api_template_source_image = "${var.vm_api_image_project}/${var.vm_api_image}"

}