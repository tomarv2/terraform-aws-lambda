<p align="center">
    <a href="https://github.com/tomarv2/terraform-aws-lambda/actions/workflows/unit_test.yml" alt="GitHub tag">
        <img src="https://github.com/tomarv2/terraform-aws-lambda/actions/workflows/unit_test.yml/badge.svg?branch=main" /></a>
    <a href="https://www.apache.org/licenses/LICENSE-2.0" alt="GitHub tag">
        <img src="https://img.shields.io/github/license/tomarv2/terraform-azure-role-assignment" /></a>
    <a href="https://github.com/tomarv2/terraform-azure-role-assignment/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-azure-role-assignment" /></a>
    <a href="https://github.com/tomarv2/terraform-azure-role-assignment/pulse" alt="Activity">
        <img src="https://img.shields.io/github/commit-activity/m/tomarv2/terraform-azure-role-assignment" /></a>
    <a href="https://stackoverflow.com/users/6679867/tomarv2" alt="Stack Exchange reputation">
        <img src="https://img.shields.io/stackexchange/stackoverflow/r/6679867"></a>
    <a href="https://discord.gg/XH975bzN" alt="chat on Discord">
        <img src="https://img.shields.io/discord/813961944443912223?logo=discord"></a>
    <a href="https://twitter.com/intent/follow?screen_name=varuntomar2019" alt="follow on Twitter">
        <img src="https://img.shields.io/twitter/follow/varuntomar2019?style=social&logo=twitter"></a>
</p>

## Terraform module to create AWS Lambda

### Security & Compliance: [BridgeCrew](https://bridgecrew.io/)

Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

| Benchmark | Description |
|--------|---------------|
| [![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/tomarv2/terraform-aws-lambda/general)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=tomarv2%2Fterraform-aws-lambda&benchmark=INFRASTRUCTURE+SECURITY) | Infrastructure Security Compliance |
| [![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/tomarv2/terraform-aws-lambda/cis_kubernetes)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=tomarv2%2Fterraform-aws-lambda&benchmark=CIS+KUBERNETES+V1.5)| Center for Internet Security, KUBERNETES Compliance |
| [![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/tomarv2/terraform-aws-lambda/cis_aws)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=tomarv2%2Fterraform-aws-lambda&benchmark=CIS+AWS+V1.2) | Center for Internet Security, AWS Compliance |
| [![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/tomarv2/terraform-aws-lambda/cis_azure)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=tomarv2%2Fterraform-aws-lambda&benchmark=CIS+AZURE+V1.1) | Center for Internet Security, AZURE Compliance |
| [![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/tomarv2/terraform-aws-lambda/pci)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=tomarv2%2Fterraform-aws-lambda&benchmark=PCI-DSS+V3.2) | Payment Card Industry Data Security Standards Compliance |
| [![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/tomarv2/terraform-aws-lambda/nist)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=tomarv2%2Fterraform-aws-lambda&benchmark=NIST-800-53) | National Institute of Standards and Technology Compliance |
| [![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/tomarv2/terraform-aws-lambda/iso)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=tomarv2%2Fterraform-aws-lambda&benchmark=ISO27001) | Information Security Management System, ISO/IEC 27001 Compliance |
| [![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/tomarv2/terraform-aws-lambda/soc2)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=tomarv2%2Fterraform-aws-lambda&benchmark=SOC2)| Service Organization Control 2 Compliance |
| [![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/tomarv2/terraform-aws-lambda/cis_gcp)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=tomarv2%2Fterraform-aws-lambda&benchmark=CIS+GCP+V1.1) | Center for Internet Security, GCP Compliance |
| [![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/tomarv2/terraform-aws-lambda/hipaa)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=tomarv2%2Fterraform-aws-lambda&benchmark=HIPAA) | Health Insurance Portability and Accountability Compliance |

## Versions

- Module tested for Terraform 0.14.
- AWS provider version [3.29.0](https://registry.terraform.io/providers/hashicorp/aws/latest)
- `main` branch: Provider versions not pinned to keep up with Terraform releases
- `tags` releases: Tags are pinned with versions (use latest     
        <a href="https://github.com/tomarv2/terraform-azure-role-assignment/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-azure-role-assignment" /></a>
  in your releases)

**NOTE:** 

- Read more on [tfremote](https://github.com/tomarv2/tfremote)

## Usage

Recommended method:

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
export PATH=$PATH:/usr/local/bin/
```  

- Update:
```
example/custom/sample.tfvars
```

- Change to: 
```
example/base
``` 

- Run and verify the output before deploying:
```
tf -cloud aws plan -var-file <path to .tfvars file>
```

- Run below to deploy:
```
tf -cloud aws apply -var-file <path to .tfvars file>
```

- Run below to destroy:
```
tf -cloud aws destroy -var-file <path to .tfvars file>
```

Please refer to example directory [link](example/README.md) for references.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | n/a | `any` | n/a | yes |
| archive\_type | n/a | `string` | `"zip"` | no |
| aws\_region | n/a | `string` | `"us-west-2"` | no |
| description | (Optional) Description of what your Lambda Function does. | `string` | `""` | no |
| email | email address to be used for tagging (suggestion: use group email address) | `any` | n/a | yes |
| environment\_vars | n/a | `map` | <pre>{<br>  "NO_ADDITIONAL_BUILD_VARS": "TRUE"<br>}</pre> | no |
| handler | (Required) The function entrypoint in your code. | `any` | n/a | yes |
| memory\_size | (Optional) Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. | `number` | `128` | no |
| output\_file\_path | n/a | `any` | n/a | yes |
| performance\_mode | (Optional) The performance mode of your file system. | `string` | `"generalPurpose"` | no |
| prjid | (Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| profile\_to\_use | Getting values from ~/.aws/credentials | `any` | n/a | yes |
| role | (Required) IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. | `any` | n/a | yes |
| runtime | (Required) See Runtimes for valid values. | `string` | `""` | no |
| source\_file | n/a | `any` | n/a | yes |
| teamid | (Required) Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| timeout | (Optional) The amount of time your Lambda Function has to run in seconds. Defaults to 3. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| input\_file\_name | Source code location |
| lambda\_arn | ARN of the Lambda function |
| lambda\_role | IAM role used by Lambda function |
| output\_file\_path | Output filepath location |
| output\_file\_size | Output filepath size |

