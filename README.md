<p align="center">
    <a href="https://github.com/tomarv2/terraform-aws-lambda/actions/workflows/security_scans.yml" alt="Security Scans">
        <img src="https://github.com/tomarv2/terraform-aws-lambda/actions/workflows/security_scans.yml/badge.svg?branch=main" /></a>
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
- AWS provider version [3.30.0](https://registry.terraform.io/providers/hashicorp/aws/latest)
- `main` branch: Provider versions not pinned to keep up with Terraform releases
- `tags` releases: Tags are pinned with versions (use <a href="https://github.com/tomarv2/terraform-aws-lambda/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-aws-lambda" /></a> in your releases)


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
  source = "git::git@github.com:tomarv2/terraform-aws-lambda.git?ref=v0.0.2"

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
  source_file            = "lambda_function.py"
  output_file_path       = "/tmp/test.zip"
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
  source = "git::git@github.com:tomarv2/terraform-global.git//aws?ref=v0.0.1"
}

module "common" {
  source = "git::git@github.com:tomarv2/terraform-global.git//common?ref=v0.0.1"
}

module "lambda" {
  source = "git::git@github.com:tomarv2/terraform-aws-lambda.git?ref=v0.0.2"

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
  source_file            = "lambda_function.py"
  output_file_path       = "/tmp/test.zip"
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
  source = "git::git@github.com:tomarv2/terraform-aws-security-group.git?ref=v0.0.2"

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
| aws | ~> 3.30 |

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | ~> 3.30 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | n/a | `any` | n/a | yes |
| archive\_type | n/a | `string` | `"zip"` | no |
| aws\_region | n/a | `string` | `"us-west-2"` | no |
| dead\_letter\_config | n/a | <pre>object({<br>    target_arn = string<br>  })</pre> | `null` | no |
| description | Description of what your Lambda Function does. | `string` | `""` | no |
| environment | n/a | <pre>object({<br>    variables = map(string)<br>  })</pre> | `null` | no |
| handler | The function entrypoint in your code. | `any` | n/a | yes |
| layers | n/a | `list(string)` | `null` | no |
| memory\_size | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. | `number` | `128` | no |
| output\_file\_path | n/a | `any` | n/a | yes |
| performance\_mode | The performance mode of your file system. | `string` | `"generalPurpose"` | no |
| prjid | (Required) name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| profile\_to\_use | Getting values from ~/.aws/credentials | `string` | `"default"` | no |
| reserved\_concurrent\_executions | n/a | `number` | `null` | no |
| role | IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. | `any` | n/a | yes |
| runtime | See Runtimes for valid values. | `string` | `""` | no |
| source\_file | n/a | `any` | n/a | yes |
| teamid | (Required) name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| timeout | The amount of time your Lambda Function has to run in seconds. Defaults to 3. | `number` | `30` | no |
| tracing\_config | n/a | <pre>object({<br>    mode = string<br>  })</pre> | <pre>{<br>  "mode": "PassThrough"<br>}</pre> | no |
| vpc\_config | n/a | <pre>object({<br>    security_group_ids = list(string)<br>    subnet_ids         = list(string)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| input\_file\_name | Source code location |
| lambda\_arn | ARN of the Lambda function |
| lambda\_role | IAM role used by Lambda function |
| output\_file\_path | Output filepath location |
| output\_file\_size | Output filepath size |

