output "repositories" {
  value = {
    for key, value in aws_ecr_repository.this :
    key => {
      id             = value.id
      name           = value.name
      arn            = value.arn
      repository_url = value.repository_url
      registry_id    = value.registry_id
    }
  }
  description = "The map of created repositories"
}
