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

variable "project_id" {
  type        = string
  description = "(Required) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "collection_id" {
  type        = string
  description = "(Required) The collection ID, relative to database. For example: chatrooms or chatrooms/my-document/private-messages."
}

variable "document_id" {
  type        = string
  description = "(Required) The client-assigned document ID to use for this document during creation."
}

variable "fields" {
  type        = string
  description = "(Required) The document's fields formated as a json string."
}

variable "database" {
  type        = string
  description = "(Optional) The Firestore database id. Defaults to '(default)'"
  default     = "(default)"
}