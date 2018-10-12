# Base Jenkins X IBM Cloud environment

```
# An IKS 1.10 cluster must be used, 1.11 was broken with jenkins-x at the time of writing
curl -sL https://ibm.biz/idt-installer | bash
# These should be installed already but just in case...
ibmcloud plugin install container-service
ibmcloud plugin install container-registry

# install latest helm -> https://docs.helm.sh/using_helm/#installing-helm
# install kubectl 1.10 -> https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-using-curl
# install jx -> https://jenkins-x.io/getting-started/install/

ibmcloud login -a https://api.us-east.bluemix.net (--sso / --apikey as appropriate)
# paygo account with write access to cluster being targetted (can be a trial but not a free cluster, won't work)

# Find a region
ibmcloud ks regions

# Set the region ex. us-east
ibmcloud ks region-set us-east

# Find a zone (eg. wdc07)
ibmcloud ks zones

# Find machine types (should use b2c.4x16 minimum) 
ibmcloud ks machine-types --zone wdc07

#Find the 1.10.x version
ibmcloud ks kube-versions

#Find the Public and private vlans (if none exist, they will be created)
ibmcloud ks vlans --zone wdc07

# create command. If vlans exist in the zone, they will need to be specified here otherwise they will be created
# If you want to use let's encrypt make sure to specify a cluster name so that docker-registry.jx.<clustername>.<regionname>.containers.appdomain.cloud is less than 64 characters
# ex. docker-registry.jx.jx-wdc07.us-east.container.appdomain.cloud < 64 chars
# (Smallest possible is best)
ibmcloud ks cluster-create --name jx-wdc07 --kube-version 1.10.8 --zone wdc07 --machine-type b2c.4x16 --workers 3 --hardware shared [--private-vlan 2323675 --public-vlan 2323691]

# Check until state is "normal (takes about 15 minutes)
ibmcloud ks cluster-get jx-wdc07

# target cluster
$(ibmcloud ks cluster-config --export jx-wdc07)

# Install block storage drivers
helm init
helm repo add ibm  https://registry.bluemix.net/helm/ibm
helm repo update
helm install ibm/ibmcloud-block-storage-plugin --name ibmcloud-block-storage-plugin
# Make block default
kubectl patch storageclass ibmc-file-bronze -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
# you can also choose ibmc-block-silver or ibmc-block-gold for better IOPS
kubectl patch storageclass ibmc-block-bronze -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# This is if you want https (recommended) There is also a jenkins- addon, may work but never tested with IBM Cloud
# <https>
helm install --namespace=kube-system --name=cert-manager stable/cert-manager --set=ingressShim.defaultIssuerKind=ClusterIssuer --set=ingressShim.defaultIssuerName=letsencrypt-staging
cat << EOF| kubectl create -n kube-system -f -
apiVersion: certmanager.k8s.io/v1alpha1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: YOUREEMAIL@ca.ibm.com
    privateKeySecretRef:
      name: letsencrypt-staging
    http01: {}
EOF
# </https>

# you will need a github user and token and your cluster subdomain for the domain flag (example provided), answer Y to create ingress when asked. Choose IBM provider
# specify --http=false --tls-acme=true if you have configured https
jx install --default-admin-password=<password> --no-default-environments=true --docker-registry='registry.ng.bluemix.net' --domain='jx-wdc07.us-east.containers.appdomain.cloud' --provider='ibm' [--http=false --tls-acme=true ]

# wait until done. can check status by doing kubectl get deployments,services,pvc,pv,ingress -n jx in another terminal

# Make sure you can push and pull images into the account you do this in:
ibmcloud cr token-add --non-expiring --readwrite --description "Jenkins-X Token"

# Copy the "Token"
echo -n token:<Token here> | base64 -w0

# Copy the base64 value and create a file call config.json with this contents:
{
  "auths": {
    "registry.ng.bluemix.net": {
      "auth": "<base64 encoded token>"
    }
  }
}

kubectl delete secret jenkins-docker-cfg -n jx
kubectl create secret generic jenkins-docker-cfg --from-file=./config.json -n jx

# At this point the jenkins server needs to restarted to pick up the new docker creds
kubectl -njx delete pods -lapp=jenkins

# If you want to use git.ng.bluemix.net (gitlab), create a personal access token there
jx create git server gitlab https://git.ng.bluemix.net -n gitlab
jx create git token -n gitlab -t <gitlab token> <gitlab username> 
```
