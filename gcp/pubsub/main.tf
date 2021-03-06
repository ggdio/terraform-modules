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
  project                         = var.project_id
}

data "google_project" "project" {
  project_id                      = var.project_id
}

locals {
  default_ack_deadline_seconds    = 10
  members                         = var.members
}

resource "google_pubsub_topic_iam_binding" "push_topic_binding" {
  count                           = var.create_topic ? length(var.push_subscriptions) : 0
  project                         = var.project_id
  topic                           = lookup(var.push_subscriptions[count.index], "dead_letter_topic", "projects/${var.project_id}/topics/${var.topic}")
  role                            = "roles/pubsub.publisher"
  members                         = local.members
  depends_on                      = [
    google_pubsub_topic.topic,
  ]
}

resource "google_pubsub_topic_iam_binding" "pull_topic_binding" {
  count                           = var.create_topic ? length(var.pull_subscriptions) : 0
  project                         = var.project_id
  topic                           = lookup(var.pull_subscriptions[count.index], "dead_letter_topic", "projects/${var.project_id}/topics/${var.topic}")
  role                            = "roles/pubsub.publisher"
  members                         = local.members
  depends_on                      = [
    google_pubsub_topic.topic,
  ]
}

resource "google_pubsub_subscription_iam_binding" "pull_subscription_binding" {
  count                           = var.create_topic ? length(var.pull_subscriptions) : 0
  project                         = var.project_id
  subscription                    = var.pull_subscriptions[count.index].name
  role                            = "roles/pubsub.subscriber"
  members                         = local.members
  depends_on                      = [
    google_pubsub_subscription.pull_subscriptions,
  ]
}

resource "google_pubsub_subscription_iam_binding" "push_subscription_binding" {
  count                           = var.create_topic ? length(var.push_subscriptions) : 0
  project                         = var.project_id
  subscription                    = var.push_subscriptions[count.index].name
  role                            = "roles/pubsub.subscriber"
  members                         = local.members
  depends_on                      = [
    google_pubsub_subscription.push_subscriptions,
  ]
}

resource "google_pubsub_topic" "topic" {
  count                           = var.create_topic ? 1 : 0
  project                         = var.project_id
  name                            = var.topic
  labels                          = merge(var.topic_labels, { type = "queue", resource = "google_pubsub_topic" })
  kms_key_name                    = var.topic_kms_key_name

  dynamic "message_storage_policy" {
    for_each                      = var.message_storage_policy
    content {
      allowed_persistence_regions = message_storage_policy.key == "allowed_persistence_regions" ? message_storage_policy.value : null
    }
  }
}

resource "google_pubsub_subscription" "push_subscriptions" {
  count                           = var.create_topic ? length(var.push_subscriptions) : 0
  name                            = var.push_subscriptions[count.index].name
  topic                           = google_pubsub_topic.topic.0.name
  project                         = var.project_id
  ack_deadline_seconds            = lookup(
    var.push_subscriptions[count.index],
    "ack_deadline_seconds",
    local.default_ack_deadline_seconds,
  )
  message_retention_duration      = lookup(
    var.push_subscriptions[count.index],
    "message_retention_duration",
    null,
  )
  dynamic "expiration_policy" {
    // check if the 'expiration_policy' key exists, if yes, return a list containing it.
    for_each = contains(keys(var.push_subscriptions[count.index]), "expiration_policy") ? [var.push_subscriptions[count.index].expiration_policy] : []
    content {
      ttl = expiration_policy.value
    }
  }

  dynamic "dead_letter_policy" {
    for_each = (lookup(var.push_subscriptions[count.index], "dead_letter_topic", "") != "") ? [var.push_subscriptions[count.index].dead_letter_topic] : []
    content {
      dead_letter_topic          = lookup(var.push_subscriptions[count.index], "dead_letter_topic", "")
      max_delivery_attempts      = lookup(var.push_subscriptions[count.index], "max_delivery_attempts", "5")
    }
  }

  push_config {
    push_endpoint                = var.push_subscriptions[count.index]["push_endpoint"]

    // FIXME: This should be programmable, but nested map isn't supported at this time.
    //   https://github.com/hashicorp/terraform/issues/2114
    attributes                   = {
      x-goog-version             = lookup(var.push_subscriptions[count.index], "x-goog-version", "v1")
    }

    dynamic "oidc_token" {
      for_each                   = (lookup(var.push_subscriptions[count.index], "oidc_service_account_email", "") != "") ? [true] : []
      content {
        service_account_email    = lookup(var.push_subscriptions[count.index], "oidc_service_account_email", "")
        audience                 = lookup(var.push_subscriptions[count.index], "audience", "")
      }
    }
  }
  depends_on                     = [
    google_pubsub_topic.topic,
  ]
}

resource "google_pubsub_subscription" "pull_subscriptions" {
  count                          = var.create_topic ? length(var.pull_subscriptions) : 0
  name                           = var.pull_subscriptions[count.index].name
  topic                          = google_pubsub_topic.topic.0.name
  project                        = var.project_id
  ack_deadline_seconds           = lookup(
    var.pull_subscriptions[count.index],
    "ack_deadline_seconds",
    local.default_ack_deadline_seconds,
  )
  message_retention_duration     = lookup(
    var.pull_subscriptions[count.index],
    "message_retention_duration",
    null,
  )
  dynamic "expiration_policy" {
    // check if the 'expiration_policy' key exists, if yes, return a list containing it.
    for_each = contains(keys(var.pull_subscriptions[count.index]), "expiration_policy") ? [var.pull_subscriptions[count.index].expiration_policy] : []
    content {
      ttl = expiration_policy.value
    }
  }

  dynamic "dead_letter_policy" {
    for_each = (lookup(var.pull_subscriptions[count.index], "dead_letter_topic", "") != "") ? [var.pull_subscriptions[count.index].dead_letter_topic] : []
    content {
      dead_letter_topic          = lookup(var.pull_subscriptions[count.index], "dead_letter_topic", "")
      max_delivery_attempts      = lookup(var.pull_subscriptions[count.index], "max_delivery_attempts", "5")
    }
  }

  depends_on                     = [
    google_pubsub_topic.topic,
  ]
}
