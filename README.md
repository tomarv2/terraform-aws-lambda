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
    <a href="https://discord.gg/XH975bzN" alt="chat on Discord">
        <img src="https://img.shields.io/discord/813961944443912223?logo=discord"></a>
    <a href="https://twitter.com/intent/follow?screen_name=varuntomar2019" alt="follow on Twitter">
        <img src="https://img.shields.io/twitter/follow/varuntomar2019?style=social&logo=twitter"></a>
</p>

# Terraform module to create [AWS Lambda]((https://registry.terraform.io/modules/tomarv2/lambda/aws/latest))

## Versions

- Module tested for Terraform 0.14.
- AWS provider version [3.30.0](https://registry.terraform.io/providers/hashicorp/aws/latest).
- `main` branch: Provider versions not pinned to keep up with Terraform releases.
- `tags` releases: Tags are pinned with versions (use <a href="https://github.com/tomarv2/terraform-aws-lambda/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-aws-lambda" /></a>).


## Usage

### Option 1:

```
terrafrom init
terraform plan -var='teamid=tryme' -var='prjid=project1'
terraform apply -var='teamid=tryme' -var='prjid=project1'
terraform destroy -var='teamid=tryme' -var='prjid=project1'
```
**Note:** With this option please take care of remote state storage

### Option 2:

#### Recommended method (store remote state in S3 using `prjid` and `teamid` to create directory structure):

- Create python 3.6+ virtual environment
```
python3 -m venv <venv name>
```

- Install package:
```
pip install tfremote
```

- Set below environment variables:
```
export TF_AWS_BUCKET=<remote state bucket name>
export TF_AWS_PROFILE=default
export TF_AWS_BUCKET_REGION=us-west-2
```

- Updated `examples` directory with required values.

- Run and verify the output before deploying:
```
tf -cloud aws plan -var='teamid=foo' -var='prjid=bar'
```

- Run below to deploy:
```
tf -cloud aws apply -var='teamid=foo' -var='prjid=bar'
```

- Run below to destroy:
```
tf -cloud aws destroy -var='teamid=foo' -var='prjid=bar'
```
**NOTE:**

- Read more on [tfremote](https://github.com/tomarv2/tfremote)
---

#### Lambda (without event)
```
module "lambda" {
  source = "git::git@github.com:tomarv2/terraform-aws-lambda.git"

  account_id             = "123456789012"
  #
  # NOTE: One of the below is required:
  # existing `role` or
  # `profile_to_use_for_iam` and `policy_identifier`
  # `profile_to_use_for_iam`: to handle the case where deployment account does not have permission
  # to manage IAM
  role                   = "arn:aws:iam::123456789012:role/demo-role"
  runtime                = "python3.8"
  handler                = "lambda_function.lambda_handler"
  #NOTE: `source_file` or `source_dir` and/or `exclude_files` is required
  #source_file           = "lambda_function.py"
  source_dir             = "demo_lambda"
  exclude_files          = ["exclude_file.txt"]
  output_path            = "/tmp/test.zip"
  profile_to_use_for_iam = "iam-admin"
  aws_region             = var.aws_region
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

#### Lambda(with VPC)
```
module "global" {
  source = "git::git@github.com:tomarv2/terraform-global.git//aws"
}

module "common" {
  source = "git::git@github.com:tomarv2/terraform-global.git//common"
}

module "lambda" {
  source = "git::git@github.com:tomarv2/terraform-aws-lambda.git"

  account_id             = "123456789012"
  #
  # NOTE: One of the below is required:
  # existing `role` or
  # `profile_to_use_for_iam` and `policy_identifier`
  # `profile_to_use_for_iam`: to handle the case where deployment account does not have permission
  # to manage IAM
  profile_to_use_for_iam = "iam-admin"
  runtime                = "python3.8"
  handler                = "lambda_function.lambda_handler"
  #NOTE: `source_file` or `source_dir` and/or `exclude_files` is required
  #source_file           = "lambda_function.py"
  source_dir             = "demo_lambda"
  exclude_files          = ["exclude_file.txt"]
  output_path            = "/tmp/test.zip"
  environment = {
    variables = {
      HELLO = "WORLD"
    }
  }
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

  account_id = "123456789012"
  security_group_ingress = {
    default = {
      description = "https"
      from_port   = 443
      protocol    = "tcp"
      to_port     = 443
      self        = true
      cidr_blocks = []
    },
    ssh = {
      description = "ssh"
      from_port   = 22
      protocol    = "tcp"
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

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| archive | ~> 2.2.0 |
| aws | ~> 3.30 |

## Providers

| Name | Version |
|------|---------|
| archive | ~> 2.2.0 |
| aws | ~> 3.30 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | aws account to deploy resources in. | `string` | n/a | yes |
| archive\_type | archive file type. | `string` | `"zip"` | no |
| aws\_region | aws region to deploy resources in. | `string` | `"us-west-2"` | no |
| cloudwatch\_path | name of the log group | `string` | `"aws/lambda"` | no |
| dead\_letter\_config | dead letter config. | <pre>object({<br>    target_arn = string<br>  })</pre> | `null` | no |
| deploy | Controls whether resources should be created | `bool` | `true` | no |
| deploy\_cloudwatch\_event\_trigger | deploy cloud watch event trigger | `bool` | `false` | no |
| deploy\_function | Controls whether Lambda Function resource should be created | `bool` | `true` | no |
| deploy\_layer | Controls whether Lambda Layer resource should be created | `bool` | `false` | no |
| deploy\_package | Controls whether Lambda package should be created | `bool` | `true` | no |
| description | Description of what your Lambda Function does. | `string` | `""` | no |
| environment | environment variables to pass to lambda. | <pre>object({<br>    variables = map(string)<br>  })</pre> | `null` | no |
| exclude\_files | file to exclude in directory from zipping | `string` | `null` | no |
| file\_system\_arn | The Amazon Resource Name (ARN) of the Amazon EFS Access Point that provides access to the file system. | `string` | `null` | no |
| file\_system\_local\_mount\_path | The path where the function can access the file system, starting with /mnt/. | `string` | `null` | no |
| handler | The function entrypoint in your code. | `string` | n/a | yes |
| image\_uri | The ECR image URI containing the function's deployment package. | `string` | `null` | no |
| kms\_key\_arn | The ARN of KMS key to use by your Lambda Function | `string` | `null` | no |
| layers | lambda layers. | `list(string)` | `null` | no |
| memory\_size | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. | `number` | `128` | no |
| output\_path | output file path on local machine to deploy to lambda | `string` | n/a | yes |
| package\_type | The Lambda deployment package type. Valid options: Zip or Image | `string` | `"Zip"` | no |
| performance\_mode | The performance mode of your file system. | `string` | `"generalPurpose"` | no |
| policy\_identifier | iam policy identifier. | `list(string)` | <pre>[<br>  "lambda.amazonaws.com"<br>]</pre> | no |
| prjid | (Required) name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `string` | n/a | yes |
| profile\_to\_use | Getting values from ~/.aws/credentials | `string` | `"default"` | no |
| profile\_to\_use\_for\_iam | profile to use for iam role creation. | `string` | `"default"` | no |
| reserved\_concurrent\_executions | reserved concurrent execution. | `number` | `null` | no |
| role | IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. | `string` | `null` | no |
| runtime | See Runtimes for valid values. | `string` | `""` | no |
| source\_arn | source arn. | `string` | `null` | no |
| source\_dir | input directory path on local machine to zip | `string` | `null` | no |
| source\_file | input file path on local machine to zip | `string` | `null` | no |
| teamid | (Required) name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply' | `string` | n/a | yes |
| timeout | The amount of time your Lambda Function has to run in seconds. Defaults to 3. | `number` | `30` | no |
| tracing\_config | Tracing config. | <pre>object({<br>    mode = string<br>  })</pre> | <pre>{<br>  "mode": "PassThrough"<br>}</pre> | no |
| vpc\_config | vpc config. | <pre>object({<br>    security_group_ids = list(string)<br>    subnet_ids         = list(string)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudwatch\_lambda\_permissions | cloudwatch permission for lambda |
| input\_dir\_name | Source code location |
| input\_file\_name | Source code location |
| lambda\_arn | ARN of the Lambda function |
| lambda\_iam\_role\_arn | ARN of IAM role used by Lambda function |
| output\_dir\_path | Output dir path location |
| output\_dir\_size | Output dir path size |
| output\_file\_path | Output file path location |
| output\_file\_size | Output file path size |
