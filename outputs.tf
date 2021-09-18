output "dn" {
  value       = aci_rest.vnsAbsGraph.id
  description = "Distinguished name of `vnsAbsGraph` object."
}

output "name" {
  value       = aci_rest.vnsAbsGraph.content.name
  description = "Service graph template name."
}
