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
