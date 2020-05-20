provider "google" {
  project = "broad-gotc-dev"
}

module "test_cloud_nat" {
  source = "../"

}
