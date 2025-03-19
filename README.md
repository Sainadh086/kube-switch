# KS 

### Getting started with ks cli
    Install ks cli with below commands
    cmd:
        - git clone <repoUrl>
        - cd kube-switch
        - bash install.sh
    requirements:
        - pip install PyYAML

    To see your EKS cluster names in cli, you can add the below lines to .bashrc file.
    ---
    k1=$(kubectl config current-context | awk -F'/' '{print $2}')
    PROMPT2=$PROMPT
    PROMPT='$(echo $k1)'$PROMPT2
    ---
    Note:- This cli only runs on Linux and MacOS, please post the bugs on github issues.


### Switch between EKS clusters

    - ks <clustername> 
    example:
    - ks ipm
    it will list all the clusters with novartis name from your kubeconfig

### update the kubeconfig
    - ks update -n <fullname of the EKS> -r <region> -p <aws-profile>
    example:
    - ks update -n ap-southeast-1-eks-cluster -r ap-southeast-1 -p dev
    note: by default -r is us-west-1

### list the EKS clusters
    - ks list -r <region> -p <aws-profile>
    example:
    - ks list -r ap-southeast-1-eks-cluster -p dev

### view the current EKS cluster
    - ks current

### ks neat to remove the unwanted fields from k8s manifest files
    - kubectl get deploy nginx -oyaml | ks neat

### ks decrypt can be used to decrypt the secrets in kubernetes secrets
    - kubectl get -n spark-jobs secrets common-secret -oyaml | ks decyrpt
