# Required Variables

variable "policy_name" {
  type = string
  description = "Display name to be associated with a particular alerting policy"
}

variable "condition_combine_method" {
  type = string
  description = "logic to trigger the alert when multiple conditions are present only 'AND' and 'OR' are valid arguments"
}

variable "project" {
  type = string
  description = "The GCP project the alert policy should be created under"
}

variable "cluster_name" {
  type = string
  description = " Name of the cluster the alert policy will monitor"
}

# Optional Variables 

variable "notification_channels" {
  type = list(string)
  default = []
  description = "List of channels that should be pinged when alert fires. Array entries must be of form: projects/[PROJECT_ID]/notificationChannels/[CHANNEL_ID]"

}
