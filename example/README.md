## lambda module usage

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | n/a | `any` | n/a | yes |
| archive\_type | type of file | `string` | `"zip"` | no |
| aws\_region | n/a | `string` | `"us-west-2"` | no |
| description | (Optional) Description of what your Lambda Function does. | `string` | `""` | no |
| email | email address to be used for tagging (suggestion: use group email address) | `any` | n/a | yes |
| environment\_vars | n/a | `map` | `{}` | no |
| handler | (Required) The function entrypoint in your code. | `any` | n/a | yes |
| memory\_size | (Optional) Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. | `number` | `128` | no |
| output\_file\_path | location of the output zip file | `any` | n/a | yes |
| performance\_mode | (Optional) The performance mode of your file system. | `string` | `"generalPurpose"` | no |
| prjid | (Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| profile\_to\_use | Getting values from ~/.aws/credentials | `any` | n/a | yes |
| role | (Required) IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. | `any` | n/a | yes |
| runtime | (Required) See Runtimes for valid values. | `string` | `""` | no |
| source\_file | source of the file to zip | `any` | n/a | yes |
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

