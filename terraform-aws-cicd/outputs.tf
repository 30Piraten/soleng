// CodeBuild 
output "codebuild_project" {
  value = module.codebuild.codebuild_project
}

// S3 
output "s3_bucket_id" {
  value = module.s3.s3_bucket_id
}

output "s3_logging_bucket" {
  value = module.s3.static_logging_bucket_id
}

// CodePipeline
output "code_pipeline_id" {
  value = module.codepipeline.code_pipeline_id 
}

output "code_pipeline_arn" {
  value = module.codepipeline.code_pipeline_arn 
}