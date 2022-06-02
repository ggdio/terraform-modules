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
  project                     = var.project_id
  region                      = var.region
}

data "google_project" "project" {
  project_id                  = var.project_id
}

resource "google_storage_bucket_iam_binding" "bucket_store_binding" {
  bucket                      = google_storage_bucket.bucket_store.name
  role                        = "roles/storage.admin"
  members                     = var.members
}

resource "google_storage_bucket" "bucket_store" {
  name                        = var.bucket_name
  location                    = var.region
  labels                      = merge(var.labels, { type = "storage", resource = "google_storage_bucket" })
  uniform_bucket_level_access = true
}
