#! /bin/bash

# The path of this script
script_path=$(realpath $0)

# The directory containing this script
script_dir=$(dirname "${script_path}")

isos_dir="${script_dir}/isos"
mkdir -p "${isos_dir}"

if ! [[ -f "${isos_dir}/virtio-win.iso" ]]; then
    echo "Downloading virtio-win.iso"
    curl --output-dir "${isos_dir}" -OJL "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
fi

files_dir="${script_dir}/files"
mkdir -p "${files_dir}"

if ! [[ -f "${files_dir}/QxlWddmDod_0.21.0.0_x64.msi" ]]; then
    echo "Downloading QxlWddmDod_0.21.0.0_x64.msi"
    curl --output-dir "${files_dir}" -OJL "https://www.spice-space.org/download/windows/qxl-wddm-dod/qxl-wddm-dod-0.21/QxlWddmDod_0.21.0.0_x64.msi"
fi

if ! [[ -f "${files_dir}/Red_Hat_QXL_0.1.24.2_x64.msi" ]]; then
    echo "Downloading Red_Hat_QXL_0.1.24.2_x64.msi"
    curl --output-dir "${files_dir}" -OJL "https://www.spice-space.org/download/windows/qxl/qxl-0.1-24/Red_Hat_QXL_0.1.24.2_x64.msi"
fi

if ! [[ -f "${files_dir}/spice-vdagent-x64-0.10.0.msi" ]]; then
    echo "Downloading spice-vdagent-x64-0.10.0.msi"
    curl --output-dir "${files_dir}" -OJL "https://www.spice-space.org/download/windows/vdagent/vdagent-win-0.10.0/spice-vdagent-x64-0.10.0.msi"
fi

if ! [[ -f "${files_dir}/CloudbaseInitSetup_1_1_8_x64.msi" ]]; then
    echo "Downloading CloudbaseInitSetup_1_1_8_x64.msi"
    curl --output-dir "${files_dir}" -OJL "https://github.com/cloudbase/cloudbase-init/releases/download/1.1.8/CloudbaseInitSetup_1_1_8_x64.msi"
fi
