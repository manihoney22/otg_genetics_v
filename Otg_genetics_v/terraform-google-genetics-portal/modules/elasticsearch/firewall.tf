// --- Firewall Configuration --- //
module "firewall_rules" {
  source = "terraform-google-modules/network/google//modules/firewall-rules"

  project_id   = var.project_id
  network_name = var.network_name

  // Keep in mind that logging is disabled for the defined firewall rules
  rules = [
    // Elastic Search Traffic --- //
    // Requests - //
    {
      name        = "${var.network_name}-${var.deployment_region}-allow-elasticsearch-requests"
      description = "Allow Elastic Search INBOUND requests traffic"
      direction   = "INGRESS"
      ranges      = var.network_source_ranges
      target_tags = [ local.fw_tag_elasticsearch_requests ]
      allow = [{
        protocol = "tcp"
        ports    = [ local.elastic_search_port_requests ]
      }]
      deny                    = []
      priority                = null
      source_tags             = null
      source_service_accounts = null
      target_service_accounts = null
      log_config              = null
    },
    // Elastic Search Node communications - //
    {
      name        = "${var.network_name}-${var.deployment_region}-allow-elasticsearch-comms"
      description = "Allow Elastic Search inter-nodes communications traffic"
      direction   = "INGRESS"
      ranges      = var.network_source_ranges
      target_tags = [ local.fw_tag_elasticsearch_comms ]
      allow = [{
        protocol = "tcp"
        ports    = [ local.elastic_search_port_comms ]
      }]
      deny                    = []
      priority                = null
      source_tags             = null
      source_service_accounts = null
      target_service_accounts = null
      log_config              = null
    },
    // Health Checks - //
    {
      name        = "${var.network_name}-${var.deployment_region}-allow-elasticsearch-healthchecks"
      description = "Firewall rule for allowing Health Checks traffic to Elastic Search Nodes"
      direction   = "INGRESS"
      ranges      = concat(var.network_source_ranges, var.network_sources_health_checks)
      target_tags = [ local.fw_tag_elasticsearch_requests ]
      allow = [{
        protocol = "tcp"
        ports    = [ local.elastic_search_port_requests ]
      }]
      deny                    = []
      priority                = null
      source_tags             = null
      source_service_accounts = null
      target_service_accounts = null
      log_config              = null
    }
  ]
}
