// S3 STATIC WEBSITE CONFIGURATION

// S3 static website bucket 
resource "aws_s3_bucket" "cicd_bucket" {
    bucket = var.bucket_name

    tags = {
        Name = "cicd-static-web"
    }
}

// Enforce folder structure for CodeBuild
resource "aws_s3_object" "codebuild_folder" {
  bucket = aws_s3_bucket.cicd_bucket.id 
  key = "codebuild-artifacts/"
}

// Enforce folder structure for CodeBuild cache
resource "aws_s3_object" "codebuild_cache" {
  bucket = aws_s3_bucket.cicd_bucket.id 
  key = "codebuild-cache/"
}

// Enforce folder structure for CodePipeline
resource "aws_s3_object" "codepipeline_folder" {
  bucket = aws_s3_bucket.cicd_bucket.id
  key = "codepipeline-artifacts/"
}


// S3 bucket website configuration
resource "aws_s3_bucket_website_configuration" "static_website_config" {
  bucket = aws_s3_bucket.cicd_bucket.id  

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

// S3 bucket versioning
resource "aws_s3_bucket_versioning" "static_website_version" {
    bucket = aws_s3_bucket.cicd_bucket.id  

    versioning_configuration {
      status = "Enabled"
    }
}

// S3 bucket block public access
resource "aws_s3_bucket_public_access_block" "static_website_bpa" {
    bucket = aws_s3_bucket.cicd_bucket.id  
    block_public_acls = true 
    block_public_policy = true 
    ignore_public_acls = true 
    restrict_public_buckets = true 
}

// S3 bucket lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "static_website_lc" {
    bucket = aws_s3_bucket.cicd_bucket.id  

    rule {
      id = "Remove static website after 7 days."
      status = "Enabled"

      noncurrent_version_expiration {
        noncurrent_days = 7
      }
    }
}

// S3 LOGGING BUCKET FOR THE STATIC WEBSITE
resource "aws_s3_bucket" "static_logging_bucket" {
  bucket = "static-logging-bucket"
}

// Logging for S3 static website 
resource "aws_s3_bucket_logging" "static_website_logging" {
  bucket = aws_s3_bucket.cicd_bucket.id  

  target_bucket = aws_s3_bucket.static_logging_bucket.id 
  target_prefix = "/logs"
}