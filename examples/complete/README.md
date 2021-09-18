<!-- BEGIN_TF_DOCS -->
# Service Graph Template Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_service_graph_template" {
  source  = "netascode/service-graph-template/aci"
  version = ">= 0.0.1"

  tenant              = "ABC"
  name                = "SGT1"
  alias               = "SGT1-ALIAS"
  description         = "My Description"
  template_type       = "FW_ROUTED"
  redirect            = true
  share_encapsulation = true
  device = {
    name        = "DEV1"
    tenant      = "DEF"
    function    = "GoThrough"
    copy_device = false
    managed     = false
  }
}

```
<!-- END_TF_DOCS -->