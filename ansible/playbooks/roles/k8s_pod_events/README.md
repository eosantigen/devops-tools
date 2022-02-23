## INFO

Queries an InfluxDB used as sink from Heapster on a Kubernetes cluster, for entries of Pod events and sends alerts on a Slack channel.

This playbook can be built into a Docker image and executed as Cronjob in Kubernetes. The following must be added on the ContainerSpec:
```
command: ["ansible-playbook"]
args: ["play.yaml"]
```
The Dockerfile is in this repository, in ./docker/dockerfiles/Dockerfile_k8s_pod_events .
