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

# Terraform module to create [AWS Lambda](https://registry.terraform.io/modules/tomarv2/lambda/aws/latest)

## Versions

- Module tested for Terraform 1.0.1.
- AWS provider version [3.47.0](https://registry.terraform.io/providers/hashicorp/aws/latest).
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

#### Recommended method (stores remote state in S3 using `prjid` and `teamid` to create directory structure):

- Create python 3.6+ virtual environment
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

**NOTE:**

- Read more on [tfremote](https://github.com/tomarv2/tfremote)
---

### Lambda
```
module "lambda" {
  source = "git::git@github.com:tomarv2/terraform-aws-lambda.git"

  # --------------------------------------------------
  # NOTE: One of the below is required:
  # - existing `role`
  # - `profile_for_iam` and `policy_identifier` (to handle the case where deployment account does not have permission to manage IAM)
  role = "arn:aws:iam::123456789012:role/demo-role"
  #profile_for_iam = "iam-team"
  #policy_identifier      = ["events.amazonaws.com", "cloudwatch.amazonaws.com", "lambda.amazonaws.com"]

  # NOTE: One of the below is required:
  # - `source_file`
  # - `source_dir` and/or `exclude_files` and/or `runtime_dependencies`
  source_file      = "lambda_function.py"
  #source_dir           = "demo_lambda"
  #exclude_files        = ["exclude_file.txt"]
  #runtime_dependencies = false
  # --------------------------------------------------
  output_path          = "/tmp/test.zip"

  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"
  aws_region = "us-west-2"
  environment = {
    variables = {
      HELLO = "WORLD"
    }
  }
  # --------------------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
```

### Lambda(Cloudwatch trigger)
```
module "lambda" {
  source = "../../"

  # --------------------------------------------------
  # NOTE: One of the below is required:
  # - existing `role`
  # - `profile_for_iam` and `policy_identifier` (to handle the case where deployment account does not have permission to manage IAM)
  role = "arn:aws:iam::123456789012:role/demo-role"
  #profile_for_iam = "iam-admin"
  #policy_identifier      = ["events.amazonaws.com", "cloudwatch.amazonaws.com", "lambda.amazonaws.com"]

  # NOTE: One of the below is required:
  # - `source_file`
  # - `source_dir` and/or `exclude_files` and/or `runtime_dependencies`
  #source_file      = "lambda_function.py"
  source_dir           = "demo_lambda"
  exclude_files        = ["exclude_file.txt"]
  runtime_dependencies = true
  # --------------------------------------------------
  output_path = "/tmp/test.zip"

  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"
  environment = {
    variables = {
      HELLO = "WORLD"
    }
  }
  # --------------------------------------------------
  deploy_cloudwatch_event_trigger = true
  cloudwatch_event = {
    project-alpha = {
      description  = "alpha"
      schedule     = "rate(2 days)"
      custom_input = { "sourceVersion" = "main", "timeoutInMinutesOverride" = 66 }
      suffix       = "alpha"
    },
    project-beta = {
      description  = "beta"
      schedule     = "rate(3 days)"
      custom_input = { "sourceVersion" = "main", "timeoutInMinutesOverride" = 770 }
      suffix       = "beta"
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

  # --------------------------------------------------
  # NOTE: One of the below is required:
  # - existing `role`
  # - `profile_for_iam` and `policy_identifier` (to handle the case where deployment account does not have permission to manage IAM)
  role = "arn:aws:iam::123456789012:role/demo-role"
  #profile_for_iam = "iam-admin"
  #policy_identifier      = ["events.amazonaws.com", "cloudwatch.amazonaws.com", "lambda.amazonaws.com"]

  # NOTE: One of the below is required:
  # - `source_file`
  # - `source_dir` and/or `exclude_files` and/or `runtime_dependencies`
  #source_file      = "lambda_function.py"
  source_dir           = "demo_lambda"
  exclude_files        = ["exclude_file.txt"]
  runtime_dependencies = true
  # --------------------------------------------------
  output_path          = "/tmp/test.zip"

  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"
  environment = {
    variables = {
      HELLO = "WORLD"
    }
  }
  # --------------------------------------------------
  vpc_config = {
    subnet_ids         = module.global.list_of_subnets["755921336062"]["us-west-2"]
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
  aws_region = "us-west-2"
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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.47 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.47.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch"></a> [cloudwatch](#module\_cloudwatch) | git::git@github.com:tomarv2/terraform-aws-cloudwatch.git | v0.0.4 |
| <a name="module_cloudwatch_event"></a> [cloudwatch\_event](#module\_cloudwatch\_event) | git::git@github.com:tomarv2/terraform-aws-cloudwatch-event.git | v0.0.4 |
| <a name="module_iam_role"></a> [iam\_role](#module\_iam\_role) | git::git@github.com:tomarv2/terraform-aws-iam-role.git//modules/iam_role_instance | v0.0.4 |
| <a name="module_iam_role_existing"></a> [iam\_role\_existing](#module\_iam\_role\_existing) | git::git@github.com:tomarv2/terraform-aws-iam-role.git//modules/iam_role_instance | v0.0.4 |

## Resources

| Name | Type |
|------|------|
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [null_resource.install_python_dependencies](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [archive_file.zip_dir](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.zip_file](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_archive_type"></a> [archive\_type](#input\_archive\_type) | archive file type. | `string` | `"zip"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | aws region to deploy resources in. | `string` | `"us-west-2"` | no |
| <a name="input_cloudwatch_event"></a> [cloudwatch\_event](#input\_cloudwatch\_event) | Map of cloudwatch event configuration | `map(any)` | <pre>{<br>  "default": {}<br>}</pre> | no |
| <a name="input_cloudwatch_path"></a> [cloudwatch\_path](#input\_cloudwatch\_path) | name of the log group | `string` | `"/aws/lambda"` | no |
| <a name="input_dead_letter_config"></a> [dead\_letter\_config](#input\_dead\_letter\_config) | dead letter config. | <pre>object({<br>    target_arn = string<br>  })</pre> | `null` | no |
| <a name="input_dependencies_path"></a> [dependencies\_path](#input\_dependencies\_path) | Location of dependencies management script. | `string` | `null` | no |
| <a name="input_deploy"></a> [deploy](#input\_deploy) | Controls whether resources should be created | `bool` | `true` | no |
| <a name="input_deploy_cloudwatch_event_trigger"></a> [deploy\_cloudwatch\_event\_trigger](#input\_deploy\_cloudwatch\_event\_trigger) | deploy cloud watch event trigger | `bool` | `false` | no |
| <a name="input_deploy_function"></a> [deploy\_function](#input\_deploy\_function) | Controls whether Lambda Function resource should be created | `bool` | `true` | no |
| <a name="input_deploy_layer"></a> [deploy\_layer](#input\_deploy\_layer) | Controls whether Lambda Layer resource should be created | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of what your Lambda Function does. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | environment variables to pass to lambda. | <pre>object({<br>    variables = map(string)<br>  })</pre> | `null` | no |
| <a name="input_exclude_files"></a> [exclude\_files](#input\_exclude\_files) | file(s) to exclude in directory from zipping | `list(any)` | `null` | no |
| <a name="input_file_system_arn"></a> [file\_system\_arn](#input\_file\_system\_arn) | The Amazon Resource Name (ARN) of the Amazon EFS Access Point that provides access to the file system. | `string` | `null` | no |
| <a name="input_file_system_local_mount_path"></a> [file\_system\_local\_mount\_path](#input\_file\_system\_local\_mount\_path) | The path where the function can access the file system, starting with /mnt/. | `string` | `null` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | The function entrypoint in your code. | `string` | n/a | yes |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | The ECR image URI containing the function's deployment package. | `string` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of KMS key to use by your Lambda Function | `string` | `null` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | lambda layers. | `list(string)` | `null` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. | `number` | `128` | no |
| <a name="input_output_path"></a> [output\_path](#input\_output\_path) | output file path on local machine to deploy to lambda | `string` | n/a | yes |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | The Lambda deployment package type. Valid options: Zip or Image | `string` | `"Zip"` | no |
| <a name="input_policy_identifier"></a> [policy\_identifier](#input\_policy\_identifier) | iam policy identifier. | `list(string)` | <pre>[<br>  "lambda.amazonaws.com"<br>]</pre> | no |
| <a name="input_prjid"></a> [prjid](#input\_prjid) | (Required) name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `string` | n/a | yes |
| <a name="input_profile_for_iam"></a> [profile\_for\_iam](#input\_profile\_for\_iam) | profile to use for iam role creation. | `string` | `"default"` | no |
| <a name="input_profile_to_use"></a> [profile\_to\_use](#input\_profile\_to\_use) | Getting values from ~/.aws/credentials | `string` | `"default"` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | reserved concurrent execution. | `number` | `null` | no |
| <a name="input_role"></a> [role](#input\_role) | IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. | `string` | `null` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | See Runtimes for valid values. | `string` | `""` | no |
| <a name="input_runtime_dependencies"></a> [runtime\_dependencies](#input\_runtime\_dependencies) | feature flag install runtime dependencies. | `bool` | `false` | no |
| <a name="input_source_dir"></a> [source\_dir](#input\_source\_dir) | input directory path on local machine to zip | `string` | `null` | no |
| <a name="input_source_file"></a> [source\_file](#input\_source\_file) | input file path on local machine to zip | `string` | `null` | no |
| <a name="input_teamid"></a> [teamid](#input\_teamid) | (Required) name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply' | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds. Defaults to 3. | `number` | `30` | no |
| <a name="input_tracing_config"></a> [tracing\_config](#input\_tracing\_config) | Tracing config. | <pre>object({<br>    mode = string<br>  })</pre> | <pre>{<br>  "mode": "PassThrough"<br>}</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | vpc config. | <pre>object({<br>    security_group_ids = list(string)<br>    subnet_ids         = list(string)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_input_dir_name"></a> [input\_dir\_name](#output\_input\_dir\_name) | Source code location |
| <a name="output_input_file_name"></a> [input\_file\_name](#output\_input\_file\_name) | Source code location |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | ARN of the Lambda function |
| <a name="output_lambda_iam_role_arn"></a> [lambda\_iam\_role\_arn](#output\_lambda\_iam\_role\_arn) | ARN of IAM role used by Lambda function |
| <a name="output_output_dir_path"></a> [output\_dir\_path](#output\_output\_dir\_path) | Output dir path location |
| <a name="output_output_dir_size"></a> [output\_dir\_size](#output\_output\_dir\_size) | Output dir path size |
| <a name="output_output_file_path"></a> [output\_file\_path](#output\_output\_file\_path) | Output file path location |
| <a name="output_output_file_size"></a> [output\_file\_size](#output\_output\_file\_size) | Output file path size |
