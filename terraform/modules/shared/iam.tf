data "aws_iam_policy_document" "ec2_service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default_ec2_role" {
  name               = "default-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_service.json
}

data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default_ec2_role.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

resource "aws_iam_instance_profile" "default_ec2_profile" {
  name = "default-ec2-profile"
  role = aws_iam_role.default_ec2_role.name
}
