# Installation
```
helm repo add influxdata https://helm.influxdata.com/  -n monitoring

helm -n monitoring upgrade --install influxdb \
     --set image.tag=1.7.6-alpine \
     --set persistence.enabled=true \
     --set persistence.size=40Gi \
     --set persistence.storageClass="managed-hdd" \
     --set 'env[0].name=INFLUXDB_DATA_MAX_VALUES_PER_TAG' \
     --set-string "env[0].value=1000000" \
     influxdata/influxdb
```

# Settings
Exec into pod and do:
```
influx -host localhost  -username root
use k8s
```
Modify Retention Policy
1. `alter retention policy "default" on k8s duration 10d replication 1 shard duration 1d default`
2. `show retention policies`

## Dropping a Tag
Dropping a measurement or series is easy:
`DROP MEASUREMENT <measurement_name>`

Drops a series with a specific tag from a single measurement:
`DROP SERIES FROM <measurement_name> WHERE <tag_key>='<tag_value>'` 

The `DELETE` query deletes all points from a series in a database, but does not drop the series from the index.  It supports time intervals in the `WHERE` clause.

# Used as a Heapster sink

Installed from https://github.com/helm/charts/tree/master/stable/heapster

`helm install stable/heapster --name heapster --set eventer.enabled=true --set service.name=heapster -n monitoring` . 
It has been edited on the fly to contain the following, however, however, make sure the **values.yaml** contains the following:

```yaml
eventer:
  enabled: true
  flags:
  - "--source=kubernetes:https://kubernetes.default"
  - "--sink=influxdb:http://influxdb.monitoring:8086?withfields=true"

command:
- "/heapster"
- "--source=kubernetes.summary_api:https://kubernetes.default?useServiceAccount=t
rue&kubeletHttps=true&kubeletPort=10250&insecure=true"
```

# Notes
It has occurred sometimes that the db gets some kind of overload regarding the acceptance of some entries which seem to be too large, judging by Heapster logs, and thus Heapster fails to flush events into it. You can tell this is happening if the Events dashboard in Grafana returns empty. Although retention is in place, as a workaround, occassionally also dropping measurement events from k8s db helps: `drop measurement "events"`