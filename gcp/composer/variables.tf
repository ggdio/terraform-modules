/**
* Licensed to the Apache Software Foundation (ASF) under one
* or more contributor license agreements.  See the NOTICE file
* distributed with this work for additional information
* regarding copyright ownership.  The ASF licenses this file
* to you under the Apache License, Version 2.0 (the
* "License"); you may not use this file except in compliance
* with the License.  You may obtain a copy of the License at
* 
*   http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an
* "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
* KIND, either express or implied.  See the License for the
* specific language governing permissions and limitations
* under the License. 
*/

variable "machine_type" { default = "n2-standard-2" }
variable "node_count" { default = 3 }
variable "disk_size_gb" { default = 500 }

variable "python_version" { default = 3 }

variable "cluster_name" {}

variable "composer_version" {
  #default = "composer-1.11.2-airflow-1.10.9"
  default = "composer-1.12.3-airflow-1.10.9"
}

variable "project_id" {
  default = "xxx"
}

variable "location" {
  description = "The Project Location."
  type        = string
  default     = "US"
}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-b"
}

variable "network" {
  default = "projects/xxx/global/networks/xxx"
}

variable "subnetwork" {
  default = "projects/xxx/regions/southamerica-east1/subnetworks/xxx"
}

variable "service_account_email" {}

variable "disable_create_storage" { default = false }

variable "use_ip_aliases" { default = true }

variable "cluster_secondary_range_name" {}

variable "services_secondary_range_name" {}

variable "enable_private_environment" { default = true }

variable "master_ipv4_cidr_block" {
  description = "Network range like: 10.77.13.160/28"
  type        = string
}

variable "web_server_ipv4_cidr_block" {
  description = "Network range like: 172.31.244.56/29"
  type        = string
}

variable "auto_create_subnetworks" { default = false }

variable "enable_private_endpoint" { default = true }

variable "bucket" {
  type = string
}

variable "labels" {
  type        = map(string)
  description = "Airflow labels"
  default     = {}
}

variable "composer_env_variables" {
  type = map(string)
}

variable "default_timezone" {
  type = string
  default = "America/Sao_Paulo"
}

variable "catchup_by_default" {
  type = string
  default = "False"
}

variable "smtp_port" {
  type = string
}

variable "smtp_mail_from" {
  type = string
}

variable "smtp_host" {
  type = string
}

variable "smtp_starttls" {
  type = string
}

variable "smtp_ssl" {
  type = string
}

variable "smtp_user" {
  type = string
}

variable "smtp_password" {
  type = string
}