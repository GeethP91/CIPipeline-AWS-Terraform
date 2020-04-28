resource "aws_iam_role" "ec2_readonly_role"{
          name = "ec2-readonly-role"
          assume_role_policy = <<EOF
{
          "Version": "2012-10-17",
          "Statement":[
           {
           "Action":"sts:AssumeRole",
           "Principal":{
            "Service": "ec2.amazonaws.com"
           },
          "Effect":"Allow",
          "Sid": ""
}
]
}
EOF
}

data "aws_iam_policy" "ec2-readonly_policy" {
      arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2-readonly-profile"{
  name = "ec2-readonly-profile"
  role = aws_iam_role.ec2_readonly_role.name
 }

resource "aws_iam_role_policy_attachment" "attach-ec2-readonly-policy"{
  role = aws_iam_role.ec2_readonly_role.name
  policy_arn = data.aws_iam_policy.ec2-readonly_policy.arn
}

