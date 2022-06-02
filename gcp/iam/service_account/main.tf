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
  project          = var.project_id
}

resource "google_service_account" "sa" {
  project          = var.project_id
  account_id       = var.name
  display_name     = var.name
  description      = var.description
}

locals {
  iam              = flatten([for key, i in var.iam : [for index, role in i.target-roles : {
    key            = key
    index          = index
    target-project = i.target-project
    target-role    = role
  }]])

  map_iam = { for i in local.iam : "${i.key}-${i.index}" => i }
}

resource "google_project_iam_member" "sa" {
  for_each         = var.iam == null ? null : local.map_iam
  project          = each.value.target-project
  role             = each.value.target-role
  member           = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_folder_iam_member" "sa" {
  for_each         = var.iam-folder == null ? null : var.iam-folder
  folder           = each.value.target-folder
  role             = each.value.target-role
  member           = "serviceAccount:${google_service_account.sa.email}"
}

output "sa" {
  value            = google_service_account.sa
}

variable "name" {}
variable "project_id" {}
variable "description" {}
variable "iam" { default = {} }
variable "create_key" { default = false }
variable "kubernetes_namespace" { default = "iam-credentials" }
variable "iam-folder" { default = {} }
variable "location" { default = "us-east4" }
