// Retrive already stored PAT in SSM
data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = "token"
}

// CODEBUILD CONFIGURATION
resource "aws_codebuild_project" "codebuild_project" {
  name = "cicd-development-project"
  description = "This is a codebuild project"
  build_timeout = 6
  service_role = aws_iam_role.codebuild_s3_role.arn 
  badge_enabled = true 

  artifacts {
    type = "S3"
    location = "${var.s3_bucket_id}/codebuild-artifacts"
  }

  cache {
    type = "S3"
    location = "${var.s3_bucket_location}/codebuild-cache"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${aws_codebuild_project.codebuild_project.name}"
      stream_name = "build-log-${aws_codebuild.project_codebuild_project.name}"
    }

    s3_logs {
      status = "ENABLED"
      location = "${var.s3_logging_bucket}/build-log"
    }
  }

  source {
    type = "GITHUB"
    location = var.github_repo_url
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true 
    }
  }

  source_version = "main"

  tags = {
    Environment = "development"
  }
}

// If repository is public, you won't need this resource block
resource "aws_codebuild_source_credential" "codebuild_credential" {
  auth_type = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"

  token = data.aws_secretsmanager_secret_version.secrets.secret_string
}

resource "aws_codebuild_webhook" "codebuild_webhook" {
  project_name = aws_codebuild_project.codebuild_project.name 
  build_type = "BUILD"

  filter_group {
    filter {
      type = "EVENT"
      pattern = "PUSH|PULL_REQUEST_MERGED"
    }

    filter {
      type = "BASE_REF"
      pattern = "main"
    }
  }
}

resource "github_repository_webhook" "github_webhook" {
  active = true 
  events = ["push"]
  name = "gitrepo"
  repository = "soleng"

  configuration {
    url = aws_codebuild_webhook.codebuild_webhook.payload_url
    secret = aws_codebuild_webhook.codebuild_webhook.secret
    content_type = "json"
    insecure_ssl = false
  }
}