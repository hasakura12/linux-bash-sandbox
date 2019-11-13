#!/usr/bin/env bash
# (set -o igncr) 2>/dev/null && set -o igncr;
# set -o errexit  # Exit if a command fails
# set -o pipefail # Exit if one command in a pipeline fails
# set -o nounset  # Treat unset variables and parameters as errors
# set -o xtrace   # Print a trace of simple commands

# Function: print usage
function usage {
	>&2 echo "
    What is this:
      Scrip to set environment variables for AWS credentials

    Pre-conditions: 
        1. AWS profile is set in ~/.aws/config
        2. AWS CLI is configured 

    Usage:
    $0 AWS_PROFILE_NAME 
    AWS_PROFILE_NAME  - the name used to store AWS credentials in ~/.aws/config
    
    Examples:
    $0 cr-labs-YOUR-NAME
	"
}

function aws_role() {
  if [ $# -lt 1 ]; then
        usage; return 1
  fi

  for (( i=0; i<3; i++ )); do echo "hello $i"; done;

  local aws_profile_name="${1?AWS profile name is required}"

  if ! fgrep -q "[profile $aws_profile_name]" ~/.aws/config; then
      >&2 printf "\nNo such profile"
  else
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset PROMPT_AWS_STS_PROFILE

    local role_session_name="assumed-role-session"
    local tmp_file=".temp_credentials"

    local role_arn=$(awk "/\[profile\ $1\]/,/^\$/ { if (\$1 == \"role_arn\") { print \$3 }}" ~/.aws/config)

    >&2 printf "Role to assume is ${role_arn}\n"

    aws sts assume-role --output json --role-arn "${role_arn}" --role-session-name "${role_session_name}" > "${tmp_file}"

    local access_key=$(cat ${tmp_file} | jq -r ".Credentials.AccessKeyId")
    local secret_key=$(cat ${tmp_file} | jq -r ".Credentials.SecretAccessKey")
    local session_token=$(cat ${tmp_file} | jq -r ".Credentials.SessionToken")
    local expiration=$(cat ${tmp_file} | jq -r ".Credentials.Expiration")

    >&2 printf "\nRetrieved temp access key ${access_key} for role ${role_arn}. Key will expire at ${expiration}\n"

    export AWS_ACCESS_KEY_ID="${access_key}"
    export AWS_SECRET_ACCESS_KEY="${secret_key}"
    export AWS_SESSION_TOKEN="${session_token}"
    export PROMPT_AWS_STS_PROFILE="${aws_profile_name}"

    >&2 printf "\nPrinting AWS-related envs set in the current shell...\n"
    env | grep AWS
    
    rm "${tmp_file}"
  fi
}

# Start the main function
aws_role "$@"
