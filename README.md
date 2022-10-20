<p align="center">
    <a href="https://github.com/tomarv2/terraform-aws-lambda/actions/workflows/pre-commit.yml" alt="Pre Commit">
        <img src="https://github.com/tomarv2/terraform-aws-lambda/actions/workflows/pre-commit.yml/badge.svg?branch=main" /></a>
    <a href="https://www.apache.org/licenses/LICENSE-2.0" alt="license">
        <img src="https://img.shields.io/github/license/tomarv2/terraform-aws-lambda" /></a>
    <a href="https://github.com/tomarv2/terraform-aws-lambda/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-aws-lambda" /></a>
    <a href="https://github.com/tomarv2/terraform-aws-lambda/pulse" alt="Activity">
        <img src="https://img.shields.io/github/commit-activity/m/tomarv2/terraform-aws-lambda" /></a>
    <a href="https://stackoverflow.com/users/6679867/tomarv2" alt="Stack Exchange reputation">
        <img src="https://img.shields.io/stackexchange/stackoverflow/r/6679867"></a>
    <a href="https://twitter.com/intent/follow?screen_name=varuntomar2019" alt="follow on Twitter">
        <img src="https://img.shields.io/twitter/follow/varuntomar2019?style=social&logo=twitter"></a>
</p>

## Terraform module for [AWS Lambda](https://registry.terraform.io/modules/tomarv2/lambda/aws/latest)

### Versions

- Module tested for Terraform 1.0.1.
- AWS provider version [4.35](https://registry.terraform.io/providers/hashicorp/aws/latest).
- `main` branch: Provider versions not pinned to keep up with Terraform releases.
- `tags` releases: Tags are pinned with versions (use <a href="https://github.com/tomarv2/terraform-aws-lambda/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-aws-lambda" /></a>).


### Usage

#### Option 1:

```
terrafrom init
terraform plan -var='teamid=tryme' -var='prjid=project1'
terraform apply -var='teamid=tryme' -var='prjid=project1'
terraform destroy -var='teamid=tryme' -var='prjid=project1'
```
**Note:** With this option please take care of remote state storage

#### Option 2:

##### Recommended method (stores remote state in remote backend(S3,  Azure storage, or Google bucket) using `prjid` and `teamid` to create directory structure):

- Create python 3.8+ virtual environment
```
python3 -m venv <venv name>
```

- Install package:
```
pip install tfremote --upgrade
```

- Set below environment variables:
```
export TF_AWS_BUCKET=<remote state bucket name>
export TF_AWS_BUCKET_REGION=us-west-2
export TF_AWS_PROFILE=<profile from ~/.ws/credentials>
```

or

- Set below environment variables:
```
export TF_AWS_BUCKET=<remote state bucket name>
export TF_AWS_BUCKET_REGION=us-west-2
export AWS_ACCESS_KEY_ID=<aws_access_key_id>
export AWS_SECRET_ACCESS_KEY=<aws_secret_access_key>
```

- Updated `examples` directory with required values.

- Run and verify the output before deploying:
```
tf -c=aws plan -var='teamid=foo' -var='prjid=bar'
```

- Run below to deploy:
```
tf -c=aws apply -var='teamid=foo' -var='prjid=bar'
```

- Run below to destroy:
```
tf -c=aws destroy -var='teamid=foo' -var='prjid=bar'
```

**Note:** Read more on [tfremote](https://github.com/tomarv2/tfremote)

### Lambda
```
module "lambda" {
  source = "git::git@github.com:tomarv2/terraform-aws-lambda.git"

  # -----------------------------------------
  # NOTE: One of the below is required:
  # - existing `role`
  # - `profile_for_iam` and `policy_identifier` (to handle the case where deployment account does not have permission to manage IAM)
  role                = "arn:aws:iam::123456789012:role/demo-role"
  #profile_for_iam    = "iam-team"
  #policy_identifier  = ["events.amazonaws.com", "cloudwatch.amazonaws.com", "lambda.amazonaws.com"]

  # NOTE: One of the below is required:
  # - `source_file`
  # - `source_dir` and/or `exclude_files` and/or `runtime_dependencies`
  source_file           = "lambda_function.py"
  #source_dir           = "demo_lambda"
  #exclude_files        = ["exclude_file.txt"]
  #runtime_dependencies = false
  # -----------------------------------------
  output_path          = "/tmp/test.zip"

  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"
  aws_region = "us-west-2"
  environment = {
    variables = {
      HELLO = "WORLD"
    }
  }
  # -----------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
```

### Lambda(with VPC)
```
module "global" {
  source = "git::git@github.com:tomarv2/terraform-global.git//aws"
}

module "common" {
  source = "git::git@github.com:tomarv2/terraform-global.git//common"
}

module "lambda" {
  source = "git::git@github.com:tomarv2/terraform-aws-lambda.git"

  # -----------------------------------------
  # NOTE: One of the below is required:
  # - existing `role`
  # - `profile_for_iam` and `policy_identifier` (to handle the case where deployment account does not have permission to manage IAM)
  role                  = "arn:aws:iam::123456789012:role/demo-role"
  #profile_for_iam      = "iam-admin"
  #policy_identifier    = ["events.amazonaws.com", "cloudwatch.amazonaws.com", "lambda.amazonaws.com"]

  # NOTE: One of the below is required:
  # - `source_file`
  # - `source_dir` and/or `exclude_files` and/or `runtime_dependencies`
  #source_file         = "lambda_function.py"
  source_dir           = "demo_lambda"
  exclude_files        = ["exclude_file.txt"]
  runtime_dependencies = true
  # -----------------------------------------
  output_path          = "/tmp/test.zip"

  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"
  environment = {
    variables = {
      HELLO = "WORLD"
    }
  }
  # -----------------------------------------
  vpc_config = {
    subnet_ids         = module.global.list_of_subnets["123456789012"]["us-west-2"]
    security_group_ids = [module.security_group.security_group_id]
  }

  # -----------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

module "security_group" {
  source = "git::git@github.com:tomarv2/terraform-aws-security-group.git"

  security_group_ingress = {
    default = {
      description = "https"
      from_port   = 443
      protocol    = "tcp"
      type        = "ingress"
      to_port     = 443
      self        = true
      cidr_blocks = []
    },
    ssh = {
      description = "ssh"
      from_port   = 22
      protocol    = "tcp"
      type        = "ingress"
      to_port     = 22
      self        = false
      cidr_blocks = module.common.cidr_for_sec_grp_access
    }
  }
  #-------------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
```

Please refer to examples directory [link](examples) for references.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.35 |
| <a name="requirement_external"></a> [external](#requirement\_external) | >= 2.1.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | >= 2.1 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.35 |
| <a name="provider_external"></a> [external](#provider\_external) | >= 2.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [external_external.install_python_dependencies](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lambda_config"></a> [lambda\_config](#input\_lambda\_config) | Lambda configuration | `map(any)` | `{}` | no |
| <a name="input_prjid"></a> [prjid](#input\_prjid) | Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `string` | n/a | yes |
| <a name="input_teamid"></a> [teamid](#input\_teamid) | Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply' | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the Lambda function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the Lambda function |
| <a name="output_output_path"></a> [output\_path](#output\_output\_path) | Output file path location |
| <a name="output_output_size"></a> [output\_size](#output\_output\_size) | Output file size |
| <a name="output_source_dir"></a> [source\_dir](#output\_source\_dir) | Source code location |
| <a name="output_source_file"></a> [source\_file](#output\_source\_file) | Lambda source code location |
<!-- END_TF_DOCS -->
