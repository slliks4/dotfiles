# Intel

Installs the Intel graphics stack.

---

## Installation

```bash
./install.sh
````

---

## Includes

* mesa
* lib32-mesa
* intel-media-driver
* libva-intel-driver
* vulkan-intel
* intel-gpu-tools

---

## Configuration

No manual configuration required.

Drivers are provided by:

* the Linux kernel
* Mesa userspace

---

## Verify

```bash
glxinfo | grep "OpenGL renderer"
```

---

## Notes

* works out of the box on most systems
* no kernel modules or initramfs changes required
* install only one GPU stack

---

## Reference

* [https://wiki.archlinux.org/title/Intel_graphics](https://wiki.archlinux.org/title/Intel_graphics)
