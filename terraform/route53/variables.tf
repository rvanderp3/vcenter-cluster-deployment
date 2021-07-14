variable "domain" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "hosted_zone" {
  type = string
}

variable "segment_start_number" {
  type = number
}

variable "segment_count" {
  type = number
}

variable "segment_load_balancer" {
  type = string
}

variable "segment_load_balancer_start" {
  type = number
}