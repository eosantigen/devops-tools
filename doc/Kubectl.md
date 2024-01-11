#### Mass delete all pods in "Evicted"

```bash
kubectl delete pod `kubectl get pods | awk '$3 == "Evicted" {print $1}'`

kubectl delete pod -n kafka-operator `kubectl get pods -n kafka-operator | awk '$3 == "Evicted" {print $1}'`
```

#### Strip output of headers and count the entries and count them

`kubectl get nodes --no-headers | wc -l`

#### Grab kubectl server version on the fly
```bash
KUBECTL_STAGE_VERSION=$(kubectl version --context ${KUBECTL_STAGE_CONTEXT} -o json | jq -r '.serverVersion.gitVersion | sub("v"; "")')
```

#### Merge different kubectl configs

You cannot just use `cat >>` . Do as follows:
```bash
# Make a copy of your existing config 
cp ~/.kube/config ~/.kube/config.bak
# Merge the two config files together into a new config file 
KUBECONFIG=~/.kube/config:/path/to/new/config kubectl config view --flatten > /tmp/config
# Replace your old config with the new merged config 
mv /tmp/config ~/.kube/config
# (optional) Delete the backup once you confirm everything worked ok 
rm ~/.kube/config.bak
```
