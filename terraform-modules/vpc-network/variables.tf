variable "network_name" {
  type = string
  default = "app-services"
}

variable "aggregation_interval" {
  type = string
  default = "INTERVAL_10_MIN"
}

variable "flow_sampling" {
  type = number
  default = 0.5
}

variable "metadata" {
  type = string
  default = "INCLUDE_ALL_METADATA"
}

variable "subnets" {
  type = map(object({
    cidr = string,
    private_ip_access = bool,
    vpc_logging = bool,
  }))
  default = {
    "us-central1" = {
      cidr = "10.128.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "europe-west1" = {
      cidr = "10.132.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "us-west1" = {
      cidr = "10.138.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "asia-east1" = {
      cidr = "10.140.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "us-east1" = {
      cidr = "10.142.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "asia-northeast1" = {
      cidr = "10.146.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "asia-southeast1" = {
      cidr = "10.148.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "us-east4" = {
      cidr = "10.150.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "australia-southeast1" = {
      cidr = "10.152.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "europe-west2" = {
      cidr = "10.154.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "europe-west3" = {
      cidr = "10.156.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "southamerica-east1" = {
      cidr = "10.158.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "asia-south1" = {
      cidr = "10.160.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "northamerica-northeast1" = {
      cidr = "10.162.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "europe-west4" = {
      cidr = "10.164.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "europe-north1" = {
      cidr = "10.166.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "us-west2" = {
      cidr = "10.168.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "asia-east2" = {
      cidr = "10.170.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "europe-west6" = {
      cidr = "10.172.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
    "asia-northeast2" = {
      cidr = "10.174.0.0/20"
      private_ip_access = false,
      vpc_logging = false,
    },
  }
}
