variable "public_subnet" {
  description = "The subnet used for publicly accessible resources"
}

variable "private_subnet" {
  description = "The subnet used for resources that do not need direct in-bound access and are not databases"
}

variable "database_subnet" {
  description = "The subnet used for database resources, which do not need direct in-bound access"
}
