variable "aws_region" {
  description = "AWS region to deploy Strapi"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ssh_key_name" {
  description = "Existing EC2 key pair name for SSH access"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance"
  type        = string
  default     = "0.0.0.0/0" # better: your IP, but this is ok for demo
}

variable "allowed_http_cidr" {
  description = "CIDR block allowed to access Strapi HTTP port"
  type        = string
  default     = "0.0.0.0/0"
}

# Secrets – in real life, don't keep defaults. Override via terraform.tfvars
variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  default     = "StrapiDemoPass123!"
  sensitive   = true
}

variable "app_keys" {
  description = "Strapi APP_KEYS (comma-separated)"
  type        = string
  default     = "key1,key2,key3"
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT secret"
  type        = string
  default     = "SomeJWTSecret"
  sensitive   = true
}

variable "admin_jwt_secret" {
  description = "Admin JWT secret"
  type        = string
  default     = "SomeAdminSecret"
  sensitive   = true
}

variable "api_token_salt" {
  description = "API token salt"
  type        = string
  default     = "SomeApiTokenSalt"
  sensitive   = true
}

