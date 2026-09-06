variable "efi_firmware_code" {
  type        = string
  description = "Path to the CODE part of OVMF (or other compatible firmwares) The OVMF_CODE.fd file contains the bootstrap code for booting in EFI mode, and requires a separate VARS.fd file to be able to persist data between boot cycles."
  default     = "/usr/share/OVMF/OVMF_CODE_4M.ms.fd"
}

variable "efi_firmware_vars" {
  type        = string
  description = "Path to the VARS corresponding to the OVMF code file."
  default     = "/usr/share/OVMF/OVMF_VARS_4M.ms.fd"
}
