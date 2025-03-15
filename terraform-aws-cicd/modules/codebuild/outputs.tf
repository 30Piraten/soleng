output "codebuild_project" {
  value = aws_codebuild_project.codebuild_project.name
}

output "codebuild_arn" {
  value = aws_codebuild_project.codebuild_project.arn 
}