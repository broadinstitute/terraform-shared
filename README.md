# Terraform Modules

The `terraform-modules` directory contains reusable [terraform modules](https://www.terraform.io/docs/modules/index.html).
Each should include a README documenting:

1. Its intended use / description
2. The set of infrastructure created
3. All configuration options, with sample values

The git tags in this repo are in the form `<module-name>-<point-version>`.
Each tag reflects a specific version of the module at the path `terraform-modules/<module-name>`.
This allows the modules to be versioned independently. For a given tag,
the only module guaranteed to exist in a functional state is the module
at the `terraform-modules/<module-name>` path.

## Using These Modules

To use these modules in your terraform stacks, set the `source` in your
module declaration to the path to the module in this repo:

```terraform
module "my-k8s-cluster" {                                                
  # terraform-shared repo                                                
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s?ref=k8s-0.0.1"
  ...
}
```

The format of the `source` is `github.com/<org>/<repo>//<path-within-repo>?ref=<git-ref>`.
Note the double slash  (`//`) between the `<repo>` and `<path-within-repo>`--this is
how terraform determines where the repo name ends and the path begins. For more
detail see the [docs](https://www.terraform.io/docs/modules/sources.html).
