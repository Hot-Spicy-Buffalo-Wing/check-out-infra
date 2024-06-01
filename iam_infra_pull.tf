resource "aws_iam_policy" "infra_ecr_pull" {
  name = "infra_ecr_pull"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource = "*",
      },
    ]
  })
}

resource "aws_iam_group" "github_pull" {
  name = "github_pull"
}

resource "aws_iam_user" "github_pull" {
  name = "github_pull"
}

resource "aws_iam_user_policy_attachment" "github_pull" {
  user       = aws_iam_user.github_pull.name
  policy_arn = aws_iam_policy.infra_ecr_pull.arn
}

resource "aws_iam_group_membership" "github_pull" {
  name  = "github_pull"
  users = [aws_iam_user.github_pull.name]
  group = aws_iam_group.github_pull.name
}

resource "aws_iam_access_key" "github_pull" {
  user = aws_iam_user.github_pull.name
}

output "ecr_push_access_secret" {
  value = {
    access_key = aws_iam_access_key.github_pull.id,
    secret_key = aws_iam_access_key.github_pull.secret
  }
  sensitive = true
}
