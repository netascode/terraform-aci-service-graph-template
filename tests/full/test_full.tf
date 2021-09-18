terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant              = aci_rest.fvTenant.content.name
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

data "aci_rest" "vnsAbsGraph" {
  dn = "uni/tn-${aci_rest.fvTenant.content.name}/AbsGraph-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsGraph" {
  component = "vnsAbsGraph"

  equal "name" {
    description = "name"
    got         = data.aci_rest.vnsAbsGraph.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.vnsAbsGraph.content.descr
    want        = "My Description"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest.vnsAbsGraph.content.nameAlias
    want        = "SGT1-ALIAS"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest.vnsAbsGraph.content.type
    want        = "legacy"
  }

  equal "uiTemplateType" {
    description = "uiTemplateType"
    got         = data.aci_rest.vnsAbsGraph.content.uiTemplateType
    want        = "UNSPECIFIED"
  }
}

data "aci_rest" "vnsAbsTermNodeCon" {
  dn = "${data.aci_rest.vnsAbsGraph.id}/AbsTermNodeCon-T1"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsTermNodeCon" {
  component = "vnsAbsTermNodeCon"

  equal "name" {
    description = "name"
    got         = data.aci_rest.vnsAbsTermNodeCon.content.name
    want        = "T1"
  }
}

data "aci_rest" "vnsAbsTermConn_T1" {
  dn = "${data.aci_rest.vnsAbsTermNodeCon.id}/AbsTConn"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsTermConn_T1" {
  component = "vnsAbsTermConn_T1"

  equal "name" {
    description = "name"
    got         = data.aci_rest.vnsAbsTermConn_T1.content.name
    want        = "1"
  }
}

data "aci_rest" "vnsAbsTermNodeProv" {
  dn = "${data.aci_rest.vnsAbsGraph.id}/AbsTermNodeProv-T2"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsTermNodeProv" {
  component = "vnsAbsTermNodeProv"

  equal "name" {
    description = "name"
    got         = data.aci_rest.vnsAbsTermNodeProv.content.name
    want        = "T2"
  }
}

data "aci_rest" "vnsAbsTermConn_T2" {
  dn = "${data.aci_rest.vnsAbsTermNodeProv.id}/AbsTConn"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsTermConn_T2" {
  component = "vnsAbsTermConn_T2"

  equal "name" {
    description = "name"
    got         = data.aci_rest.vnsAbsTermConn_T2.content.name
    want        = "1"
  }
}

data "aci_rest" "vnsAbsNode" {
  dn = "${data.aci_rest.vnsAbsGraph.id}/AbsNode-N1"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsNode" {
  component = "vnsAbsNode"

  equal "funcTemplateType" {
    description = "funcTemplateType"
    got         = data.aci_rest.vnsAbsNode.content.funcTemplateType
    want        = "FW_ROUTED"
  }


  equal "funcType" {
    description = "funcType"
    got         = data.aci_rest.vnsAbsNode.content.funcType
    want        = "GoThrough"
  }

  equal "isCopy" {
    description = "isCopy"
    got         = data.aci_rest.vnsAbsNode.content.isCopy
    want        = "no"
  }

  equal "managed" {
    description = "managed"
    got         = data.aci_rest.vnsAbsNode.content.managed
    want        = "no"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest.vnsAbsNode.content.name
    want        = "N1"
  }

  equal "routingMode" {
    description = "routingMode"
    got         = data.aci_rest.vnsAbsNode.content.routingMode
    want        = "Redirect"
  }

  equal "sequenceNumber" {
    description = "sequenceNumber"
    got         = data.aci_rest.vnsAbsNode.content.sequenceNumber
    want        = "0"
  }

  equal "shareEncap" {
    description = "shareEncap"
    got         = data.aci_rest.vnsAbsNode.content.shareEncap
    want        = "yes"
  }
}

data "aci_rest" "vnsAbsFuncConn_Provider" {
  dn = "${data.aci_rest.vnsAbsNode.id}/AbsFConn-provider"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsFuncConn_Provider" {
  component = "vnsAbsFuncConn_Provider"

  equal "attNotify" {
    description = "attNotify"
    got         = data.aci_rest.vnsAbsFuncConn_Provider.content.attNotify
    want        = "no"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest.vnsAbsFuncConn_Provider.content.name
    want        = "provider"
  }
}

data "aci_rest" "vnsAbsFuncConn_Consumer" {
  dn = "${data.aci_rest.vnsAbsNode.id}/AbsFConn-consumer"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsFuncConn_Consumer" {
  component = "vnsAbsFuncConn_Consumer"

  equal "attNotify" {
    description = "attNotify"
    got         = data.aci_rest.vnsAbsFuncConn_Consumer.content.attNotify
    want        = "no"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest.vnsAbsFuncConn_Consumer.content.name
    want        = "consumer"
  }
}

data "aci_rest" "vnsRsNodeToLDev" {
  dn = "${data.aci_rest.vnsAbsNode.id}/rsNodeToLDev"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsNodeToLDev" {
  component = "vnsRsNodeToLDev"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.vnsRsNodeToLDev.content.tDn
    want        = "uni/tn-DEF/lDevVip-DEV1"
  }
}

data "aci_rest" "vnsAbsConnection_Consumer" {
  dn = "${data.aci_rest.vnsAbsGraph.id}/AbsConnection-C1"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsConnection_Consumer" {
  component = "vnsAbsConnection_Consumer"

  equal "adjType" {
    description = "adjType"
    got         = data.aci_rest.vnsAbsConnection_Consumer.content.adjType
    want        = "L3"
  }

  equal "connDir" {
    description = "connDir"
    got         = data.aci_rest.vnsAbsConnection_Consumer.content.connDir
    want        = "provider"
  }

  equal "connType" {
    description = "connType"
    got         = data.aci_rest.vnsAbsConnection_Consumer.content.connType
    want        = "external"
  }

  equal "directConnect" {
    description = "directConnect"
    got         = data.aci_rest.vnsAbsConnection_Consumer.content.directConnect
    want        = "no"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest.vnsAbsConnection_Consumer.content.name
    want        = "C1"
  }

  equal "unicastRoute" {
    description = "unicastRoute"
    got         = data.aci_rest.vnsAbsConnection_Consumer.content.unicastRoute
    want        = "yes"
  }
}

data "aci_rest" "vnsRsAbsConnectionConns_ConT1" {
  dn = "${data.aci_rest.vnsAbsConnection_Consumer.id}/rsabsConnectionConns-[${data.aci_rest.vnsAbsTermConn_T1.id}]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsAbsConnectionConns_ConT1" {
  component = "vnsRsAbsConnectionConns_ConT1"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.vnsRsAbsConnectionConns_ConT1.content.tDn
    want        = data.aci_rest.vnsAbsTermConn_T1.id
  }
}

data "aci_rest" "vnsRsAbsConnectionConns_NodeN1Consumer" {
  dn = "${data.aci_rest.vnsAbsConnection_Consumer.id}/rsabsConnectionConns-[${data.aci_rest.vnsAbsFuncConn_Consumer.id}]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsAbsConnectionConns_NodeN1Consumer" {
  component = "vnsRsAbsConnectionConns_NodeN1Consumer"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.vnsRsAbsConnectionConns_NodeN1Consumer.content.tDn
    want        = data.aci_rest.vnsAbsFuncConn_Consumer.id
  }
}

data "aci_rest" "vnsAbsConnection_Provider" {
  dn = "${data.aci_rest.vnsAbsGraph.id}/AbsConnection-C2"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsConnection_Provider" {
  component = "vnsAbsConnection_Provider"

  equal "adjType" {
    description = "adjType"
    got         = data.aci_rest.vnsAbsConnection_Provider.content.adjType
    want        = "L3"
  }

  equal "connDir" {
    description = "connDir"
    got         = data.aci_rest.vnsAbsConnection_Provider.content.connDir
    want        = "provider"
  }

  equal "connType" {
    description = "connType"
    got         = data.aci_rest.vnsAbsConnection_Provider.content.connType
    want        = "external"
  }

  equal "directConnect" {
    description = "directConnect"
    got         = data.aci_rest.vnsAbsConnection_Provider.content.directConnect
    want        = "no"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest.vnsAbsConnection_Provider.content.name
    want        = "C2"
  }

  equal "unicastRoute" {
    description = "unicastRoute"
    got         = data.aci_rest.vnsAbsConnection_Provider.content.unicastRoute
    want        = "yes"
  }
}

data "aci_rest" "vnsRsAbsConnectionConns_ConT2" {
  dn = "${data.aci_rest.vnsAbsConnection_Provider.id}/rsabsConnectionConns-[${data.aci_rest.vnsAbsTermConn_T2.id}]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsAbsConnectionConns_ConT2" {
  component = "vnsRsAbsConnectionConns_ConT2"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.vnsRsAbsConnectionConns_ConT2.content.tDn
    want        = data.aci_rest.vnsAbsTermConn_T2.id
  }
}

data "aci_rest" "vnsRsAbsConnectionConns_NodeN1Provider" {
  dn = "${data.aci_rest.vnsAbsConnection_Provider.id}/rsabsConnectionConns-[${data.aci_rest.vnsAbsFuncConn_Provider.id}]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsAbsConnectionConns_NodeN1Provider" {
  component = "vnsRsAbsConnectionConns_NodeN1Provider"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.vnsRsAbsConnectionConns_NodeN1Provider.content.tDn
    want        = data.aci_rest.vnsAbsFuncConn_Provider.id
  }
}
