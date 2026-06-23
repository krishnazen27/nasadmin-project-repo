variable "region" {
  default = "eu-west-1"
}

variable "key_name" {
  description = "SSH key name"
  type    = string
  default = "github-actions-key"
}

variable "public_key_path" {
  description = "Path to SSH public key"
  type    = string
  default = "ssh-key/id_rsa.pub"
}

