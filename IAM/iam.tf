# Role for OpsWorks Acess
resource "aws_iam_role" "OpsWorksAcess_role" {
  name = "OpsWorksAcess"
  assume_role_policy = "${file(".\\IAM\\OpsWorksAssumeRole.json")}"
  tags = {
    Name = "OpsWorksAcess"
  }
}

# Output for de OpsWorks role

output "OpsWorksAcess_output" {
  value = aws_iam_role.OpsWorksAcess_role.arn
  depends_on = [
    aws_iam_role.OpsWorksAcess_role
  ]
}

# Policy that is attach to the OpsWork Role

resource "aws_iam_role_policy" "OpsWorksAcess_policy" {
  name = "OpsWorksAcessPolicy"
  role = aws_iam_role.OpsWorksAcess_role.id
  policy = "${file(".\\IAM\\OpsWorksPolicy.json")}"

  depends_on = [
    aws_iam_role.OpsWorksAcess_role
  ]
}


# Role for EC2 Acess

resource "aws_iam_instance_profile" "EC2Acess__profile" {
  name = "EC2Acess__profile"
  role = aws_iam_role.EC2Acess_role.name
}

resource "aws_iam_role" "EC2Acess_role" {
  name = "EC2Acess"
  assume_role_policy = "${file(".\\IAM\\EC2AssumeRole.json")}"
  tags = {
    Name = "EC2Acess"
  }
}

# Output for de EC2 role
output "EC2Acess_output" {
  value = aws_iam_instance_profile.EC2Acess__profile.arn
  depends_on = [
    aws_iam_role.EC2Acess_role
  ]
}

# Policy that is attach to the EC2 Role

resource "aws_iam_role_policy" "EC2Acess_policy" {
  name = "EC2Acess__policy"
  role = aws_iam_role.EC2Acess_role.id

  policy = "${file(".\\IAM\\EC2Policy.json")}"

  depends_on = [
    aws_iam_role.EC2Acess_role
  ]
}