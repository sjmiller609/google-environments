#!/bin/bash

cd $DIRECTORY

echo $GOOGLE_CREDENTIAL_FILE_CONTENT > /tmp/account.json

set -xe

ls /tmp | grep account

export GOOGLE_APPLICATION_CREDENTIALS='/tmp/account.json'
export TF_IN_AUTOMATION=true

terraform -v

terraform init

# TODO: add to CI image
apk add --update  python  curl  which  bash jq
curl -sSL https://sdk.cloud.google.com > /tmp/gcl
bash /tmp/gcl --install-dir=~/gcloud --disable-prompts > /dev/null 2>&1
PATH=$PATH:/root/gcloud/google-cloud-sdk/bin

# Set up gcloud CLI
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
gcloud config set project $PROJECT

PLAN_FILE="tfplan"

# If the cluster already exists, then we need
# to set up some things in the local environment.
# The block below is executed except for on the first
# run of this environment.

# get list of clusters
CLUSTERS="$(gcloud container clusters list --format="value(name)" | tr '\r\n' ' ')"
KUBECONFIG_VAR_LINE=""
if [[ "$CLUSTERS" == *$DEPLOYMENT_ID-cluster* ]]; then

  # whitelist our current IP for kube management API
  gcloud container clusters update $DEPLOYMENT_ID-cluster --enable-master-authorized-networks --master-authorized-networks="$(curl icanhazip.com)/32" --zone=us-east4
  
  # copy the kubeconfig from the terraform state
  terraform state pull | jq -r '.resources[] | select(.module == "module.astronomer_cloud") | select(.name == "kubeconfig") | .instances[0].attributes.content' > kubeconfig
  chmod 755 kubeconfig
  KUBECONFIG_VAR_LINE="-var kubeconfig_path=$(pwd)/kubeconfig"

fi

if [ $TF_DESTROY ]; then

  if [ ! $TF_AUTO_APPROVE ]; then
    echo "ERROR: will not destroy without TF_AUTO_APPROVE set"
    exit 1
  fi

  # delete everything from kube
  helm init --client-only
  helm del $(helm ls --all --short) --purge

  # this command is blocking
  kubectl delete namespace astronomer -wait=true

  # remove the stuff we just delete from kube from the tf state
  terraform state rm module.astronomer_cloud.module.astronomer
  terraform state rm module.astronomer_cloud.module.system_components

  # this resource should be ignored on destroy
  # remove it from the state to accomplish this
  terraform state rm module.astronomer_cloud.module.gcp.google_sql_user.airflow

  terraform destroy \
    -var "deployment_id=$DEPLOYMENT_ID" \
    -var "base_domain=$BASE_DOMAIN" \
    -lock=false \
    -input=false \
    $KUBECONFIG_VAR_LINE
    --auto-approve

  exit 0
fi

if [ $TF_TWO_STEP_APPLY ]; then

  if [ ! $TF_AUTO_APPROVE ]; then
    echo "ERROR: will not two step apply without TF_AUTO_APPROVE set"
    exit 1
  fi

  terraform apply \
    -var "deployment_id=$DEPLOYMENT_ID" \
    -var "base_domain=$BASE_DOMAIN" \
    -lock=false \
    -input=false \
    $KUBECONFIG_VAR_LINE \
    --auto-approve \
    --target=module.astronomer_cloud.module.gcp

  terraform apply \
    -var "deployment_id=$DEPLOYMENT_ID" \
    -var "base_domain=$BASE_DOMAIN" \
    -lock=false \
    -input=false \
    $KUBECONFIG_VAR_LINE \
    --auto-approve

  exit 0
fi

STATE_BUCKET="astronomer-$DEPLOYMENT_ID-terraform-state"
# Do the plan step and quit
# if TF_PLAN is set.
# Otherwise, proceed to the apply step
if [ $TF_PLAN ]; then

	echo "\n Deleting old Terraform plan file"
	gsutil rm gs://${STATE_BUCKET}/ci/$PLAN_FILE || echo "\n An old state file does not exist in state bucket, proceeding..."

  terraform plan \
    -var "deployment_id=$DEPLOYMENT_ID" \
    -var "base_domain=$BASE_DOMAIN" \
    $KUBECONFIG_VAR_LINE \
    -lock=false \
    -input=false \
    -out=$PLAN_FILE

	gsutil cp $PLAN_FILE gs://${STATE_BUCKET}/ci/$PLAN_FILE
  echo "Plan file uploaded"
  exit 0

fi

if [ $TF_AUTO_APPROVE ]; then

  terraform apply \
    --auto-approve \
    -var "deployment_id=$DEPLOYMENT_ID" \
    -var "base_domain=$BASE_DOMAIN" \
    $KUBECONFIG_VAR_LINE \
    -lock=false \
    -input=false

  exit 0
fi

# apply using plan file
gsutil cp gs://${STATE_BUCKET}/ci/$PLAN_FILE $PLAN_FILE 
terraform apply \
  -lock=false \
  -input=false \
  $PLAN_FILE
