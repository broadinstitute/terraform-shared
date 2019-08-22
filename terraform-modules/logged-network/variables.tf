variable "network_name" {
  type = "string"
  default = "app-services"
}

variable "google_project" {}

provider "google" {
  alias = "target"
}

provider "google-beta" {
  alias = "target"
}

variable "subnet_cidrs" {
  type = list(object({
    cidr = string,
    region = string,
  }))
  default = [
    {
      cidr = "10.128.0.0/20"
      region = "us-central1"
    },
    {
      cidr = "10.132.0.0/20"
      region = "europe-west1"
    },
    {
      cidr = "10.138.0.0/20"
      region = "us-west1"
    },
    {
      cidr = "10.140.0.0/20"
      region = "asia-east1"
    },
    {
      cidr = "10.142.0.0/20"
      region = "us-east1"
    },
    {
      cidr = "10.146.0.0/20"
      region = "asia-northeast1"
    },
    {
      cidr = "10.148.0.0/20"
      region = "asia-southeast1"
    },
    {
      cidr = "10.150.0.0/20"
      region = "us-east4"
    },
    {
      cidr = "10.152.0.0/20"
      region = "australia-southeast1"
    },
    {
      cidr = "10.154.0.0/20"
      region = "europe-west2"
    },
    {
      cidr = "10.156.0.0/20"
      region = "europe-west3"
    },
    {
      cidr = "10.158.0.0/20"
      region = "southamerica-east1"
    },
    {
      cidr = "10.160.0.0/20"
      region = "asia-south1"
    },
    {
      cidr = "10.162.0.0/20"
      region = "northamerica-northeast1"
    },
    {
      cidr = "10.164.0.0/20"
      region = "europe-west4"
    },
    {
      cidr = "10.166.0.0/20"
      region = "europe-north1"
    },
    {
      cidr = "10.168.0.0/20"
      region = "us-west2"
    },
    {
      cidr = "10.170.0.0/20"
      region = "asia-east2"
    },
    {
      cidr = "10.172.0.0/20"
      region = "europe-west6"
    },
    {
      cidr = "10.174.0.0/20"
      region = "asia-northeast2"
    },
  ]
}
