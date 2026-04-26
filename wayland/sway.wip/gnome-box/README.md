## 🧠 Why GNOME Boxes is right for you

You don’t need GPU passthrough, multi-network bridges, or heavy Windows gaming performance — you mainly need:

* Fast setup for **ICPC images** (prebuilt Linux environments),
* Occasional quick **Windows** runs for utilities,
* A simple sandbox to test distros like **Kali** or **Fedora**.

✅ **GNOME Boxes** gives you that simplicity: drag an ISO in → click “Create” → done.
It uses **KVM** under the hood, so performance is *native-level*, not slow like VirtualBox.

---

## ⚙️ Install everything you need (Arch)

Run these commands:

```bash
sudo pacman -S gnome-boxes qemu libvirt edk2-ovmf dnsmasq
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt $USER
newgrp libvirt
```

That installs:

* `gnome-boxes` → your frontend,
* `qemu` → the virtualization engine,
* `libvirt` → the VM manager backend,
* `edk2-ovmf` → UEFI firmware for modern guests,
* `dnsmasq` → simple network for VMs.

After that, launch it with:

```bash
gnome-boxes
```

---

## 🧩 Running ICPC and distro images

### 🔹 ICPC context image

* Most ICPC images are `.qcow2` or `.img` files (QEMU format).
* Just click **“+” → “Create a Virtual Machine” → “Select a file”**, and pick your `.qcow2` or `.iso`.
* Allocate at least **2 CPU cores** and **4 GB RAM** (8 GB if available for full IDE setups).

If Boxes doesn’t detect the image type automatically, select “Other OS” → continue anyway — it’ll boot fine.

### 🔹 Testing Kali or other Linux ISOs

* Drag the ISO file into the Boxes window.
* Allocate around **2–4 GB RAM** and **20 GB storage**.
* Kali’s network tools work out of the box since Boxes uses a NAT bridge (no config required).

---

## 💡 Optional tweaks for smoother workflow

### 1️⃣ Shared clipboard & drag-and-drop

GNOME Boxes supports clipboard sync and file drag if **SPICE guest tools** are installed inside the VM:

```bash
sudo apt install spice-vdagent  # Debian/Kali/Ubuntu
```

That lets you copy text or files between host ↔ guest.

### 2️⃣ Auto-resize display

If the VM doesn’t resize with your window, inside guest install:

```bash
sudo apt install spice-vdagent
```

Then it will dynamically match your host resolution.

### 3️⃣ Use snapshots (for ICPC)

Before testing big config changes, right-click your VM → “Take Snapshot.”
You can revert to that state instantly.

---

## 🪄 If you ever outgrow Boxes

Later, if you want more control (CPU pinning, PCI devices, bridge networking), install:

```bash
sudo pacman -S virt-manager
```

`virt-manager` will automatically see your GNOME Boxes VMs (they share the same libvirt backend).
So you can start with Boxes and graduate to advanced control later — no migration needed. ✅

---

## 🧾 TL;DR Setup Plan

| Task                    | Recommendation                      |
| ----------------------- | ----------------------------------- |
| Quick Linux/ICPC images | **GNOME Boxes** (simple + fast)     |
| Windows testing         | Use Boxes + OVMF (UEFI) + 8 GB RAM  |
| Networking              | Default NAT (no setup)              |
| Shared clipboard/files  | Install `spice-vdagent` in guest    |
| Snapshot/restore        | Use Boxes’ built-in snapshots       |
| Want more control later | Try **virt-manager** (same backend) |

---

### ✅ Recommended minimal resources

| Use case                 | vCPU | RAM    | Disk  |
| ------------------------ | ---- | ------ | ----- |
| ICPC / Ubuntu image      | 2    | 4 GB   | 20 GB |
| Kali / Pen-testing tools | 2    | 4–6 GB | 25 GB |
| Windows utility use      | 4    | 8 GB   | 40 GB |

---

You’re absolutely on the right track — install **GNOME Boxes**, drop in your ICPC `.qcow2` or `.iso`, and you’ll be up and running in minutes.

Would you like me to show you a **lightweight XML/libvirt config template** for ICPC/Kali VMs (so you can quickly clone new ones with `virt-manager` later)?
