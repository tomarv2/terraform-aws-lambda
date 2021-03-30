package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test Terraform module using Terratest.
func TestTerraformAwsLambda(t *testing.T) {
	t.Parallel()
	// ----------------------------------------------------------
    // TF_VARS_FILE_PATH       := "test.tfvars"
	TF_REPO_PATH            := "../examples/lambda_without_event-test"
	functionName            := "rumse-demo-lambda"
	teamid                  := "rumse"
	prjid                   := "demo-lambda"
	awsRegion               := aws.GetRandomStableRegion(t, nil, nil)
    // --------------------------------------------------------
	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	terraformOptions := &terraform.Options{
		TerraformDir: TF_REPO_PATH,
 		// Variables to pass to our Terraform code using -var-file options
 		// VarFiles: []string{TF_VARS_FILE_PATH},

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
		"aws_region": awsRegion,
			"teamid": teamid,
			"prjid": prjid,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Invoke the function, so we can test its output
	response := aws.InvokeFunction(t, awsRegion, functionName, LambdaFunctionPayload{ShouldFail: false, Echo: "hi!"})

	// This function just echos it's input as a JSON string when `ShouldFail` is `false``
	assert.Equal(t, `"hi!"`, string(response))
}

type LambdaFunctionPayload struct {
	Echo       string
	ShouldFail bool
}