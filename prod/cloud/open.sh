gcloud container clusters update prod-cluster --enable-master-authorized-networks --master-authorized-networks="$(curl icanhazip.com)/32" --zone=us-east4 --project=astronomer-cloud-prod
