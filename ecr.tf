locals {
  ecr_names = toset([
    "check-out-backend",
    "check-out-ai",
    "check-out-frontend",
  ])
}

resource "aws_ecr_repository" "ecr_repositories" {
  for_each             = local.ecr_names
  name                 = each.key
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

output "ecr_repositories" {
  value = {
    for k, v in aws_ecr_repository.ecr_repositories : k => v.repository_url
  }
}
