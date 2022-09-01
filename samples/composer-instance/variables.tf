# Shared Vars
variable "project_id" {}
variable "environment" {}
variable "region" {}
variable "zone" {}
variable "gitlab_token" {}

# Network
variable "network" {
  default = "projects/xxx/global/networks/xxx"
}
variable "subnetwork" {}
variable "host_network_project_id" {}

# Airflow
variable "composer_version" {}
variable "machine_type" {}
variable "node_count" {}
variable "disk_size_gb" {}
variable "python_version" {}
variable "cluster_name" {
  default = "composer-instance-01"
}
variable "cluster_secondary_range_name" {}
variable "services_secondary_range_name" {}
variable "master_ipv4_cidr_block" {}
variable "web_server_ipv4_cidr_block" {}
variable "use_ip_aliases" {}
variable "enable_private_endpoint" {}
variable "disable_create_storage" {}

# Bucket SA
variable "members" {}
variable "dags_backup_bucket_name" {}

# Service Account
variable "sa_name" { default = "sa-composer" }

# SMTP
variable "smtp_port" {
  default = null
}
variable "smtp_mail_from" {
  default = null
}
variable "smtp_host" {
  default = null
}
variable "smtp_starttls" {
  default = null
}
variable "smtp_ssl" {
  default = null
}
variable "smtp_user" {
  default = null
}
variable "smtp_password" {
  default = null
}
