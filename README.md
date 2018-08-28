# Buildroot for Petitboot bootloader

Buildroot with updates to generate a EFI bootable petitboot image.

## Build

```sh
buildd="/tmp/buildd"
mkdir -p ${buildd}
make O=${buildd} arm64_petitboot_defconfig
cd ${buildd}
make
```

See the buildroot project's [README](README).

## QEMU Test

```sh
wget https://alpha.release.core-os.net/arm64-usr/current/coreos_production_qemu_uefi_efi_code.fd
wget https://alpha.release.core-os.net/arm64-usr/current/coreos_production_qemu_uefi_efi_vars.fd
wget https://alpha.release.core-os.net/arm64-usr/current/coreos_production_pxe.vmlinuz
wget https://alpha.release.core-os.net/arm64-usr/current/coreos_production_pxe_image.cpio.gz

efi_code="coreos_production_qemu_uefi_efi_code.fd"
efi_vars="coreos_production_qemu_uefi_efi_vars.fd"
arm64_kernel="coreos_production_pxe.vmlinuz"
arm64_initrd="coreos_production_pxe_image.cpio.gz"

br_image="./images/Image"
mount=./cow-mount

qemu-img create -f qcow2 pb.qcow2 4G

sudo rm -rf ${mount}
mkdir -p ${mount}
sudo modprobe nbd max_part=1
sudo qemu-nbd --connect=/dev/nbd0 pb.qcow2
sudo mkfs.vfat /dev/nbd0
sudo mount /dev/nbd0 ${mount} -o rw,uid=$(id -u),gid=$(id -g)

mkdir -p ${mount}/EFI/boot/
cp ${br_image} ${mount}/EFI/boot/bootaa64.efi

mkdir -p ${mount}/boot/
cp -v ${arm64_kernel} ${mount}/boot/
cp -v ${arm64_initrd} ${mount}/boot/
echo "linux-1=\"/boot/${arm64_kernel} initrd=/boot/${arm64_initrd} coreos.autologin=1\"" > ${mount}/boot/kboot.cfg

sudo umount ${mount}
sudo qemu-nbd --disconnect /dev/nbd0
rm ${mount}

qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine type=virt -m 2048 -nographic \
 -drive if=pflash,file=${efi_code},format=raw,readonly \
 -drive if=pflash,file=${efi_vars},format=raw \
 -netdev user,id=eth0,hostfwd=tcp::2222-:22,hostname=pb_tester \
 -device virtio-net-device,netdev=eth0 \
 -hda pb.qcow2
```

Add boot menu item from UEFI shell/boot manager.
