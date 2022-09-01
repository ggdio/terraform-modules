# Shared vars
project_id  = "xxxx"
environment = "xxxx"
region      = "us-east1"
zone        = "us-east1-b"

# DAGs backup bucket
dags_backup_bucket_name = "composer-backups-prod"
members = [
  "serviceAccount:sa-composer@xxxx.iam.gserviceaccount.com",
]

# Airflow
composer_version = "composer-1.12.3-airflow-1.10.9"

machine_type = "n1-standard-2"
node_count   = 12
disk_size_gb = 60

python_version = 3

network                       = "projects/xxxx/global/networks/xxxx"
subnetwork                    = "projects/xxxx/regions/us-east1/subnetworks/xxxx"
cluster_secondary_range_name  = "xxxx-composer-pods"
services_secondary_range_name = "xxxx-composer-svc"
master_ipv4_cidr_block        = "xxx.xxx.xxx.xxx/28"   # OK
web_server_ipv4_cidr_block    = "xxx.xxx.xxx.xxx/29" # OK
use_ip_aliases                = true
enable_private_endpoint       = true
disable_create_storage        = false

#smtp_mail_from = ""
#smtp_host = ""
#smtp_port = 465
#smtp_starttls = "True"
#smtp_ssl = "False"
