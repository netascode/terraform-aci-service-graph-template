variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Service graph template name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "template_type" {
  description = "Template type. Choices: `FW_TRANS`, `FW_ROUTED`, `ADC_ONE_ARM`, `ADC_TWO_ARM`, `OTHER`, `CLOUD_NATIVE_LB`, `CLOUD_VENDOR_LB`, `CLOUD_NATIVE_FW`, `CLOUD_VENDOR_FW`."
  type        = string
  default     = "OTHER"

  validation {
    condition     = contains(["FW_TRANS", "FW_ROUTED", "ADC_ONE_ARM", "ADC_TWO_ARM", "OTHER", "CLOUD_NATIVE_LB", "CLOUD_VENDOR_LB", "CLOUD_NATIVE_FW", "CLOUD_VENDOR_FW"], var.template_type)
    error_message = "Allowed values are `FW_TRANS`, `FW_ROUTED`, `ADC_ONE_ARM`, `ADC_TWO_ARM`, `OTHER`, `CLOUD_NATIVE_LB`, `CLOUD_VENDOR_LB`, `CLOUD_NATIVE_FW` or `CLOUD_VENDOR_FW`."
  }
}

variable "redirect" {
  description = "Redirect."
  type        = bool
  default     = false
}

variable "share_encapsulation" {
  description = "Share encapsulation."
  type        = bool
  default     = false
}

variable "device" {
  description = "Device. Default value `copy_device`: `false`. Default value `managed`: `false`. Choices `function`: `None`, `GoTo`, `GoThrough`, `L2`, `L1`."
  type = object({
    name        = string
    tenant      = optional(string)
    function    = optional(string)
    copy_device = optional(bool)
    managed     = optional(bool)
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.device.name))
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition     = var.device.tenant == null || try(can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.device.tenant)), false)
    error_message = "Allowed characters `tenant`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition     = var.device.function == null || try(contains(["None", "GoTo", "GoThrough", "L2", "L1"], var.device.function), false)
    error_message = "`function`: Allowed values are `None`, `GoTo`, `GoThrough`, `L2` or `L1`."
  }
}
