# Astronomer Cloud Dev 
This terraform uses https://github.com/astronomer/terraform/tree/master/gcp as terraform module to create Private K8s cluster, Cloud SQL with Postgres in `astronomer-cloud-dev-236021` GCP Project.


## Steps

1. Set Google application default credentials:
    ```bash
    gcloud auth application-default login
    ```

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

1. In order to access the k8s cluster as an admin:
    
    * Run the following command
     
      ```bash
      gcloud auth login
      ```
    
    * To authenticate with the cluster: 
      
      ```bash
      gcloud beta container clusters get-credentials cloud-dev-cluster --region us-east4 --project astronomer-cloud-dev-236021 --internal-ip
      ```
      
    * Test it using the following command:
    
      ```bash
      kubectl create ns astronomer
      ```

    To run Admin commands on the k8s cluster, the user needs to be listed in `bastion_admins` terraform variable as `bastion_admins` get [**Container Admin**](https://cloud.google.com/kubernetes-engine/docs/how-to/iam#kubernetes-engine-roles) permissions (`roles/container.admin`).
