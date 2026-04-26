# NVIDIA

Installs and configures NVIDIA drivers using the `nvidia-open` stack.

---

## Installation

```bash
./install.sh
````

---

## Includes

* nvidia-open
* nvidia-utils
* linux-headers
* nvidia-settings
* nvtop

---

## Configuration

* installs required kernel module and user-space tools
* rebuilds initramfs automatically

---

## Post-Install

Reboot the system.

Verify:

```bash
nvidia-smi
```

---

## Notes

* intended for modern NVIDIA GPUs (Turing and newer)
* do not install alongside other GPU driver stacks
* kernel headers are required for module compatibility

---

## Reference

* [https://wiki.archlinux.org/title/NVIDIA](https://wiki.archlinux.org/title/NVIDIA)
