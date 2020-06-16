# Module for creating google bucket notifications

- This module creates a Google Cloud Pub/Sub topic and configures a GCS bucket to publish to that topic.

### Prerequisite
- Terraform 0.12.+


### Example Use
```
module "bucket_notification" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/storage-bucket-notification?ref=storage-bucket-notification-0.0.1"

  bucket_name = "aou-input"
  topic_name = "aou-topic"
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket_name | The name of the bucket to use for configuring storage notifications| string | null | yes |
| topic_name | The name of the pubsub topic to create | string | null | yes |

## Outputs

| Name | Description | Type | 
|------|-------------|:----:|
| topic | topic created | google resource | 
| bucket_notification | the bucket notification created | google resource | 
```
