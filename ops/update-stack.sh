#!/bin/bash

set -e

aws cloudformation update-stack \
  --stack-name poc-cf-packer-asg \
  --template-body file://./ops/codebuild-asg-stack.yml \
  --capabilities CAPABILITY_IAM
