packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

locals {
  guest_username            = "Administrator"
  guest_password            = "ChangeMe!"
  server_standard_core      = "Windows Server 2025 SERVERSTANDARDCORE"
  server_standard_desktop   = "Windows Server 2025 SERVERSTANDARD"
  server_datacenter_core    = "Windows Server 2025 SERVERDATACENTERCORE"
  server_datacenter_desktop = "Windows Server 2025 SERVERDATACENTER"
}

source "qemu" "windows_server_2025" {
  iso_url      = "https://software-static.download.prss.microsoft.com/dbazure/998969d5-f34g-4e03-ac9d-1f9786c66749/26100.32230.260111-0550.lt_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
  iso_checksum = "sha256:7b052573ba7894c9924e3e87ba732ccd354d18cb75a883efa9b900ea125bfd51"

  disk_interface = "virtio-scsi"
  disk_size      = "50G"
  machine_type   = "q35"
  memory         = 4096
  cpu_model      = "host"
  cpus           = 2

  efi_boot          = true
  efi_firmware_code = var.efi_firmware_code
  efi_firmware_vars = var.efi_firmware_vars

  cd_content = {
    "Autounattend.xml" = templatefile("${path.root}/templates/Autounattend.xml.pkrtpl", {
      build_image_name = local.server_standard_desktop
      build_username   = local.guest_username
      build_password   = local.guest_password
    })
  }

  cd_files = [
    "${path.root}/files",
    "${path.root}/scripts",
  ]

  qemuargs = [
    ["-cdrom", "${path.root}/isos/virtio-win.iso"]
  ]

  boot_command = [
    "<enter>"
  ]
  boot_wait = "2s"

  ssh_username = local.guest_username
  ssh_password = local.guest_password
  ssh_timeout  = "10h"

  shutdown_command = "%SystemRoot%\\system32\\WindowsPowerShell\\v1.0\\powershell.exe -File E:\\scripts\\generalize.ps1"
}

build {
  source "qemu.windows_server_2025" {
  }

  provisioner "powershell" {
    inline = [
      "Start-Process msiexec.exe -Wait -ArgumentList \"/package E:\\files\\CloudbaseInitSetup_1_1_8_x64.msi /passive\"",
      "Copy-Item \"E:\\scripts\\cloudbase-init\\cloudbase-init-unattend.conf\" -Destination \"C:\\Program Files\\Cloudbase Solutions\\Cloudbase-Init\\conf\\cloudbase-init-unattend.conf\"",
      "Copy-Item \"E:\\scripts\\cloudbase-init\\Unattend.xml\" -Destination \"C:\\Program Files\\Cloudbase Solutions\\Cloudbase-Init\\conf\\Unattend.xml\"",
    ]
  }
}
