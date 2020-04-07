resource "kubernetes_config_map" "cp_matcher" {
  metadata {
    name = "cp-matcher-config"
  }

  data = {
    POSTGRES_PORT_5432_TCP_ADDR = var.postgres_host
    POSTGRES_PORT_5432_TCP_PORT = var.postgres_port
    TESSERACT_PORT_5000_TCP_PORT      = var.tesseract_port
    TESSERACT_PORT_5000_TCP_ADDR      = var.tesseract_ip
  }
}

resource "kubernetes_secret" "cp_matcher" {
  metadata {
    name = "cp-matcher-secrets"
  }

  data = {
    POSTGRES_ENV_POSTGRES_PASSWORD = var.postgres_password
  }
}

resource "kubernetes_deployment" "cp_matcher" {
  metadata {
    name = "cp-matcher"
    labels = {
      App = "CpMatcher"
    }
  }

  spec {
    replicas = var.cp_matcher_replicas
    
    selector {
      match_labels = {
        App = "CpMatcher"
      }
    }

    template {
      metadata {
        labels = {
          App = "CpMatcher"
        }
      }
      spec {
        container {
          image = "rics3n/cp-matcher:${var.cp_matcher_version}"
          name  = "cp-matcher"
          env_from {
            config_map_ref {
              name = kubernetes_config_map.cp_matcher.metadata.0.name
            }
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.cp_matcher.metadata.0.name
            }
          }  

          resources {
            limits {
              cpu    = "0.5"
              memory = "500Mi"
            }
            requests {
              cpu    = "0.1"
              memory = "150Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "cp_matcher" {
  metadata {
    name = "cp-matcher-service"
  }
  spec {
    selector = {
      App = kubernetes_deployment.cp_matcher.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
