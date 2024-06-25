// --- Open Targets Genetics Portal DNS configuration --- //
// Entry for Open Target API GLB
resource "google_dns_record_set" "dns_a_api_glb" {
  // Common
  project      = var.config_dns_project_id
  managed_zone = var.config_dns_managed_zone_name
  type         = "A"
  ttl          = 5

  // Entry
  name    = local.dns_api_dns_name
  rrdatas = [module.glb.external_ip]
}

// Entry for Open Targets Platform Web Application
resource "google_dns_record_set" "dns_a_webapp_glb" {
  count = length(local.dns_webapp_domain_names)
  // Common
  project      = var.config_dns_project_id
  managed_zone = var.config_dns_managed_zone_name
  type         = "A"
  ttl          = 5
  // Entry
  name    = local.dns_webapp_domain_names[count.index]
  rrdatas = [module.glb.external_ip]
}