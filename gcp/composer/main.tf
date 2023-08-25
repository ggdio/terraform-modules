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

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "random" {}

resource "google_composer_environment" "airflow_cluster" {
  name    = var.cluster_name
  region  = var.region
  project = var.project_id
  labels  = merge(var.labels, { resource = "google_composer_environment", type = "workflow_management_platform" })
  config {
    node_count = var.node_count
    node_config {
      zone            = var.zone
      machine_type    = var.machine_type
      disk_size_gb    = var.disk_size_gb
      network         = var.network
      subnetwork      = var.subnetwork
      service_account = var.service_account_email
      ip_allocation_policy {
        use_ip_aliases                = var.use_ip_aliases
        cluster_secondary_range_name  = var.cluster_secondary_range_name
        services_secondary_range_name = var.services_secondary_range_name
      }
    }
    private_environment_config {
      master_ipv4_cidr_block     = var.master_ipv4_cidr_block
      web_server_ipv4_cidr_block = var.web_server_ipv4_cidr_block
      enable_private_endpoint    = var.enable_private_endpoint
    }
    software_config {
      image_version  = var.composer_version
      python_version = var.python_version
      env_variables  = var.composer_env_variables

      airflow_config_overrides = {
        smtp-ssl            = var.smtp_ssl
        smtp-starttls       = var.smtp_starttls
        smtp-smtp_host      = var.smtp_host
        smtp-smtp_port      = var.smtp_port
        smtp-smtp_user      = var.smtp_user
        smtp-smtp_password  = var.smtp_password
        smtp-smtp_mail_from = var.smtp_mail_from
        email-email_backend = "airflow.contrib.utils.sendgrid.send_email"
        #core-default_timezone = var.default_timezone
        #scheduler-catchup_by_default = var.catchup_by_default
        webserver-default_ui_timezone = var.default_timezone
      }
    }
  }
}
