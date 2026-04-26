# AMD

Installs the AMD graphics stack.

---

## Installation

```bash
./install.sh
````

---

## Includes

* mesa
* lib32-mesa
* vulkan-radeon
* xf86-video-amdgpu
* libva-mesa-driver

---

## Configuration

No manual configuration required.

Drivers are provided by:

* the Linux kernel (amdgpu)
* Mesa userspace

---

## Verify

```bash
glxinfo | grep "OpenGL renderer"
```

---

## Notes

* works out of the box on most modern AMD GPUs
* no proprietary drivers required
* install only one GPU stack

---

## Reference

* [https://wiki.archlinux.org/title/AMDGPU](https://wiki.archlinux.org/title/AMDGPU)
