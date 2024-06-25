// --- Open Targets Genetics Portal Web Application definition --- //
// Author: Manuel Bernal Llinares <mbdebian@gmail.com>

// --- Underlying Infrastructure Details --- //
// Availability Zones --- //
data "google_compute_zones" "gcp_available_zones" {
  count   = length(local.gcp_available_region_names_sorted)
  project = var.project_id

  region = local.gcp_available_region_names_sorted[count.index]
}