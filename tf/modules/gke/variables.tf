variable "cluster_name" {
  description = "The cluster name to create"
  type        = string
}

variable "min_master_version" {
  description = "The cluster name to create"
  type        = string
}

variable "project" {
  description = "The project ID for the cluster"
  type        = string
}

variable "location" {
  description = "The location of the cluster"
  type        = string
}


variable "node_pool_name" {
  description = "The project ID for the cluster"
  type        = string
}


variable "node_count" {
  description = "The project ID for the cluster"
  type        = string
  default     = 1
}


variable "machine_type" {
  description = "The project ID for the cluster"
  type        = string
  default     = ""
}
