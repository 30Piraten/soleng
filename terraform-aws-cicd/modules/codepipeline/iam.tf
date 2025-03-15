data "aws_iam_policy_document" "code_pipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
    actions = [ "sts:AssumeRole" ]
  }
}

resource "aws_iam_role" "code_pipeline_role" {
  name = "code-pipelinev1-role"
  assume_role_policy = data.aws_iam_policy_document.code_pipeline_assume_role.json 
}

data "aws_iam_policy_document" "code_pipeline_policy_doc" {
  statement {
    effect = "Allow"
    actions = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.github.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = [ "${var.codebuild_arn}" ]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-policy"
  role = aws_iam_role.code_pipeline_role.id 
  policy = data.aws_iam_policy_document.code_pipeline_policy_doc.json 
}

resource "aws_iam_role_policy_attachment" "codepipeline_s3_access" {
  role = aws_iam_role.code_pipeline_role.name 
  policy_arn = var.s3_policy_arn 
}