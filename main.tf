resource "aci_rest" "vnsAbsGraph" {
  dn         = "uni/tn-${var.tenant}/AbsGraph-${var.name}"
  class_name = "vnsAbsGraph"
  content = {
    name           = var.name
    descr          = var.description
    nameAlias      = var.alias
    type           = "legacy"
    uiTemplateType = "UNSPECIFIED"
  }
}

resource "aci_rest" "vnsAbsTermNodeCon" {
  dn         = "${aci_rest.vnsAbsGraph.dn}/AbsTermNodeCon-T1"
  class_name = "vnsAbsTermNodeCon"
  content = {
    name = "T1"
  }
}

resource "aci_rest" "vnsAbsTermConn_T1" {
  dn         = "${aci_rest.vnsAbsTermNodeCon.dn}/AbsTConn"
  class_name = "vnsAbsTermConn"
  content = {
    name = "1"
  }
}

resource "aci_rest" "vnsInTerm_T1" {
  dn         = "${aci_rest.vnsAbsTermNodeCon.dn}/intmnl"
  class_name = "vnsInTerm"
}

resource "aci_rest" "vnsOutTerm_T1" {
  dn         = "${aci_rest.vnsAbsTermNodeCon.dn}/outtmnl"
  class_name = "vnsOutTerm"
}

resource "aci_rest" "vnsAbsTermNodeProv" {
  dn         = "${aci_rest.vnsAbsGraph.dn}/AbsTermNodeProv-T2"
  class_name = "vnsAbsTermNodeProv"
  content = {
    name = "T2"
  }
}

resource "aci_rest" "vnsAbsTermConn_T2" {
  dn         = "${aci_rest.vnsAbsTermNodeProv.dn}/AbsTConn"
  class_name = "vnsAbsTermConn"
  content = {
    name = "1"
  }
}

resource "aci_rest" "vnsInTerm_T2" {
  dn         = "${aci_rest.vnsAbsTermNodeProv.dn}/intmnl"
  class_name = "vnsInTerm"
}

resource "aci_rest" "vnsOutTerm_T2" {
  dn         = "${aci_rest.vnsAbsTermNodeProv.dn}/outtmnl"
  class_name = "vnsOutTerm"
}

resource "aci_rest" "vnsAbsNode" {
  dn         = "${aci_rest.vnsAbsGraph.dn}/AbsNode-N1"
  class_name = "vnsAbsNode"
  content = {
    funcTemplateType = var.template_type
    funcType         = var.device_function != "" ? var.device_function : "GoTo"
    isCopy           = var.device_copy == true ? "yes" : "no"
    managed          = var.device_managed == true ? "yes" : "no"
    name             = "N1"
    routingMode      = var.redirect == true ? "Redirect" : "unspecified"
    sequenceNumber   = "0"
    shareEncap       = var.share_encapsulation == true ? "yes" : "no"
  }
}

resource "aci_rest" "vnsAbsFuncConn_Provider" {
  dn         = "${aci_rest.vnsAbsNode.dn}/AbsFConn-provider"
  class_name = "vnsAbsFuncConn"
  content = {
    attNotify = "no"
    name      = "provider"
  }
}

resource "aci_rest" "vnsAbsFuncConn_Consumer" {
  dn         = "${aci_rest.vnsAbsNode.dn}/AbsFConn-consumer"
  class_name = "vnsAbsFuncConn"
  content = {
    attNotify = "no"
    name      = "consumer"
  }
}

resource "aci_rest" "vnsRsNodeToLDev" {
  dn         = "${aci_rest.vnsAbsNode.dn}/rsNodeToLDev"
  class_name = "vnsRsNodeToLDev"
  content = {
    tDn = "uni/tn-${var.device_tenant != "" ? var.device_tenant : var.tenant}/lDevVip-${var.device_name}"
  }
}

resource "aci_rest" "vnsAbsConnection_Consumer" {
  dn         = "${aci_rest.vnsAbsGraph.dn}/AbsConnection-C1"
  class_name = "vnsAbsConnection"
  content = {
    adjType       = "L3"
    connDir       = "provider"
    connType      = "external"
    directConnect = "no"
    name          = "C1"
    unicastRoute  = "yes"
  }
}

resource "aci_rest" "vnsRsAbsConnectionConns_ConT1" {
  dn         = "${aci_rest.vnsAbsConnection_Consumer.dn}/rsabsConnectionConns-[${aci_rest.vnsAbsTermConn_T1.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest.vnsAbsTermConn_T1.dn
  }
}

resource "aci_rest" "vnsRsAbsConnectionConns_NodeN1Consumer" {
  dn         = "${aci_rest.vnsAbsConnection_Consumer.dn}/rsabsConnectionConns-[${aci_rest.vnsAbsFuncConn_Consumer.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest.vnsAbsFuncConn_Consumer.dn
  }
}

resource "aci_rest" "vnsAbsConnection_Provider" {
  dn         = "${aci_rest.vnsAbsGraph.dn}/AbsConnection-C2"
  class_name = "vnsAbsConnection"
  content = {
    adjType       = "L3"
    connDir       = "provider"
    connType      = "external"
    directConnect = "no"
    name          = "C2"
    unicastRoute  = "yes"
  }
}

resource "aci_rest" "vnsRsAbsConnectionConns_ConT2" {
  dn         = "${aci_rest.vnsAbsConnection_Provider.dn}/rsabsConnectionConns-[${aci_rest.vnsAbsTermConn_T2.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest.vnsAbsTermConn_T2.dn
  }
}

resource "aci_rest" "vnsRsAbsConnectionConns_NodeN1Provider" {
  dn         = "${aci_rest.vnsAbsConnection_Provider.dn}/rsabsConnectionConns-[${aci_rest.vnsAbsFuncConn_Provider.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest.vnsAbsFuncConn_Provider.dn
  }
}
