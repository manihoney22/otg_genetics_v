/*module "gcloud" {
source = "terraform-google-modules/gcloud/google"
version = "~> 2.0"

use_tf_google_credentials_env_var = true

create_cmd_entrypoint = "gcloud"
create_cmd_body = "compute instance-groups set-named-ports --project=${var.REDACTED} ${google_container_cluster.default.instance_group_urls[0]} --named-ports=${var.port_name}:${var.node_port} --format=json"
}*/