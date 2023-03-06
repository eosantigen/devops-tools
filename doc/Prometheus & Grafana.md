# Version
2.31.1

# Queries
We use the Dashboard Variables on queries inside the Dashboard's Panels.

## Pod Resources
### Dashboard Variables

**namespace**

`label_values(kube_pod_info, exported_namespace)`

**pod**

`label_values(kube_pod_info{exported_namespace=~"$namespace"}, pod)`

**container**

`label_values(kube_pod_container_info{exported_namespace="$namespace", pod="$pod"}, container)`

### Dashboard Queries
#### Pod CPU Usage (rate)
`sum(rate(container_cpu_usage_seconds_total{pod="$pod", container="$container",pod!="POD", pod!="", image!=""}[3m]))`

#### Pod Memory Usage (sum)
`container_memory_working_set_bytes{pod="$pod", container="$container", container!="POD", pod!="", image!=""}`
`container_memory_usage_bytes{pod="$pod", container="$container", container!="POD", pod!="", image!=""}`
`kube_pod_container_resource_limits{pod="$pod", container="$container", resource="memory"}`

#### Pod Network Usage
`rate(container_network_receive_bytes_total{pod="$pod"}[3m])`
`rate(container_network_transmit_bytes_total{pod="$pod"}[3m])`

## Worker Node Resources
### Dashboard Variables

**node**

`label_values(node)`
### Dashboard Queries
#### Pods Running on Node (Table)
`sum(kube_pod_info{exported_node="$node", exported_namespace=~"kafka-operator|postgresql"}) by (pod)`
#### Memory Used (Percentage in Gauge)
`100 * ((node_memory_Active_bytes{node="$node"}) / node_memory_MemTotal_bytes{node="$node"})`
#### CPU Load 15m (Percentage in Gauge)
`100*(sum(node_load15{node="$node"}) by (node) / count(node_cpu_seconds_total{mode="system"}) by (node))`
_(Given that we have unequal number of cores across nodes.)_
#### Root (base host) FS Used (Percentage in Gauge)
`(node_filesystem_avail_bytes{node="$node",mountpoint="/"} * 100) / node_filesystem_size_bytes{node="$node",mountpoint="/"}`

#### Disk Space Available (Percentage in Time Series)
`node_filesystem_avail_bytes{node="$node", fstype="ext4"} / node_filesystem_size_bytes{node="$node", fstype="ext4"} * 100`
#### CPU Usage per Pod per Node (Rate of Sum in Time Series)
`sum(rate(container_cpu_usage_seconds_total{kubernetes_io_hostname="$node", namespace=~"kafka-operator|monitoring", pod!="", container!="POD", image!=""}[3m])) by (pod)`

# Custom Job Config

```yaml
extraScrapeConfigs: |

# - job_name: 'prometheus-blackbox-exporter'
# metrics_path: /probe
# params:
# module: [http_2xx]
# static_configs:
# - targets:
# - https://example.com
# relabel_configs:
# - source_labels: [__address__]
# target_label: __param_target
# - source_labels: [__param_target]
# target_label: instance
# - target_label: __address__
# replacement: prometheus-blackbox-exporter:9115

# CUSTOM - BEGIN

- job_name: 'micrometer'
  metrics_path: /prometheus
  kubernetes_sd_configs:
  - role: pod
  relabel_configs:
  - source_labels: [__meta_kubernetes_pod_name]
    action: replace
    target_label: instance
  - source_labels: [__meta_kubernetes_pod_label_app]
    action: replace
    target_label: job
  - source_labels: [__meta_kubernetes_pod_label_app]
    action: keep
    regex: .*lol-svc|.*my-svc|.*applol

oauth2:
  client_id: 
  client_secret_file: /secrets/client_secret
  token_url:

# CUSTOM - END
```

# Alerts on new Grafana

## Contact Points : Template
```
{{ define "MYTEMPLATE" }}
{{ range .Alerts }}
	{{ range .Annotations.SortedPairs }}
		{{ .Value }}
		{{end}}
	{{end}}
{{end}}
```

## Queries

### Example: Alerting for a node CPU load over a variable number of CPU spec

1. Add a query like : `sum(node_load15{}) by (node) / count(node_cpu_seconds_total{mode="system"}) by (node)`
_given that we have unequal number of cores across nodes._
2. If its reduseable, reduce it to dropping non-numeric values
3. Add a third expression of type Math where you add the output of (2) into a comparison operator of your choice, e.g. `$B > 1` .
4. Then the Summary textfield would contain: Node => `{{ $labels.node }}` - CPU Load => `{{ $values.B.Value }}`