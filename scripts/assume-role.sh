#!/bin/bash
set -e
ROLE_TO_ASSUME=$1
ASSUME_OUTPUT=$(aws sts assume-role \
  --role-arn "${ROLE_TO_ASSUME}" \
  --role-session-name ci-assume-role \
  --duration-seconds 1200)
AWS_ACCESS_KEY_ID=$(echo "${ASSUME_OUTPUT}" | jq .Credentials.AccessKeyId -r)
AWS_SECRET_ACCESS_KEY=$(echo "${ASSUME_OUTPUT}" | jq .Credentials.SecretAccessKey -r)
AWS_SESSION_TOKEN=$(echo "${ASSUME_OUTPUT}" | jq .Credentials.SessionToken -r)
# Ensure the keys don't get printed to logs
echo ::add-mask::"${AWS_ACCESS_KEY_ID}"
echo ::add-mask::"${AWS_SECRET_ACCESS_KEY}"
echo ::add-mask::"${AWS_SESSION_TOKEN}"
# Export to environment
echo ::set-env name=AWS_ACCESS_KEY_ID::"${AWS_ACCESS_KEY_ID}"
echo ::set-env name=AWS_SECRET_ACCESS_KEY::"${AWS_SECRET_ACCESS_KEY}"
echo ::set-env name=AWS_SESSION_TOKEN::"${AWS_SESSION_TOKEN}"
