provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

module "iam" {
  source = ".\\IAM"
}

module "network" {
  source = ".\\Network"
}

module "Infrastructure" {
  source = ".\\Infrastructure"
  service_role_arn_var = module.iam.OpsWorksAcess_output
  default_instance_profile_arn_var = module.iam.EC2Acess_output
  default_subnet_id_var = module.network.default_az1_output
  vpc_id_var =  module.network.default_vpc_output
  custom_security_group_ids_var = module.network.FrontEndSG_outuput
  depends_on = [
    module.iam,
    module.network,
    
  ]
}
