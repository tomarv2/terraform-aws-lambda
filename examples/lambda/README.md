# lambda

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.74 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prjid"></a> [prjid](#input\_prjid) | Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `string` | `"demo"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to create resources | `string` | `"us-west-2"` | no |
| <a name="input_teamid"></a> [teamid](#input\_teamid) | Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply' | `string` | `"rumse"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_input_dir_name"></a> [input\_dir\_name](#output\_input\_dir\_name) | Source code location |
| <a name="output_input_file_name"></a> [input\_file\_name](#output\_input\_file\_name) | Source code location |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | ARN of the Lambda function |
| <a name="output_output_dir_path"></a> [output\_dir\_path](#output\_output\_dir\_path) | Output filepath location |
| <a name="output_output_dir_size"></a> [output\_dir\_size](#output\_output\_dir\_size) | Output filepath size |
| <a name="output_output_file_path"></a> [output\_file\_path](#output\_output\_file\_path) | Output filepath location |
| <a name="output_output_file_size"></a> [output\_file\_size](#output\_output\_file\_size) | Output filepath size |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
