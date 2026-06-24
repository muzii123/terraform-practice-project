# ...........Primitive Data Types........


# variable "environment" {
#   type = string
# }

# variable "instance_count" {
#   type = number
# }

# variable "enable_monitoring" {
#   type = bool
# }


# variable "regions" {
#   type = list(string)
# }

# variable "zones" {
#   type = set(string)
# }





variable "aws_region" {
  default     = "eu-north-1"
}

variable "instance_type" {
  default     = "t3.micro"
}

variable "instance_name" {
  default     = "MyFirstEC2"
}

variable "env" {
  type        = string
  default     = "env"
  description = "description"
}

variable "bucket_name" {
  default  = "aws_s3_bucket"
}