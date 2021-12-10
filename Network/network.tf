# Default vpc
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

output "default_vpc_output" {
  value = aws_default_vpc.default.id
}

#Default Subnets
resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "default_az1"
  }
}

output "default_az1_output" {
  value = aws_default_subnet.default_az1.id
}

#SG for FrontEnd
resource "aws_security_group" "FrontEndSG" {
  name        = "FrontEndSG"
  description = "Allow frontend traffics"
  vpc_id      = aws_default_vpc.default.id

}

output "FrontEndSG_outuput" {
  value = aws_security_group.FrontEndSG.id

  depends_on = [
    aws_security_group.FrontEndSG
  ]
}


#Rule for the FrontEnd SG

#Ingress

resource "aws_security_group_rule" "FrontEndSGIngress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.FrontEndSG.id

  depends_on = [
    aws_security_group.FrontEndSG
  ]
}

#Egress

resource "aws_security_group_rule" "FrontEndSGEgress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.FrontEndSG.id

  depends_on = [
    aws_security_group.FrontEndSG
  ]
}