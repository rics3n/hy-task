output "tesseract_ip" {
  value     = kubernetes_service.tesseract.load_balancer_ingress.0.ip
}

output "tesseract_port" {
  value     = kubernetes_service.tesseract.spec.0.port.0.node_port
}
