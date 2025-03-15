resource "aws_iam_policy" "s3_access_policy" {
  name = "cicd-s3-policy-access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetObjectVersion",
                "s3:PutObject",
                "s3:ListBucket"
            ]
            Resources = [
                "${aws_s3_bucket.cicd_bucket.arn}",
                "${aws_s3_bucket.cicd_bucket.arn}/*"
            ]
        }
    ]
  })
}