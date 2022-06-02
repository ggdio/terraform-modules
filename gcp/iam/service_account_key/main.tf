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
  byte_length = 3
}

resource "google_service_account_key" "sa_key" {
  service_account_id = var.service_account_id
}

locals {
  service_account_prefix = element(split("@", element(split("/", var.service_account_id), 3)), 0)
  service_account_suffix = element(split("@", element(split("/", var.service_account_id), 3)), 1)
}

resource "kubernetes_secret" "service-account-key" {
  metadata {
    name = "${local.service_account_prefix}.${local.service_account_suffix}-${random_id.name_suffix.hex}"
    namespace = var.kubernetes_namespace
  }
  data = {
    "credentials.json" = base64decode(google_service_account_key.sa_key.private_key)
  }
}

variable "service_account_id" { }
variable "kubernetes_namespace" { default = "iam-credentials" }
