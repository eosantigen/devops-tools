## Visualizing Logs in Kibana and Grafana

It’s convenient that all our services run on a UTC environment, so, both Kibana and Grafana must have set their timezone into UTC for proper rendering of the peculiar field `@timestamp` , which comes systemically defined into the data stream specification. _Otherwise, they render weird future dates_ .

The following snippets are fed into the console from Kibana Dev Tools panel.

## Rollover (data cleanup) Policy

Specifies a condition to delete data that is **either** of 15GB in size **or** of 120+1 days (4 months) of age. This has been noticed as sufficient for the attached data disk of 20GB size currently.

```
PUT /_ilm/policy/ret-s15-d120
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_size": "15GB",
            "max_age": "120d"
          }
        }
      },
      "delete": {
        "min_age": "1d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
```

### Attaching the rollover policy to a data stream

#### On the data stream creation (Recommended)

E.g , creating a data stream with the name of some service i.e “_example_cloud_service_”

```
PUT /_index_template/examplecloud_service
{
  "index_patterns": [ "example_cloud_service*" ],
  "data_stream": { },
  "priority": 150,
  "template": {
    "settings": {
      "index.lifecycle.name": "ret-s15-d120"
      }
   }
}
```

#### After the data stream creation

From Kibana go to Templates → Edit template _example_cloud_service_ ->
Index settings , and feed the following :

```
{
  "index": {
    "lifecycle": {
      "name": "ret-s15-d120"
    }
  }
}
```

# Data Transfer and Export/Import

## Copying data to a new index/stream

If the origin is an index and the destination is a stream, there is no way to apply a Reindex , unless the origin contains entries with a field `@timestamp`

```
POST /_reindex
{
  "source": {
    "index": "OUR_INDEX_OF_ORIGIN",
    "query": {
      "exists": {
        "field": "@timestamp"
      }
    }
  },
  "dest": {
    "index": "OUR_ALREADY_EXISTING_INDEX_OR_STREAM_OF_DESTINATION",
    "op_type": "create"
  }
}
```

# Troubleshooting

## The cluster has been locked due to insufficient space and logs the error `Too many requests`

1.  Clear up space first…
2.  Unlock it with :

`curl --user <ADMIN_USER>:<PASSWORD> -XPUT -H "Content-Type: application/json" http://<K8S_NODE_IP>:<K8S_SVC_NODEPORT>/_all/_settings -d '{"index.blocks.read_only_allow_delete": null}'`

If necessary, for future reference, modify the **disk flood_stage limits** with _(*ενδεικτικές τιμές)_:

```
PUT _cluster/settings {
"transient" : {
    "cluster.routing.allocation.disk.watermark.flood_stage" : "1gb",
    "cluster.routing.allocation.disk.watermark.high" : "2gb",
    "cluster.routing.allocation.disk.watermark.low" : "3gb"
  }
}
```

The defaults are extracted by the command: `GET _cluster/settings?flat_settings=true&include_defaults=true`

```
"cluster.routing.allocation.disk.threshold_enabled" : "true",
"cluster.routing.allocation.disk.watermark.enable_for_single_data_node" : "false",
"cluster.routing.allocation.disk.watermark.flood_stage" : "95%",
"cluster.routing.allocation.disk.watermark.high" : "90%",
"cluster.routing.allocation.disk.watermark.low" : "85%",
```