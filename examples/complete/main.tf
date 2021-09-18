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
