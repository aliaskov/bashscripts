#!/bin/bash

SELF=$(basename "$0")
OPTION=""

if [[ -z "$AWS_PROFILE" ]]; then
  echo "set your AWS_PROFILE to SSO_LOGIN"
  export AWS_PROFILE=SSO_LOGIN
  echo "please sso login!"
  echo "aws configure sso --profile SSO_LOGIN"
  exit 1
fi

function help() {
  echo """
    choose one of the following options: sshtunnel | sessionmanager

    usage: ${SELF}
      --sshtunnel         - uses ssh tunnel only (needs a public accessible ssh port opened)
      --sessionmanager    - uses ssh tunnel via sessionmanager websocket (does not need any public accessible port)
  """
}

function main() {

  if [[ "${OPTION}" == "" ]]; then
    help
    exit 1
  fi

  ssh-add -D
  SSH_KEY=$(mktemp key.XXXXXX)
  ssh-keygen -t rsa -f "$SSH_KEY" -N "" -q <<<y >/dev/null 2>&1
  trap "rm $SSH_KEY $SSH_KEY.pub" EXIT

  aws ec2-instance-connect send-ssh-public-key \
        --profile SSO_LOGIN \
        --region eu-central-1 \
        --instance-id i-0184585dfbeada713 \
        --availability-zone eu-central-1a \
        --instance-os-user ec2-user \
        --ssh-public-key "file://$SSH_KEY.pub"

  if [[ "${OPTION}" == "sshtunnel" ]]; then
    ssh -i "$SSH_KEY" ec2-user@3.71.44.62 -L 3307:rds-dms.cluster-cwdqrgvghbzj.eu-central-1.rds.amazonaws.com:3306
  elif [[ "${OPTION}" == "sessionmanager" ]]; then
    CONFIG=~/.ssh/config
    if [[ "$(grep i-0184585dfbeada713 $CONFIG)" == "" ]]; then
      cat << EOF >> ~/.ssh/config
Host i-0184585dfbeada713
  ProxyCommand sh -c "aws ssm start-session  --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p' --profile SSO_LOGIN --region eu-central-1"
EOF
    fi
    ssh -i "$SSH_KEY" ec2-user@i-0184585dfbeada713 -L 3307:rds-dms.cluster-cwdqrgvghbzj.eu-central-1.rds.amazonaws.com:3306
  fi

}

while true;
do
  case "$1" in
  -t|--sshtunnel)
    OPTION="sshtunnel"
    shift 2
    break
    ;;
  -s|--sessionmanager)
    OPTION="sessionmanager"
    shift 2
    break
    ;;
  --)
    shift;
    break
    ;;
  *)
    help
    exit 1
    ;;
  esac
done

main