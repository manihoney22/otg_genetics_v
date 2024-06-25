// --- Machine Template --- //
// TODO
//  - When the URL for Elastic search or Clickhouse changes, a new template needs to be generated, and it fails beause that information is not taken into account as a keeper in the 'random_string.random_source_api'
//    - I would need
//      - a source of entropy per deployment region
//      - a rendered version of the startup script per region
resource "random_string" "random_source_api" {
  length  = 8
  lower   = true
  upper   = false
  special = false
  keepers = {
    api_template_tags         = join("", sort(local.api_template_tags)),
    api_template_machine_type = local.api_template_machine_type,
    api_template_source_image = local.api_template_source_image,
    vm_api_image_version      = var.vm_api_image_version,
    data_backend_details      = md5(jsonencode(var.backend_connection_map)),
    vm_flag_preemptible       = var.vm_flag_preemptible
  }
}

// Access to Available compute zones in the given regions --- //
data "google_compute_zones" "gcp_zones_availability" {
  count = length(var.deployment_regions)

  project = var.project_id
  region  = var.deployment_regions[count.index]
}

// --- Service Account Configuration ---
resource "google_service_account" "gcp_service_acc_apis" {
  project      = var.project_id
  account_id   = "${var.module_wide_prefix_scope}-svcacc" //-${random_string.random_source_api.result}"
  display_name = "${var.module_wide_prefix_scope}-GCP-service-account"
}

// Roles ---
resource "google_project_iam_member" "logging-writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gcp_service_acc_apis.email}"
}
resource "google_project_iam_member" "monitoring-writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gcp_service_acc_apis.email}"
}
// --- /Service Account Configuration/ ---

resource "google_compute_instance_template" "api_vm_template" {
  count = length(var.deployment_regions)

  project              = var.project_id
  name                 = "${var.module_wide_prefix_scope}-api-template-${substr(md5(var.deployment_regions[count.index]), -8, -1)}-${random_string.random_source_api.result}"
  description          = "Open Targets Genetics Portal API node template, API docker image version ${var.vm_api_image_version}"
  instance_description = "Open Targets Genetics Portal API node, API docker image version ${var.vm_api_image_version}"
  region               = var.deployment_regions[count.index]


  tags = local.api_template_tags

  machine_type   = local.api_template_machine_type
  can_ip_forward = false

  scheduling {
    automatic_restart   = !var.vm_flag_preemptible
    on_host_maintenance = var.vm_flag_preemptible ? "TERMINATE" : "MIGRATE"
    preemptible         = var.vm_flag_preemptible
    //provisioning_model = "SPOT"
  }

  disk {
    source_image = local.api_template_source_image
    auto_delete  = true
    disk_type    = "pd-ssd"
    boot         = true
    mode         = "READ_WRITE"
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.network_subnet_name
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
    startup-script = templatefile(
      "${path.module}/scripts/instance_startup.sh",
      {
        SLICK_CLICKHOUSE_URL = "jdbc:clickhouse://${var.backend_connection_map[var.deployment_regions[count.index]].host_clickhouse}:8123/ot",
        ELASTICSEARCH_HOST   = var.backend_connection_map[var.deployment_regions[count.index]].host_elastic_search,
        API_VERSION          = var.vm_api_image_version,
        API_PORT             = local.api_port
        DATA_MAJOR           = var.data_major
        DATA_MINOR           = var.data_minor
        DATA_PATCH           = var.data_patch
      }
    )
    google-logging-enabled = true
  }

  service_account {
    email  = google_service_account.gcp_service_acc_apis.email
    scopes = ["cloud-platform", "logging-write", "monitoring-write"]
  }
}

// --- Health Check definition --- //
resource "google_compute_health_check" "api_healthcheck" {
  project             = var.project_id
  name                = "${var.module_wide_prefix_scope}-api-healthcheck"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  tcp_health_check {
    port = local.api_port
  }
}

// --- Regional Instance Group Manager --- //
resource "google_compute_region_instance_group_manager" "regmig_api" {
  count = length(var.deployment_regions)

  project            = var.project_id
  name               = "${var.module_wide_prefix_scope}-regmig-api-${substr(md5(var.deployment_regions[count.index]), -18, -1)}"
  region             = var.deployment_regions[count.index]
  base_instance_name = "${var.module_wide_prefix_scope}-${count.index}-api"
  depends_on = [
    google_compute_instance_template.api_vm_template,
    module.firewall_rules
  ]

  // Instance Template
  version {
    instance_template = google_compute_instance_template.api_vm_template[count.index].id
  }

  //target_size = var.deployment_target_size

  named_port {
    name = local.api_port_name
    port = local.api_port
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.api_healthcheck.id
    initial_delay_sec = 30
  }

  update_policy {
    type                         = "PROACTIVE"
    instance_redistribution_type = "PROACTIVE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = length(data.google_compute_zones.gcp_zones_availability[count.index].names)
    max_unavailable_fixed        = 0
    min_ready_sec                = 30
  }
}

// --- AUTOSCALERS --- //
resource "google_compute_region_autoscaler" "autoscaler_api" {
  count = length(var.deployment_regions)

  project = var.project_id
  name    = "${var.module_wide_prefix_scope}-autoscaler-${substr(md5(var.deployment_regions[count.index]), -18, -1)}"
  region  = var.deployment_regions[count.index]
  target  = google_compute_region_instance_group_manager.regmig_api[count.index].id

  autoscaling_policy {
    max_replicas    = length(data.google_compute_zones.gcp_zones_availability[count.index].names) * 2
    min_replicas    = 1
    cooldown_period = 60
    load_balancing_utilization {
      target = 0.6
    }
    cpu_utilization {
      target = 0.75
    }
  }
}
