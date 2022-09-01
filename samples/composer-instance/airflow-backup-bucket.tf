module "composer_backup_bucket" {
  source = "./modules/storage/bucket/"

  project_id  = var.project_id
  bucket_name = var.dags_backup_bucket_name
  region      = var.region
  members     = var.members
  labels      = module.labels_composer_instance.common_labels
}
