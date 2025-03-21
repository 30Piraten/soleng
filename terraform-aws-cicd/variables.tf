variable "region" {
  type = string 
  default = "us-east-1"
}

variable "bucket_name" {
  type = string 
  default = "terraform-state-bucket"
}

variable "github_repo_url" {
  type = string 
  default = "https://github.com/30Piraten/soleng.git"
}

variable "repo_id" {
  type = string 
  default = "30Piraten/soleng"
}

variable "codepipeline_name" {
  type = string 
  default = "codepipeline-v1"
}