resource "google_sql_database_instance" "master" {
  name             = "cpmatcher"
  database_version = "POSTGRES_11"
  region = var.region
  project = var.project

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"

    ip_configuration {
      authorized_networks {
        # for better security this needs to be removed
        value = "0.0.0.0/0"
      }

      require_ssl  = false
      ipv4_enabled = true
    }
  }
}

resource "google_sql_database" "database" {
  name      = "cp_matcher_production"
  project = var.project
  instance  = google_sql_database_instance.master.name
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "google_sql_user" "postgres" {
  name     = "postgres"
  project = var.project

  instance = google_sql_database_instance.master.name
  password = random_password.password.result
}