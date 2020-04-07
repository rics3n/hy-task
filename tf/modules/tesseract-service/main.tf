resource "kubernetes_deployment" "tesseract" {
  metadata {
    name = "tesseract"
    labels = {
      App = "Tesseract"
    }
  }

  spec {
    replicas = var.tesseract_replicas
    
    selector {
      match_labels = {
        App = "Tesseract"
      }
    }

    template {
      metadata {
        labels = {
          App = "Tesseract"
        }
      }
      spec {
        container {
          image = "mauvilsa/tesseract-recognize:${var.tesseract_version}"
          name  = "tesseract"   
          resources {
            limits {
              cpu    = "0.5"
              memory = "500Mi"
            }
            requests {
              cpu    = "0.1"
              memory = "100Mi"
            }
          }       
        }
      }
    }
  }
}

resource "kubernetes_service" "tesseract" {
  metadata {
    name = "tesseract-service"
  }
  spec {
    selector = {
      App = kubernetes_deployment.tesseract.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}