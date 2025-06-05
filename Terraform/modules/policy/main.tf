resource "aws_iam_policy" "ssm_access_policy" {
  name   = "SSMAccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ssm:GetParameter",
          "ssm:PutParameter"
        ],
        Resource = "*"
      }
    ]
  })
}
