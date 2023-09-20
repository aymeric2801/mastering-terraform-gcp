resource "google_project_iam_member" "storage_admin" {
  project = "formation-udemy-terraform"
  role    = "roles/storage.admin"
  member  = "serviceAccount:formation-udemy-terraform-key@formation-udemy-terraform.iam.gserviceaccount.com"
}

resource "google_storage_bucket" "example_bucket" {
  name     = "my-example-bucket-terraform"
  location = "US"
}

resource "google_compute_network" "example_vpc" {
  name                    = "example-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "example_subnet" {
  name          = "example-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.example_vpc.self_link
}

resource "google_compute_firewall" "example_firewall" {
  name    = "example-firewall"
  network = google_compute_network.example_vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "example_instance" {
  name         = "example-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network      = "default"
    access_config {}
  }
}

// Implementing load balancers with Terraform

resource "google_compute_health_check" "example_health_check" {
  name               = "example-health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 10

  http_health_check {
    port = 80
  }
}

resource "google_compute_instance_group" "example_instance_group" {
  name        = "example-instance-group"
  zone        = "us-central1-a"
  instances   = [google_compute_instance.example_instance.self_link]

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_backend_service" "example_backend_service" {
  name             = "example-backend-service"
  backend {
    group = google_compute_instance_group.example_instance_group.self_link
  }
  health_checks    = [google_compute_health_check.example_health_check.self_link]
  port_name        = "http"
  protocol         = "HTTP"
  timeout_sec      = 10
}

resource "google_compute_target_http_proxy" "example_http_proxy" {
  name        = "example-http-proxy"
  url_map     = google_compute_url_map.example_url_map.self_link
}

resource "google_compute_url_map" "example_url_map" {
  name             = "example-url-map"
  default_service  = google_compute_backend_service.example_backend_service.self_link
}

resource "google_compute_global_forwarding_rule" "example_forwarding_rule" {
  name               = "example-forwarding-rule"
  ip_protocol        = "TCP"
  port_range         = "80"
  target             = google_compute_target_http_proxy.example_http_proxy.self_link
}

// IAM resource
resource "google_storage_bucket_iam_member" "example_bucket_iam_member" {
  bucket = google_storage_bucket.example_bucket.name
  role   = "roles/storage.objectViewer"
  member = "user:neuvyaymeric@gmail.com"
}

// SQL instance

resource "google_sql_database_instance" "example_instance" {
  name             = "example-instance"
  region           = "us-central1"
  database_version = "POSTGRES_12"

  settings {
    tier = "db-f1-micro"
    
    ip_configuration {
      authorized_networks {
        value = "0.0.0.0/0"
      }
    }
  }
}

// SQL database
resource "google_sql_database" "example_db" {
  name     = "example-db"
  instance = google_sql_database_instance.example_instance.name
}

// SQL user
resource "google_sql_user" "example_user" {
  name     = "example-user"
  instance = google_sql_database_instance.example_instance.name
  password = "example-password"
}

// SQL SSL certificate
resource "google_sql_ssl_cert" "example_cert" {
  common_name = "example-cert"
  instance    = google_sql_database_instance.example_instance.name
}


resource "google_project_service" "firestore_service" {
  project = "formation-udemy-terraform"
  service = "firestore.googleapis.com"
}

resource "google_project_service" "datastore_service" {
  project = "formation-udemy-terraform"
  service = "datastore.googleapis.com"
}


//IAM ROLE 

// assigning the 'storage.admin' role to a service account 
resource "google_project_iam_member" "storage_admin_1" {
  project = "formation-udemy-terraform"
  role    = "roles/storage.admin"
  member  = "serviceAccount:formation-udemy-terraform-key@formation-udemy-terraform.iam.gserviceaccount.com"
}

// role that includes permissions to list, create, and delete other IAM roles. 
resource "google_project_iam_custom_role" "custom_role" {
  role_id = "myCustomRole"
  title = "My Custom Role"
  description = "A description of my custom role"
  permissions = ["iam.roles.list", "iam.roles.create", "iam.roles.delete"]
}

//a service account that can then be assigned IAM roles to access various resources.
resource "google_service_account" "my_service_account" {
  account_id = "my-service-account"
  display_name = "My Service Account"
  description = "This service account does X, Y, and Z"
}

resource "google_project_iam_member" "storage_admin_2" {
  project = "you-project-name"
  role = "roles/storage.admin"
  member = "serviceAccount:formation-udemy-terraform-key@formation-udemy-terraform.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "example_bucket_iam_member_1" {
  bucket = google_storage_bucket.example_bucket.name
  role = "roles/storage.objectViewer"
  member = "user:youemail@gmail.com"
}


//pubsub topic subscription
resource "google_pubsub_topic" "example_topic" {
  name = "example-topic"
}

resource "google_pubsub_subscription" "example_subscription" {
  name  = "example-subscription"
  topic = google_pubsub_topic.example_topic.name

  ack_deadline_seconds = 20
}


//big query 
resource "google_bigquery_dataset" "example_dataset" {
  dataset_id = "example_dataset"
  location   = "US"
}

resource "google_bigquery_table" "example_table" {
  dataset_id = google_bigquery_dataset.example_dataset.dataset_id
  table_id   = "example_table"

  schema = <<EOH
[
  {
    "name": "name",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "age",
    "type": "INTEGER",
    "mode": "NULLABLE"
  }
]
EOH
}

data "google_client_config" "default" {}

// Configure the Kubernetes provider
provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  client_certificate     = base64decode(google_container_cluster.primary.master_auth[0].client_certificate)
  client_key             = base64decode(google_container_cluster.primary.master_auth[0].client_key)
}

// Create a GKE cluster
resource "google_container_cluster" "primary" {
  name               = "example-cluster"
  location           = "us-central1"
  initial_node_count = 3

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    machine_type = "e2-medium"  // Utiliser un type de machine avec un disque de démarrage plus petit

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}



// Create a Kubernetes deployment
resource "kubernetes_deployment" "example" {
  metadata {
    name = "example-deployment"
    labels = {
      app = "example"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "example"
      }
    }

    template {
      metadata {
        labels = {
          app = "example"
        }
      }

      spec {
        container {
          name  = "example"
          image = "nginx:1.7.8"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

// Expose the deployment as a service
resource "kubernetes_service" "example" {
  metadata {
    name = "example-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.example.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
 

 resource "google_cloudfunctions_function" "function" {
  name = "function-test"
  description = "My function"
  available_memory-mb = 256
  source_archive_bucket = "your-source-archive-bucket"
  source_archive_object = "source.zip"
  trigger_http = true
  runtime = "python39"
 }