#!/bin/bash

stack_name="poc-cf-packer-asg"

# default MaxClusterSize to be larger than ClusterSize
# this allows rolling updates to start booting new servers
# before stopping existing ones
if [ -z "${ClusterSize}" ]; then
    ClusterSize=1
fi
MaxClusterSize=$(($ClusterSize+4))

# build parameters
param_names=(Subnets VPC ClusterSize MaxClusterSize InstanceType AMI SSHKeyName AppVersion)
params=""
for p in "${param_names[@]}"
do
    val="${!p}"
    if [ -n "${val}" ]; then
        if [ "${p}" = "Subnets" ]; then
            val="\"${val}\""
        fi
        params="${params} ParameterKey=${p},ParameterValue=${val}"
    fi
done

# check if stack already exists
action="create-stack"
aws cloudformation describe-stacks --stack-name ${stack_name} > /dev/null
if [ $? -eq 0 ]; then
    action="update-stack"
fi

aws cloudformation ${action} \
  --stack-name poc-cf-packer-asg \
  --template-body file://./ops/codebuild-asg-stack.yml \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
  --parameters ${params}