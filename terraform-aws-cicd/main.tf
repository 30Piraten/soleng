module "s3" {
    source = "./modules/s3"
    bucket_name = var.bucket_name
}

module "codebuild" {
  source = "./modules/codebuild"
  region = var.region
  s3_bucket_id = module.s3.s3_bucket_id
  s3_bucket_location = module.s3.s3_bucket_location
  github_repo_url = var.github_repo_url
  s3_logging_bucket = module.s3.static_logging_bucket_id
}

module "codepipeline" {
  source = "./modules/codepipeline"
  s3_bucket = module.s3.s3_bucket_location
  s3_bucket_arn = module.s3.s3_bucket_arn
  codebuild_arn = module.codebuild.codebuild_arn
}