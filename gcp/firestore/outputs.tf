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

output "id" {
  value       = length(google_firestore_document.document) > 0 ? google_firestore_document.document.0.id : ""
  description = "An identifier for the resource with format {{name}}"
}

output "name" {
  value       = length(google_firestore_document.document) > 0 ? google_firestore_document.document.0.name : ""
  description = "A server defined name for this index. Format: projects/{{project_id}}/databases/{{database_id}}/documents/{{path}}/{{document_id}}"
}

output "path" {
  value       = length(google_firestore_document.document) > 0 ? google_firestore_document.document.0.path : ""
  description = "A relative path to the collection this document exists within"
}

output "create_time" {
  value       = length(google_firestore_document.document) > 0 ? google_firestore_document.document.0.create_time : ""
  description = "Creation timestamp in RFC3339 format."
}

output "update_time" {
  value       = length(google_firestore_document.document) > 0 ? google_firestore_document.document.0.update_time : ""
  description = "Last update timestamp in RFC3339 format."
}
