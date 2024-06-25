// --- Cloud Routers definition --- //
module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"

  project    = var.config_project_id
  depends_on = [module.vpc_network]


  count = length(var.config_deployment_regions)

  name    = "${var.config_release_name}-router-${count.index}"
  network = module.vpc_network.network_self_link
  region  = var.config_deployment_regions[count.index]

  nats = [{
    name = "${var.config_release_name}-router-${count.index}-nat"
  }]
}
