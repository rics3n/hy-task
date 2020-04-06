terraform {
      required_version = ">= 0.12.7"
}
data "google_client_config" "default" {
}
provider "google" {}
provider "kubernetes" {
  host = "https://${module.gke.endpoint}"

  load_config_file = false

  cluster_ca_certificate = base64decode(
    module.gke.cluster_ca_certificate,
  )
  
  token = data.google_client_config.default.access_token
}

module "gke" {
  source = "./modules/gke"

  cluster_name = "wilma"
  min_master_version = "1.15.11-gke.1"

  location = "europe-west3-a"
  project = "test-272611"

  node_pool_name = "wilma-main"
  node_count = 2
} 

module "postgres" {
  source = "./modules/postgres"

  project = "test-272611"
  region = "europe-west3"
}

module "tesseract" {
  source = "./modules/tesseract-service"
  tesseract_replicas = 1
  tesseract_version = "2020.01.13-ubuntu18.04-pkg"
}

module "cp_matcher_service" {
  source = "./modules/cp-matcher-service"

  tesseract_ip = module.tesseract.tesseract_ip
  tesseract_port = module.tesseract.tesseract_port

  postgres_host = module.postgres.db_public_ip_address
  postgres_port = 5432
  postgres_user = module.postgres.db_user
  postgres_password = module.postgres.db_password

  cp_matcher_version = "0.1"
  cp_matcher_replicas = 2
}
