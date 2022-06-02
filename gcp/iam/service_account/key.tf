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

resource "random_id" "name_suffix" {
  count       = var.create_key == false ? 0 : 1
  byte_length = 3
}

resource "google_service_account_key" "sa_key" {
  count              = var.create_key == false ? 0 : 1
  service_account_id = google_service_account.sa.email
}

locals {
  service_account_prefix     = element(split("@", element(split("/", google_service_account.sa.email), 3)), 0)
  service_account_suffix     = element(split("@", element(split("/", google_service_account.sa.email), 3)), 1)
  service_account_k8s_secret = var.create_key == false ? "No key created" : "${local.service_account_prefix}.${local.service_account_suffix}-${random_id.name_suffix[0].hex}"
  service_account_gcp_secret = var.create_key == false ? "No key created" : "${local.service_account_prefix}-${random_id.name_suffix[0].hex}"
}

resource "google_secret_manager_secret" "service-account-key" {
  count     = var.create_key == false ? 0 : 1
  provider  = google-beta
  project   = var.project_id
  secret_id = local.service_account_gcp_secret
  labels = {
    sa_name    = var.name
    sa_project = var.project_id
  }
  replication {
    user_managed {
      replicas {
        location = var.location
      }
    }
  }
}

resource "google_secret_manager_secret_version" "version" {
  count       = var.create_key == false ? 0 : 1
  provider    = google-beta
  secret      = google_secret_manager_secret.service-account-key[0].id
  secret_data = google_service_account_key.sa_key[0].private_key
}

output "secret_id" {
  value = local.service_account_gcp_secret
}
