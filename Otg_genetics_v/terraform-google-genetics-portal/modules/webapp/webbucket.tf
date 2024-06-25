// This file defines a public (Read-Only) bucket where all the components of the application will be put together for the web server VMs to pull from it when launching

resource "random_string" "random_webbucket" {
  length = 8
  lower = true
  upper = false
  special = false
  keepers = {
    webapp_release = var.webapp_release
    webapp_repository = var.webapp_repo_name
    robots_profile_name = var.webapp_robots_profile
    deployment_bundle_filename = local.webapp_deployment_bundle_filename
    deployment_scope = var.module_wide_prefix_scope
    deployment_context = md5(jsonencode(var.webapp_deployment_context))
  }
}

// --- Website Bucket Definition --- //
module "bucket_webapp" {
  #source    =  "github.com/mbdebian/terraform-google-static-assets//modules/cloud-storage-static-website"
  source    =  "https://excelra.visualstudio.com/GCP%20POC/_git/terraform-google-static-assets?version=GBmaster&_a=contents&path=/modules/cloud-storage-static-website"
  #source  = "git::https://github.com/mbdebian/terraform-google-static-assets/tree/master/modules/cloud-storage-static-website"
  #source = "github.com/gruntwork-io/terraform-google-static-assets/test"
  #source = "https://github.com/opentargets/genetics-app.git"
  #source   = "https://github.com/gruntwork-io/terraform-google-static-assets/tree/master/modules/cloud-storage-static-website"
  #source   = "https://github.com/gruntwork-io/terraform-google-static-assets/tree/master/examples/cloud-storage-static-website"
  #source   = "https://github.com/gruntwork-io/terraform-google-static-assets/.*"
  #source  = "github.com/mbdebian/terraform-google-static-assets/modules/cloud-storage-static-website"
  project  = var.project_id
  // Website and Logs buckets configuration
  website_domain_name = local.bucket_name
  access_log_prefix = local.bucket_logs_prefix
  force_destroy_website = true
  force_destroy_access_logs_bucket = true
  website_location = var.webapp_bucket_location
  website_storage_class = local.bucket_storage_class
  // Pages configuration
  not_found_page = var.website_not_found_page
  // Access logs configuration
  access_logs_expiration_time_in_days = 30
  // CORS
  enable_cors = true
  cors_origins = [ "*"]
}

// --- Web Application Content Provisioner --- //
resource "null_resource" "webapp_provisioner" {
  depends_on = [ module.bucket_webapp ]
  // Redeployment will be triggered whenever the bucket name changes
  triggers = {
    bucket_name = module.bucket_webapp.website_bucket_name
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    working_dir = var.folder_tmp
    environment = merge({
        working_dir = local.webapp_provisioner_path_working_dir
        url_bundle_download = local.webapp_bundle_provisioner_url_bundle_download
        path_build = local.webapp_bundle_provisioner_path_build
        file_name_devops_context_template = local.webapp_bundle_provisioner_file_name_devops_context_template
        file_name_devops_context_instance = local.webapp_bundle_provisioner_file_name_devops_context_instance
        bucket_webapp_url = "gs://${module.bucket_webapp.website_bucket_name}"
        robots_active_file_name = local.webapp_bundle_provisioner_robots_active_file_name
        robots_profile_src_file_name = local.webapp_bundle_provisioner_robots_profile_src
        robots_profile_name = var.webapp_robots_profile
        deployment_bundle_filename = local.webapp_deployment_bundle_filename
      },
      local.webapp_provisioner_deployment_context
    )
    command = "${local.webapp_bundle_provisioner_path_script}"
  }
}

/*// --- Web Application Content Provisioner --- //
resource "null_resource" "webapp_provisioner" {
  depends_on = [ module.bucket_webapp ]
  # Redeployment will be triggered whenever the bucket name changes
  triggers = {
    bucket_name = module.bucket_webapp.website_bucket_name
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    working_dir = var.folder_tmp
    environment = merge({
      working_dir = local.webapp_provisioner_path_working_dir
      url_bundle_download = local.webapp_bundle_provisioner_url_bundle_download
      path_build = local.webapp_bundle_provisioner_path_build
      file_name_devops_context_template = local.webapp_bundle_provisioner_file_name_devops_context_template
      file_name_devops_context_instance = local.webapp_bundle_provisioner_file_name_devops_context_instance
      bucket_webapp_url = "gs://${module.bucket_webapp.website_bucket_name}"
      robots_active_file_name = local.webapp_bundle_provisioner_robots_active_file_name
      robots_profile_src_file_name = local.webapp_bundle_provisioner_robots_profile_src
      robots_profile_name = var.webapp_robots_profile
      deployment_bundle_filename = local.webapp_deployment_bundle_filename
    },
    local.webapp_provisioner_deployment_context
    )
    # This line assumes the script path is defined in local.webapp_bundle_provisioner_path_script with correct permissions
    command = "${local.webapp_bundle_provisioner_path_script}"
  }
}*/
