# Astronomer Cloud Dev 
This terraform uses https://github.com/astronomer/terraform/tree/master/gcp as terraform module to create Private K8s cluster, Cloud SQL with Postgres in `astronomer-cloud-dev-236021` GCP Project.


## Steps

1. Get the latest terraform module:

    ```bash
    terraform get -update
    ```
    This will download the module to `.terraform` directory in the current folder.

1. Initialise terraform:
    
    ```bash
    terraform init
    ```
	
1. Check what the infrastructure changes would be made:

    ```bash
    terraform plan
    ```
	
1. Run the terraform files:

    ```bash
    terraform apply
    ```

## Access Kubernetes Cluster

1. SSH into Bastion using IAP:

    ```bash
    gcloud beta compute ssh bastion --project astronomer-cloud-dev-236021 --tunnel-through-iap
    ```
  
1. Generate Kubeconfig entry to connect to k8s cluster:

    ```bash
    gcloud beta container clusters get-credentials cloud-dev-cluster --region us-east4 --project astronomer-cloud-dev-236021 --internal-ip
    ```
    
    Make sure that `--internal-ip` is passed to the command.
    
1. Test `kubectl` command:

    ```bash
    kubectl get po --all-namespaces
    ```
