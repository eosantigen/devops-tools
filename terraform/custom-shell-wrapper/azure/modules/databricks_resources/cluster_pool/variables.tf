# Databricks cluster pool.

variable "cluster_pools" {
  type = map(any)
  description = "Map of Cluster Pools."
}


variable "name" {
  type = string
  description = "Name of cluster pool."
  validation {
    condition = can(regex("(?mi:pool)", var.name))
    error_message = "Name of cluster pool must contain the word 'pool', ideally in the form of CLIENT_NAME-pool-NUMBER (case insensitive)."
  }
}

variable "node_type_id" {
  type = string
  description = "(Optional when instance_pool_id is opted). Use this link https://docs.microsoft.com/en-us/azure/virtual-machines/sizes to find apporpriate size."
  default = ""
}

variable "enable_elastic_disk" {
  type = bool
  description = "(Optional) (Bool) Autoscaling Local Storage: when enabled, the instances in the pool dynamically acquire additional disk space when they are running low on disk space."
}

variable "idle_instance_autotermination_minutes" {
  type = number
  description = "(Required) (Integer) The number of minutes that idle instances in excess of the min_idle_instances are maintained by the pool before being terminated. If not specified, excess idle instances are terminated automatically after a default timeout period. If specified, the time must be between 0 and 10000 minutes. If you specify 0, excess idle instances are removed as soon as possible."
}

variable "max_capacity" {
  type = number
  description = "(Optional) (Integer) The maximum number of instances the pool can contain, including both idle instances and ones in use by clusters. Once the maximum capacity is reached, you cannot create new clusters from the pool and existing clusters cannot autoscale up until some instances are made idle in the pool via cluster termination or down-scaling."
}

variable "min_idle_instances" {
  type = number
  description = "(Optional) (Integer) The minimum number of idle instances maintained by the pool. This is in addition to any instances in use by active clusters."
}

variable "availability" {
  type = string
  description = "(Optional) Availability type used for all nodes. Valid values are SPOT_AZURE and ON_DEMAND_AZURE."
  default = "ON_DEMAND_AZURE"
}

variable "custom_tags" {
  type = map(string)
  description = "Optional - but Required when adding a High-Concurrency cluster where custom_tags should have tag ResourceClass set to value Serverless"
  default = {}
}

# COMMON

variable "common_tags" {
  type        = map(string)
  description = "(Optional) Common tags."
  default     = {}
}

variable "client_tags" {
  type        = map(string)
  description = "(Optional) Client tags."
  default     = {}
}

variable "ANSIBLE_EXECUTABLE_PATH" {
  type = string
}