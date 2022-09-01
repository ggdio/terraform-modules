module "composer_instance" {
  source = "./modules/orchestrator/airflow/"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  composer_version = var.composer_version

  machine_type = var.machine_type
  node_count   = var.node_count
  disk_size_gb = var.disk_size_gb

  python_version = var.python_version
  cluster_name   = var.cluster_name

  network                       = var.network
  subnetwork                    = var.subnetwork
  cluster_secondary_range_name  = var.cluster_secondary_range_name
  services_secondary_range_name = var.services_secondary_range_name
  master_ipv4_cidr_block        = var.master_ipv4_cidr_block
  web_server_ipv4_cidr_block    = var.web_server_ipv4_cidr_block
  use_ip_aliases                = var.use_ip_aliases
  enable_private_endpoint       = var.enable_private_endpoint
  bucket                        = "" # Not being used in module
  disable_create_storage        = var.disable_create_storage

  service_account_email  = module.sa_composer_instance.sa.email
  labels                 = module.labels_composer_instance.common_labels
  composer_env_variables = local.composer_env_variables

  smtp_port = var.smtp_port
  smtp_mail_from = var.smtp_mail_from
  smtp_host = var.smtp_host
  smtp_starttls = var.smtp_starttls
  smtp_ssl = var.smtp_ssl
  smtp_user = var.smtp_user
  smtp_password = var.smtp_password


}

locals {
  composer_env_variables = {
    gcp_composer_name = var.cluster_name
    gcp_project       = var.project_id
    gcp_region        = var.region
    gcp_zone          = var.zone
  }
}
