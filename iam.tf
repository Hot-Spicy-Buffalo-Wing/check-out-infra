resource "aws_iam_policy" "github_ecr_push" {
  for_each = aws_ecr_repository.ecr_repositories
  name     = "github_ecr_push_${each.key}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
        ],
        Resource = "*",
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource = "${each.value.arn}:*"
      }
    ]
  })
}

resource "aws_iam_group" "github_push" {
  name = "github_push"
}

resource "aws_iam_user" "github_push" {
  for_each = local.ecr_names
  name     = "github_push_${each.key}"
}

resource "aws_iam_user_policy_attachment" "github_push" {
  for_each   = local.ecr_names
  user       = aws_iam_user.github_push[each.key].name
  policy_arn = aws_iam_policy.github_ecr_push[each.key].arn
}

resource "aws_iam_group_membership" "github_push" {
  name  = "github_push"
  users = [for k in aws_iam_user.github_push : k.name]
  group = aws_iam_group.github_push.name
}

resource "aws_iam_access_key" "github_push" {
  for_each = aws_iam_user.github_push
  user     = each.value.name
}

output "github_actions_access_secret" {
  value = {
    for k in aws_iam_access_key.github_push : k.user => {
      access_key = k.id,
      secret_key = k.secret
    }
  }
  sensitive = true
}
