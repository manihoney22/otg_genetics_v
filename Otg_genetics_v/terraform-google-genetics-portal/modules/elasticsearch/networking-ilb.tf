// --- Elastic Search Internal Load Balancer definition --- //
// Forwarding rule --- //
resource "google_compute_forwarding_rule" "ilb_forwarding_rule" {
project = var.project_id

  depends_on = [
      google_compute_region_backend_service.ilb_backend_service
    ]

  name = "${var.module_wide_prefix_scope}-ilb-forwarding-rule"
  region = var.deployment_region
  load_balancing_scheme = "INTERNAL"
  network = var.network_self_link
  subnetwork = var.network_subnet_name
  backend_service = google_compute_region_backend_service.ilb_backend_service.id
  ports = [ local.elastic_search_port_requests ]
}

// Backend Service --- //
resource "google_compute_region_backend_service" "ilb_backend_service" {
project = var.project_id

  depends_on = [
      google_compute_region_instance_group_manager.regmig_elastic_search
    ]

  name = "${var.module_wide_prefix_scope}-ilb-backend-service"
  region = var.deployment_region
  load_balancing_scheme = "INTERNAL"

  backend {
    group = google_compute_region_instance_group_manager.regmig_elastic_search.instance_group
  }

  protocol = "TCP"
  timeout_sec = 10

  health_checks = [ google_compute_region_health_check.ilb_backend_healthcheck.id ]
}

// Health Checks --- //
resource "google_compute_region_health_check" "ilb_backend_healthcheck" {
  project = var.project_id

  name = "${var.module_wide_prefix_scope}-ilb-backend-healthcheck"
  region = var.deployment_region

  tcp_health_check {
    // Elastic Search Requests Port
    port = local.elastic_search_port_requests
  }
}

/*module "ilb_es" {
  source       = "GoogleCloudPlatform/lb-internal/google"
  version      = "~> 2.0"

  depends_on = [
      google_compute_region_instance_group_manager.regmig_elastic_search
    ]

  project = var.project_id
  region       = var.deployment_region
  name         = "${var.module_wide_prefix_scope}-ilb-${random_string.random_es_vm.result}"
  ports        = [ local.elastic_search_port_requests ]
  source_tags  = []
  target_tags  = [local.fw_tag_elasticsearch_requests, local.fw_tag_elasticsearch_comms]
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
    port                = local.elastic_search_port_requests
    port_name           = local.elastic_search_port_requests_name
    request_path        = "/"
    // WTF is this? Amazing documentation 
    host                = "1.2.3.4"
  }
  backends     = [
    {
        group = google_compute_region_instance_group_manager.regmig_elastic_search.instance_group,
        description = "Elastic Search regional instance group for '${var.deployment_region}'"
        },
  ]
}*/