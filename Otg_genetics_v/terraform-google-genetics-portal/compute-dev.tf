// --- Compute resources deployed for supporting development / inspection activities --- //
// Inspection VM --- //
resource "random_string" "random_inspection_vm" {
  length  = 8
  lower   = true
  upper   = false
  special = false
  keepers = {
    machine_type = var.config_inspection_vm_machine_type
    vm_image     = var.config_inspection_vm_image
  }
}

resource "google_compute_instance" "inspection_vm" {
  // This definition will deploy a small VM in each deployment region for debugging communication and other infrastructure issues
  count = length(var.config_deployment_regions) * local.inspection_conditional_deployment

  project = var.config_project_id

  name         = "${var.config_release_name}-inspection-vm-${count.index}-${random_string.random_inspection_vm.result}"
  machine_type = var.config_inspection_vm_machine_type
  zone         = local.gcp_available_zones_per_region[var.config_deployment_regions[count.index]][0]

  depends_on = [module.vpc_network]

  boot_disk {
    initialize_params {
      image = var.config_inspection_vm_image
    }
  }

  network_interface {
    network    = module.vpc_network.network_self_link
    subnetwork = "main-subnet"
  }

  tags = ["ssh"]

  lifecycle {
    create_before_destroy = true
  }
}
