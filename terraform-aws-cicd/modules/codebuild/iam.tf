// Account ID
data "aws_caller_identity" "current" {}

// IAM Policy CodeBuild
data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    actions = [ "sts:AssumeRole" ]
  }
}

// IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_s3_role" {
    name = "cicd-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

// IAM Policy for CodeBuild to interact with S3
data "aws_iam_policy_document" "codebuild_s3_policy_doc" {
  statement {
    effect = "Allow"
    actions = [ "s3:GetObject", "s3:PutObject", "s3:ListBucket" ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_id}", # Bucket level
      "arn:aws:s3:::${var.s3_bucket_id}/*", # Object level
    ]
  }

  statement {
    effect = "Allow"
    actions = [ "secretsmanager:GetSecretValue" ]
    resources = [ "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:token" ]
  }

  statement {
    effect = "Allow"
    actions = [ 
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
     ]
     resources = ["*"]
  }
}

// Attach the policy to the CodeBuild role
resource "aws_iam_policy" "codebuild_s3_policy" {
  name = "codebuild-s3-policy"
  policy = data.aws_iam_policy_document.codebuild_s3_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "codebuild_s3_attachment" {
  role = aws_iam_role.codebuild_s3_role.name  
  policy_arn = aws_iam_policy.codebuild_s3_policy.arn 
}