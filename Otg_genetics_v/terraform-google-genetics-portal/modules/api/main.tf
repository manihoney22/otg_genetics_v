// Open Targets Genetics Portal API deployment definition
// Author: Manuel Bernal Llinares <mbdebian@gmail.com>
/*
    This module defines a multi-regional deployment of Open Target Genetics Portal API
*/

// --- GCP Underlaying infrastructure details --- //
// Access to Available compute zones per region --- //
data "google_compute_zones" "gcp_available_zones" {
  count   = length(local.gcp_available_region_names_sorted)
  project = var.project_id

  region = local.gcp_available_region_names_sorted[count.index]
}