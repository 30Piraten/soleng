package main

import (
	"github.com/aws/aws-cdk-go/awscdk"
	"github.com/aws/aws-cdk-go/awscdk/awslambda"
	"github.com/aws/aws-cdk-go/awscdk/awssecretsmanager"
	"github.com/aws/aws-cdk-go/awscdk/awssqs"
	"github.com/aws/jsii-runtime-go"
)

func createLambdaFunction(stack awscdk.Stack, token awssecretsmanager.ISecret, dlq awssqs.IQueue) *awslambda.FunctionProps {
	return &awslambda.FunctionProps{
		Runtime:         awslambda.Runtime_PROVIDED_AL2,
		Handler:         jsii.String("bootstrap"),
		MemorySize:      jsii.Number(1024),
		Timeout:         awscdk.Duration_Minutes(jsii.Number(6)),
		Architecture:    awslambda.Architecture_X86_64(),
		DeadLetterQueue: dlq,
		Code:            awslambda.Code_FromAsset(jsii.String("lambdaDir")),
		Tracing:         awslambda.Tracing_ACTIVE,
		Environment: &map[string]*string{
			"SECRET_ARN": token.SecretArn(),
		},
	}
}
