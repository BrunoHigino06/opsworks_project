# Stack
resource "aws_opsworks_stack" "FrontEndStack" {
  name                         = "FrontEndStack"
  region                       = "us-east-1"
  service_role_arn             = var.service_role_arn_var
  default_instance_profile_arn = var.default_instance_profile_arn_var
  default_subnet_id = var.default_subnet_id_var
  default_os = "Ubuntu 18.04 LTS"
  default_ssh_key_name = aws_key_pair.generated_key.key_name
  vpc_id = var.vpc_id_var
  configuration_manager_version = 12
  use_custom_cookbooks = true
  color = "rgb(135, 61, 98)"
  use_opsworks_security_groups = false
  agent_version = "LATEST"
  
  custom_cookbooks_source {
    type = "git"
    url  = "https://github.com/BrunoHigino06/OpsWorkRecipes.git"
  }
}

# Key Pair
variable "generated_key_name" {
  type        = string
  default     = "key"
  description = "Key-pair generated by Terraform"
}

resource "tls_private_key" "privkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.privkey.public_key_openssh

}
#Layer

resource "aws_opsworks_custom_layer" "FrontEndLayer" {
  name       = "FrontEndLayer"
  short_name = "frontendlayer"
  stack_id   = aws_opsworks_stack.FrontEndStack.id
  auto_assign_public_ips = true
  custom_configure_recipes = ["nginx::NginxInstall"]
  custom_security_group_ids = [var.custom_security_group_ids_var,]
  depends_on = [
    aws_opsworks_stack.FrontEndStack
  ]
}

# instance created from opsworks
resource "aws_opsworks_instance" "frontEnd_Instance" {
  stack_id = aws_opsworks_stack.FrontEndStack.id
  layer_ids = [aws_opsworks_custom_layer.FrontEndLayer.id]
  instance_type = "t2.micro"
  state         = "stopped"
  root_device_type = "ebs"
  
}
