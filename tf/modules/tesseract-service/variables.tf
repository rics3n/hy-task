variable "tesseract_replicas" {
  description = "The number of replicas tesseract should be run with"
  type        = number
}

variable "tesseract_version" {
  description = "The image used for the tesseract service"
  type        = string
}