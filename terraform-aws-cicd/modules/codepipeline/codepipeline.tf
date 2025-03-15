resource "aws_codepipeline" "code_pipeline" {
  name = "codepipeline-v1"
  role_arn = aws_iam_role.code_pipeline_role.arn 

  artifact_store {
    location = "${var.s3_bucket}/codepipeline-artifacts" 
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeStarSourceConnection"
      version = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn = aws_codestarconnections_connection.github.arn 
        FullRepositoryId = "30Piraten/soleng"
        BrachName = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["source_output"]
      output_artifacts = ["build_output"]
      version = "1"
    }
  }
}

resource "aws_codestarconnections_connection" "github" {
  name = "github-connection"
  provider_type = "GitHub"
}