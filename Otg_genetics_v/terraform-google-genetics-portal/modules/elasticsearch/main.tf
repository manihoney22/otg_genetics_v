// --- Open Targets Genetics Portal, Elastic Search deployment module --- //
// Author: Manuel Bernal Llinares <mbdebian@gmail.com>
/*
    This module defines a Regional Elasctic Search deployment behind a ILB,
    within the context of Open Targets Genetics Portal.
*/

// --- GCP Underlaying infrastructure details --- //
// Access to Available compute zones in the given region --- //
data "google_compute_zones" "gcp_available_zones" {
  project = var.project_id
  region = var.deployment_region
}
