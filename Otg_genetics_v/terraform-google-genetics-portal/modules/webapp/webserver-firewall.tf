// --- Web Server Firewall definition --- //
module "firewall_rules" {
  source = "terraform-google-modules/network/google//modules/firewall-rules"

  count = length(var.webserver_deployment_regions)

  project_id   = var.project_id
  network_name = var.network_name

  // Keep in mind that logging is disabled for the defined firewall rules
  rules = [
    // Web Traffic to the web server nodes
    {
      name        = "${var.network_name}-${var.webserver_deployment_regions[count.index]}-allow-webserver-node"
      description = "Allow HTTP INBOUND traffic to Web App Server nodes"
      direction   = "INGRESS"
      ranges      = [ var.network_source_ranges_map[var.webserver_deployment_regions[count.index]].source_range ]
      target_tags = [ local.fw_tag_webserver_node ]
      allow = [{
        protocol = "tcp"
        ports    = [ local.webapp_webserver_port ]
      }]
      deny                    = []
      priority                = null
      source_tags             = null
      source_service_accounts = null
      target_service_accounts = null
      log_config              = null
    },
    // Health Checks
    {
      name        = "${var.network_name}-${var.webserver_deployment_regions[count.index]}-allow-webserver-healthchecks"
      description = "Firewall rule to allow Web App Server nodes Health Checks traffic"
      direction   = "INGRESS"
      ranges      = concat(
    [ var.network_source_ranges_map[var.webserver_deployment_regions[count.index]].source_range ],
    var.network_sources_health_checks
  )
      target_tags = [ local.fw_tag_webserver_node ]
      allow = [{
        protocol = "tcp"
        ports    = [ local.webapp_webserver_port ]
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
