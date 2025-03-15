output "s3_bucket_id" {
  value = aws_s3_bucket.cicd_bucket.id 
}

output "static_logging_bucket_id" {
  value = aws_s3_bucket.static_logging_bucket.id 
}

output "s3_bucket_location" {
  value = aws_s3_bucket.cicd_bucket.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.cicd_bucket.arn 
}

output "s3_policy_arn" {
  value = aws_iam_policy.s3_access_policy.arn 
}