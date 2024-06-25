// --- Networking related stuff --- //
// Default Network Tier --- //
resource "google_compute_project_default_network_tier" "default_network_tier" {
  network_tier = "PREMIUM"
  project      = var.config_project_id
}
