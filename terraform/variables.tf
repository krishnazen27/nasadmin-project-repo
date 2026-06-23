variable "region" {
  default = "eu-west-1"
}

variable "key_name" {
  description = "SSH key name"
}

variable "public_key_path" {
  description = "Path to SSH public key"
}
