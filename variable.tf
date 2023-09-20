variable "project" {
  type        = string
  description = "The project ID to deploy to"
  default     = "belajar-terraform-398813"
}

variable "region" {
  type        = string
  description = "The region to deploy to"
  default     = "asia-southeast2"
}

variable "zone" {
  type        = string
  description = "The zone to deploy to"
  default     = "asia-southeast2-a"
}

variable "machine_type" {
  type        = string
  description = "The machine type to deploy to"
  default     = "e2-micro"
}

variable "image" {
  type        = string
  description = "The image to deploy to"
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "user" {
  type    = string
  default = "qodri123"
}

variable "email" {
  type    = string
  default = "hazlanmuhammadqodri3@gmail.com"
}
variable "privatekeypath" {
  type    = string
  default = "./credentials/gcp-key"
}

variable "publickeypath" {
  type    = string
  default = "./credentials/gcp-key.pub"
}