module "sa_composer_instance" {
  source      = "./modules/iam/service_account/"
  name        = var.sa_name
  project_id  = var.project_id
  create_key  = false
  iam         = local.iam
  description = "Service Account used by Composer environment."
}

locals {
  iam = {
    dataproc = {
      target-project = var.project_id
      target-roles = [
        "roles/composer.admin",
        "roles/composer.worker",
        "roles/compute.admin",
        "roles/dataproc.admin",
        "roles/iam.serviceAccountTokenCreator",
        "roles/iam.serviceAccountUser",
        "roles/storage.admin",
        "roles/bigquery.jobUser",
        "roles/bigquery.dataEditor",
        "roles/dataflow.developer",
        "roles/dataflow.worker",
        "roles/dlp.user"
      ]
    }
  }
}
