package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// Test the Basic Network module
func TestTerraformAwsBasicNetwork(t *testing.T) {
	t.Parallel()

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	// awsRegion := "aws.GetRandomStableRegion(t, nil, nil)"

	// We will define the region the tests are to run in
	awsRegion := "ap-southeast-1"

	// Give the VPC and the subnets correct CIDRs
	vpcCidr := "10.168.0.0/16"
	publicSubnetCidr := "10.168.10.0/24"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"var_aws_core_vpc_cidr": vpcCidr,
			"var_aws_core_subnet_cidr1": publicSubnetCidr,
			"aws_region":            awsRegion,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	subnet1 := terraform.Output(t, terraformOptions, "subnet1_id")
	subnet2 := terraform.Output(t, terraformOptions, "subnet2_id")
	vpcId := terraform.Output(t, terraformOptions, "vpc_id")

	// Get subnets
	subnets := aws.GetSubnetsForVpc(t, vpcId, awsRegion)

	// Confirm that we have created 2 subnets only
	require.Equal(t, 2, len(subnets))

	// Verify if subnet1 is public
	assert.True(t, aws.IsPublicSubnet(t, subnet1, awsRegion))
	
	// Verify if subnet2 is private
	assert.False(t, aws.IsPublicSubnet(t, subnet2, awsRegion))
}