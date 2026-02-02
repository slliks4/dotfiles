# GPU Setup (Linux-First Workstation)

This document describes the **GPU strategy** used in this system.

The goal is:

* kernel stability
* minimal early-boot risk
* clean integration with X11 / Wayland
* predictable behavior for system and embedded development

This is **not a gaming-first or CUDA-first setup**.

---

## 🟢 Intel GPU (Recommended)

**Status:** ✅ Primary and preferred GPU

Intel GPUs (iGPU or dGPU) are the **default and recommended choice** for this system.

### Why Intel is preferred

* **In-kernel, open-source drivers**
* No DKMS
* No proprietary kernel modules
* No initramfs hooks
* No early-boot dependencies
* Works out of the box with:

  * Xorg
  * Wayland
  * dwm
  * PipeWire
  * Screen sharing
  * OBS
  * Browsers
  * Video playback & encoding

Intel graphics move **with the kernel**, not against it.

This makes them ideal for:

* kernel development
* embedded work
* window manager hacking
* low-level tooling
* documentation and reproducibility

### Driver stack

Installed automatically via:

* kernel DRM
* Mesa
* libva / VA-API

No manual driver installation required.

### Verification

```bash
sudo pacman -S glxinfo
glxinfo | grep "OpenGL renderer"
```

Expected:

```
Mesa Intel ...
```

---

## 🟡 AMD GPU (Next Best Recommended)

**Status:** ⏳ Not used in this system (yet)

AMD GPUs are an **excellent alternative** to Intel and follow a similar philosophy:

* open-source drivers
* in-kernel support
* Mesa-based stack
* no DKMS
* no early-boot risk

They are well-suited for:

* Linux desktop workstations
* Wayland and Xorg
* OBS and screen capture
* Video editing (e.g. DaVinci Resolve)
* Long-term kernel development

This section is intentionally left minimal and will be expanded **if/when an AMD GPU is introduced**.

---

## 🔴 NVIDIA GPU (Not Recommended)

**Status:** ❌ Avoided in this system

NVIDIA GPUs are **intentionally not used** in this setup.

This is a **technical decision**, not a preference.

### Why NVIDIA is avoided

#### 1. Proprietary kernel modules

* Closed-source
* Loaded early in boot
* Not maintained in lockstep with the kernel
* Can panic the kernel on ABI changes

#### 2. DKMS fragility

* Successful build ≠ runtime compatibility
* Legacy drivers frequently break on newer kernels
* Requires kernel pinning or rollback discipline

#### 3. Early-boot risk

* NVIDIA drivers often load during initramfs
* Failures happen *after LUKS unlock*
* Recovery is harder when NVIDIA is required for display

#### 4. Increased maintenance overhead

Using NVIDIA responsibly requires:

* kernel version pinning (often LTS)
* careful update sequencing
* driver compatibility tracking
* rollback plans

This conflicts with a **fast-moving, kernel-centric workflow**.

---

### When NVIDIA *does* make sense

NVIDIA may be justified **only if CUDA is a hard requirement**, such as:

* machine learning / deep learning
* CUDA-specific scientific workloads
* proprietary GPU compute pipelines

In those cases:

* NVIDIA should be treated as a **specialized compute dependency**
* ideally isolated to:

  * a dedicated machine
  * a remote box
  * or a pinned-kernel environment

Even then:

* NVIDIA should remain **offload-only**
* never a hard requirement for boot or display

---

## 🎯 Summary

| GPU Vendor | Status        | Reason                                  |
| ---------- | ------------- | --------------------------------------- |
| **Intel**  | ✅ Recommended | Open, stable, kernel-native             |
| **AMD**    | ⏳ Recommended | Open, mature, future-friendly           |
| **NVIDIA** | ❌ Avoided     | Proprietary, fragile on rolling kernels |

---

## Philosophy

This system prioritizes:

* **predictability over peak performance**
* **open drivers over proprietary blobs**
* **kernel alignment over vendor tooling**
* **developer velocity over GPU specialization**

GPU choice is treated as a **dependency decision**, not a benchmark decision.
