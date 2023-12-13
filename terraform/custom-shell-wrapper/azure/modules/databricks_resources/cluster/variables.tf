# Databricks cluster .

variable "clusters" {
  type = map(any)
  description = "Map of Clusters."
}

variable "name" {
  type = string
  description = "(Optional) Cluster name, which doesn’t have to be unique. If not specified at creation, the cluster name will be an empty string."
  validation {
    condition = can(regex("(?mi:cluster)", var.name))
    error_message = "Name of cluster must contain the word 'cluster', ideally in the form of CLIENT_NAME-cluster-NUMBER (case insensitive)."
  }
}

variable "node_type_id" {
  type = string
  description = "(Required - optional if instance_pool_id is given) Any supported databricks_node_type id. If instance_pool_id is specified, this field is not needed. Use this link https://docs.microsoft.com/en-us/azure/virtual-machines/sizes to find apporpriate size."
  default = ""
}

variable "enable_elastic_disk" {
  type = bool
  description = "(Optional) If you don’t want to allocate a fixed number of EBS volumes at cluster creation time, use autoscaling local storage. With autoscaling local storage, Databricks monitors the amount of free disk space available on your cluster’s Spark workers. If a worker begins to run too low on disk, Databricks automatically attaches a new EBS volume to the worker before it runs out of disk space. EBS volumes are attached up to a limit of 5 TB of total disk space per instance (including the instance’s local storage). To scale down EBS usage, make sure you have autotermination_minutes and autoscale attributes set."
  default = true
}

variable "autotermination_minutes" {
  type = number
  description = "(Optional) Automatically terminate the cluster after being inactive for this time in minutes. If not set, Databricks won't automatically terminate an inactive cluster. If specified, the threshold must be between 10 and 10000 minutes. You can also set this value to 0 to explicitly disable automatic termination. We highly recommend having this setting present for Interactive/BI clusters."
  default = 40
}

variable "instace_pool_id" {
  type = string
  description = "(Optional - required if node_type_id is not given) - To reduce cluster start time, you can attach a cluster to a predefined pool of idle instances. When attached to a pool, a cluster allocates its driver and worker nodes from the pool. If the pool does not have sufficient idle resources to accommodate the cluster’s request, it expands by allocating new instances from the instance provider. When an attached cluster changes its state to TERMINATED, the instances it used are returned to the pool and reused by a different cluster."
}

variable "policy_id" {
  type = string
  description = "(Optional) Identifier of Cluster Policy to validate cluster and preset certain defaults."
  default = ""
}

# variable "autoscale" {
#   type = map(any)
#   description = "optional configuration block supports the following: min_workers - (Optional) The minimum number of workers to which the cluster can scale down when underutilized. It is also the initial number of workers the cluster will have after creation. max_workers - (Optional) The maximum number of workers to which the cluster can scale up when overloaded. max_workers must be strictly greater than min_workers."
#   default = {} 
# }

variable "num_workers" {
  type = number
  description = "When you create a Databricks cluster, you can either provide a num_workers for the fixed-size cluster or provide min_workers and/or max_workers for the cluster within the autoscale group."
}

variable "spark_version" {
  type = string
  description = "spark_version - (Required) Runtime version of the cluster. Any supported databricks_spark_version id. We advise using Cluster Policies to restrict the list of versions for simplicity while maintaining enough control."
}

variable "spark_conf" {
  type = map(any)
  description = "(Optional) Map with key-value pairs to fine-tune Spark clusters, where you can provide custom Spark configuration properties in a cluster configuration."
  default = {}
}

variable "spark_env_vars" {
  type = map(any)
  description = "(Optional) Map with environment variable key-value pairs to fine-tune Spark clusters. Key-value pairs of the form (X,Y) are exported (i.e., X='Y') while launching the driver and workers."
  default = {}
}

variable "custom_tags" {
  type = map(string)
  description = "Optional - but Required when adding a High-Concurrency cluster where custom_tags should have tag ResourceClass set to value Serverless"
  default = {}
}

variable "cluster_log_conf" {
  type = map(any)
  description = "Configure log store targets."
  default = {}
}

# COMMON

variable "common_tags" {
  type        = map(string)
  description = "(Optional) Common tags."
  default     = { ManagedBy = "DevOps Team with Terraform" }
}

variable "client_tags" {
  type        = map(string)
  description = "(Optional) Client tags."
  default     = {}
}

variable "ANSIBLE_EXECUTABLE_PATH" {
  type = string
  default = "/usr/local/bin"
}