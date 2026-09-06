# molecule_windows_server_2025

A Packer project to build a Windows Server 2025 image suitable for supporting Molecule tests.

## Building

1. Download driver and agent installation files:

   ```bash
   ./initialize.sh
   ```

2. Initialize Packer:

   ```bash
   packer init .
   ```

3. Build the image:

   ```bash
   packer build .
   ```

## Testing

1. Create a local libvirt images directory

   ```bash
   mkdir -p ~/.local/lib/libvirt/images
   ```

2. Move the built image to the images directory

   ```bash
   mv output-windows_server_2025/packer-windows_server_2025 ~/.local/lib/libvirt/images
   mv output-windows_server_2025/efivars.fd ~/.local/lib/libvirt/images/windows_server_2025_efivars.fd
   ```

3. Test the image with Terraform

   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

   The terraform code launches a VM using the built image. Use your libvirt client of choice (e.g. `virt-manager`) to
   connect to the VM.
