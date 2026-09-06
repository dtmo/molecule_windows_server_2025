resource "libvirt_pool" "example" {
  name = "example"
  type = "dir"
  target = {
    path = pathexpand("~/.local/lib/libvirt/pool")
  }
}

resource "libvirt_volume" "example" {
  name          = "example"
  pool          = libvirt_pool.example.name
  type          = "file"
  capacity      = 50
  capacity_unit = "GiB"

  target = {
    format = {
      type = "qcow2"
    }
  }

  backing_store = {
    path = pathexpand("~/.local/lib/libvirt/images/packer-windows_server_2025")
    format = {
      type = "qcow2"
    }
  }
}

resource "libvirt_domain" "example" {
  name = "example"

  metadata = {
    xml = <<-EOT
      <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
        <libosinfo:os id="http://microsoft.com/win/2k25"/>
      </libosinfo:libosinfo>
      EOT
  }

  memory      = 4096
  memory_unit = "MiB"
  vcpu        = 2
  type        = "kvm"

  os = {
    type            = "hvm"
    type_arch       = "x86_64"
    type_machine    = "q35"
    firmware        = "efi"
    loader          = "/usr/share/OVMF/OVMF_CODE_4M.ms.fd"
    loader_readonly = "yes"
    loader_type     = "pflash"
    nv_ram = {
      nv_ram   = pathexpand("~/.local/lib/libvirt/images/windows_server_2025_efivars.fd")
      template = "/usr/share/OVMF/OVMF_VARS_4M.ms.fd"
    }
    boot_devices = [
      {
        dev = "hd"
      },
    ]
  }

  features = {
    acpi = true
    apic = {}
    hyper_v = {
      avic        = { state = "on" }
      evmcs       = { state = "on" }
      frequencies = { state = "on" }
      ipi         = { state = "on" }
      relaxed     = { state = "on" }
      runtime     = { state = "on" }
      spinlocks   = { state = "on", retries = 8191 }
      stimer      = { state = "on" }
      synic       = { state = "on" }
      tlb_flush   = { state = "on" }
      vapic       = { state = "on" }
      vp_index    = { state = "on" }
    }
    vm_port = { state = "off" }
  }

  cpu = {
    mode = "host-passthrough"
  }

  clock = {
    offset = "localtime"
    timer = [
      { name = "rtc", tick_policy = "catchup" },
      { name = "pit", tick_policy = "delay" },
      { name = "hpet", present = "no" },
      { name = "hypervclock", present = "yes" },
    ]
  }

  devices = {
    channels = [
      {
        protocol = {
          type = "spicevmc"
        }
        target = {
          virt_io = {
            name = "com.redhat.spice.0"
          }
        }
      },
    ]

    consoles = [
      {
        protocol = {
          type = "pty"
        }
      },
    ]

    disks = [
      {
        driver = {
          name    = "qemu"
          type    = "qcow2"
          discard = "unmap"
        }
        source = {
          volume = {
            pool   = libvirt_pool.example.name
            volume = libvirt_volume.example.name
          }
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
      },
    ]

    inputs = [
      {
        type = "tablet"
        bus  = "usb"
      },
    ]

    interfaces = [
      {
        model = {
          type = "virtio"
        }
        source = {
          network = {
            network = "default"
          }
        }
      },
    ]

    graphics = [
      {
        spice = {
          auto_port = true
          image = {
            compression = "off"
          }
        }
      },
    ]

    sounds = [
      { model = "virtio" },
    ]

    videos = [
      {
        model = {
          type    = "qxl"
          heads   = 1
          primary = "yes"
          ram     = 131072
          vga_mem = 65536
          vram    = 65536
          vram64  = 1676288
        }
      },
    ]
  }

  pm = {
    suspend_to_disk = { enabled = "no" }
    suspend_to_mem  = { enabled = "no" }
  }

  running = true
}
