//Splat expressions

//with count
resource "aws_instance" "example" {
  count = 3

  ami           = "ami-123456"
  instance_type = "t2.micro"
}

# Extract all instance IDs using splat expression
output "instance_ids" {
  value = aws_instance.example[*].id
}

//with for_each
resource "aws_s3_bucket" "example" {
  for_each = toset(["bucket1", "bucket2", "bucket3"])

  bucket = each.key
}

output "bucket_names" {
  value = aws_s3_bucket.example[*].bucket
}

/*
In Terraform, you can pass variables between modules by declaring input variables in the called module and providing values for those variables from the calling module.
Here's a step-by-step guide to how you can pass variables between modules:
*/

//Called module (child module) :
# File: my_module/variables.tf

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_count" {
  type    = number
  default = 1
}

# Resource using the variables
resource "aws_instance" "example" {
  count         = var.instance_count
  instance_type = var.instance_type
  ami           = "ami-123456"
}

output "instance_ids" {
  value = aws_instance.example[*].id
}

//calling module (parent or root module)
# File: main.tf

# Passing values to my_module
module "my_instance" {
  source = "./my_module"

  instance_type  = "t3.medium"
  instance_count = 2
}

output "my_instance_ids" {
  value = module.my_instance.instance_ids
}

