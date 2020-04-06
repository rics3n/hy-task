# tesseract connection params
variable "tesseract_ip" {
  description = "The tesseract service ip address to connect to"
  type        = string
}

variable "tesseract_port" {
  description = "The tesseract service port"
  type        = string
}

# postgres connection params
variable "postgres_host" {
  description = "The postgres host address"
  type        = string
}

variable "postgres_port" {
  description = "The postgres port"
  type        = string
}

variable "postgres_user" {
  description = "The postgres user to use for the cp-matcher service"
  type        = string
}

variable "postgres_password" {
  description = "The postgres user password"
  type        = string
}

# service config
variable "cp_matcher_version" {
  description = "The service version the docker container to run is tagged with"
  type = string
}

variable "cp_matcher_replicas" {
  description = "The number of replicas for the service"
  type = number
}

