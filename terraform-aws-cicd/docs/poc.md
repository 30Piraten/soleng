# **Proof of Concept - AWS CI/CD Pipeline with Terraform**

## Objective
- Infrastructure as Code: define AWS resources using Terraform.
- Implement automated deployment of a static website using GitHub and AWS CodePipeline.
- Validation the deployment by verifying the website's accessibility and content. 

## High-Level Architecture
**Workflow:**
- Developer pushes code (static website) to GitHub repository. 
- GitHub push triggers AWS CodePipeline.
- CodePipeline executes a CodeBuild stage, which:
    * runs `terraform init` and `terraform apply` to create/update infrastructure.
    * syncs website files to the S3 bucket. 
- The static website is deployed and accessible via S3's website URL.
- Terraform state is stored in S3 for persistence. 
- The end-user can gain access to said webiste via S3 URL.

![CI/CD - High Level Architecture](./../arc/arc2.png)

## AWS Services Used
- AWS CodePipeline - Automates deployments process.
- AWS CodeBuild - Executes the Terraform commands and copies website files.
- AWS S3 - Hosts the static website and stores the Terraform state. 
- AWS IAM - Manages permissions for CodePipeline, CodeBuild, and S3.
- Terraform - Defines and manage the infrastructure as code. 

## Terraform Code Overview
**Folder Structure:** 

```markdown
📂 terraform-aws-ci-cd
 ┣ 📂 modules
 ┃ ┣ 📜 backend.tf (S3 state management)
 ┃ ┣ 📜 buildspec.yaml (Build config)
 ┃ ┣ 📜 codebuild.tf (Build & Deploy)
 ┃ ┣ 📜 codepipeline.tf (Pipeline setup)
 ┃ ┣ 📜 iam.tf (IAM roles & permissions)
 ┃ ┣ 📜 s3.tf (S3 bucket for hosting)
 ┃ ┗ 📜 variables.tf (Variable declaration)
 ┣ 📜 main.tf (Terraform entry point)
 ┣ 📜 README.md (Setup guide)
 ┗ 📜 outputs.tf (Outputs for validation)
```

**Key Resources:**
- `aws_codepipeline`: Defines the CI/CD pipeline.
- `aws_codebuild_project`: Configures the CodeBuild project.
- `aws_s3_bucket`: Creates the S3 bucket for the website.
- `aws_iam_role`: Defines IAM roles for the CodePipeline and CodeBuild.
- `aws_iam_policy`: Defines the IAM policies.
- `aws_iam_role_policy_attachment`: Attaches policies to roles. 

**Code Snippets:**
- *CodePipeline*
```terraform

```

- *buildspec*
```yaml

```

**Terraform State Management:**
The Terraform state will be stored in an S3 bucket (terraform-state-bucket) for persistence and collaboration.

- *backend.tf*
```terraform
terraform {
    backend "s3" {
        bucket          = "terraform-state-bucket"
        key             = "cicd-pipeline/terraform.tfstate"
        region          = var.region
        encrypt         = true 
        dynamodb_table  = "terraform-lock"
    }
}
```

## Validation
- A simple static website (HTML, CSS, Javscript) will be placed in the website/ directory of the GitHub repository.
- After CodePipeline completes, the website will be accessible via the S3 bucket's website endpoint.
- The content of the website will also be validated to ensure it matches the latest commit in the GitHub repository. 
- To validate, the S3 website enpoint will be accessed in the browser, and the displayed content will be compared with the local website files.
- Additionally, the terraform state will be validated to ensure the changes were applied correctly. 

## IAM Details
- CodePipeline Role: Grants CodePipeline permissions to access GitHub, CodeBuild, and S3. 
- CodeBuild Role: Grants CodeBuild permissions to execute Terraform commands and interact with S3.
- S3 Bucket Policy: Allows public read access to the website files.
- Terraform State S3 Bucket Policy: Grants codebuild access to read and write to the state file. 

- *iam.tf*
```terraform
resource "aws_iam_role_policy" "codebuild_policy" {}
```

## Error Handling
- CodePipeline will provide visual feedback on pipeline execution status.
- CloudWatch logs for CodeBuild will be monitored for error messages. 
- CodePipeline notifications can be configured to send email alerts on pipeline failures.

## Cleanup
- To clean up the resources, run:
    * `terraform destroy` from the directory containing the Terraform files.
- Delete the S3 buckets used for the website and Terraform state.
- Delete the CodePipeline and CodeBuild projects.
- Delete the IAM roles. 

## Out of Scope
- Advanced website functionality (e.g., dynamic content, backend integration).
- Thorough testing of the website's functionality.
- Detailed performance testing.
- Complex networking setups.