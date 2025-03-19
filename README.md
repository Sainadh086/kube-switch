# KS 

### Getting started with ks cli
    copy the ks to /usr/local/bin/
    cmd:
        - sudo cp ks /opt/homebrew/bin/ks
    requirements:
        - pip install PyYAML

    Add the below lines in .zshrc file

    ---
    k1=$(kubectl config current-context | awk -F'/' '{print $2}')
    PROMPT2=$PROMPT
    PROMPT='$(echo $k1)'$PROMPT2
    ---


### Switch between EKS clusters

    - ks <clustername> 
    example:
    - ks ipm
    it will list all the clusters with novartis name from your kubeconfig

### update the kubeconfig
    - ks update -n <fullname of the EKS> -r <region> -p <aws-profile>
    example:
    - ks update -n ap-southeast-1-eks-cluster -r ap-southeast-1 -p solstage
    note: by default -r is us-west-1

### list the EKS clusters
    - ks list -r <region> -p <aws-profile>
    example:
    - ks list -r ap-southeast-1-eks-cluster -p solstage

### view the current EKS cluster
    - ks current

### sync the aws credentials
    - ks sync

### ks neat to remove the unwanted fields from k8s manifest files
    - kubectl get deploy nginx -oyaml | ks neat

### ks decrypt can be used to decrypt the secrets in kubernetes secrets
    - kubectl get -n spark-jobs secrets common-secret -oyaml | ks decyrpt

### ks apply can be used to create/update secretmanager and route53
    - ks apply -f <filename>
    Examples are available in examples folder

### ks generate -> it will fetch kafka certs from the cluster
    - ks generate
    By default it will take kafka namespace, if you want to specify specific namespace
    - ks generate -n kafka-qa