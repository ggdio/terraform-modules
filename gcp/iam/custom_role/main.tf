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
  project     = var.project_id
}

resource "random_id" "name_suffix" {
  byte_length = 3
}

resource "google_project_iam_custom_role" "custom-role" {
  role_id     = "${var.role_id}${random_id.name_suffix.hex}"
  title       = var.title
  project     = var.project
  description = var.description
  permissions = var.permissions

  lifecycle {
    create_before_destroy = true
  }  
}

output "role" {
  value       = google_project_iam_custom_role.custom-role
}

### VARIABLES ###
variable "role_id" {}
variable "project" {}
variable "title" {}
variable "description" {}
variable "permissions" { default = [] }
