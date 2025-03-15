variable "region" {
  type = string 
}

variable "s3_bucket_id" {
  type = string 
  description = "S3 bucket attached to CodeBuild"
}

variable "s3_logging_bucket" {
  type = string 
  description = "Logging bucket for S3 logs"
}

variable "s3_bucket_location" {
  type = string 
  description = "S3 bucket location"
}

variable "github_repo_url" {
  type = string 
  description = "GitHub repository for Codebuild"
}