// --- API Nodes Internal Load Balancer definition --- //
// This ILB definition will keep using the Google module, because the main use case for this is within the context of a development environment
module "ilb_api" {
    count = var.load_balancer_type == local.lb_type_internal ? length(var.deployment_regions) : 0

  source       = "GoogleCloudPlatform/lb-internal/google"
  version      = "~> 2.0"

  depends_on = [
      google_compute_region_instance_group_manager.regmig_api
    ]

  project = var.project_id
  region       = var.deployment_regions[count.index]
  name         = "${var.module_wide_prefix_scope}-ilb-${substr(md5(var.deployment_regions[count.index]), -8, -1)}-${random_string.random_source_api.result}"
  ports        = [
    local.api_port
  ]
  source_tags  = []
  target_tags  = [local.fw_tag_api_node]
  create_backend_firewall = false
  network = var.network_name
  subnetwork = var.network_subnet_name
  health_check = {
    type                = "tcp"
    check_interval_sec  = 1
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    request             = ""
    response            = ""
    proxy_header        = "NONE"
    port                = local.api_port
    port_name           = local.api_port_name
    request_path        = "/"
    // WTF is this? Amazing documentation 
    host                = "1.2.3.4"
  }
  backends     = [
    {
        group = google_compute_region_instance_group_manager.regmig_api[count.index].instance_group,
        description = "API regional instance group for '${var.deployment_regions[count.index]}'"
        },
  ]
}