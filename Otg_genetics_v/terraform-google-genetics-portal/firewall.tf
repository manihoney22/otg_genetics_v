// --- Deployment-wide Firewalls definitions --- //
module "firewall_rules" {
  source = "terraform-google-modules/network/google//modules/firewall-rules"

  depends_on = [
    module.vpc_network
  ]

  project_id   = var.config_project_id
  network_name = module.vpc_network.network_name

  // Keep in mind that logging is disabled for the defined firewall rules
  rules = [
    // SSH
    {
      name        = "${var.config_release_name}-fw-allow-ssh-ingress"
      description = "Allow SSH INBOUND traffic to nodes tagged accordingly"
      direction   = "INGRESS"
      ranges      = ["0.0.0.0/0"]
      target_tags = [local.fw_tag_ssh]
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      deny                    = []
      priority                = null
      source_tags             = null
      source_service_accounts = null
      target_service_accounts = null
      log_config              = null
    },
    // HTTP
    {
      name        = "${var.config_release_name}-fw-allow-http-ingress"
      description = "Allow HTTP INBOUND traffic to nodes tagged accordingly"
      direction   = "INGRESS"
      ranges      = ["0.0.0.0/0"]
      target_tags = [local.fw_tag_http]
      allow = [{
        protocol = "tcp"
        ports    = ["80", "8080"]
      }]
      deny                    = []
      priority                = null
      source_tags             = null
      source_service_accounts = null
      target_service_accounts = null
      log_config              = null
    },
    // HTTPS
    {
      name        = "${var.config_release_name}-fw-allow-https-ingress"
      description = "Allow HTTPS INBOUND traffic to nodes tagged accordingly"
      direction   = "INGRESS"
      ranges      = ["0.0.0.0/0"]
      target_tags = [local.fw_tag_https]
      allow = [{
        protocol = "tcp"
        ports    = ["443"]
      }]
      deny                    = []
      priority                = null
      source_tags             = null
      source_service_accounts = null
      target_service_accounts = null
      log_config              = null
    },
    // ICMP
    {
      name        = "${var.config_release_name}-fw-allow-icmp-ingress"
      description = "Allow ICMP INBOUND traffic to nodes tagged accordingly"
      direction   = "INGRESS"
      ranges      = ["0.0.0.0/0"]
      target_tags = null
      allow = [{
        protocol = "icmp"
        ports    = []
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