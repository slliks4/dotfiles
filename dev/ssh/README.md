# SSH

This section covers the **basic SSH setup** used during installation.

SSH allows controlling the system remotely from another computer, which can make the Arch installation process easier.

For now this guide covers:

* installing SSH
* enabling the service
* connecting from another system

More advanced SSH configuration will be documented later.

---

# Install SSH (Live ISO)

Install the OpenSSH package:

```bash
pacman -Sy openssh
```

Enable and start the SSH service:

```bash
systemctl enable sshd
systemctl start sshd
```

---

# Set a Password

SSH login requires a password.

Set a password for the current user (or root):

```bash
passwd
```

---

# Find the System IP Address

Check the system's IP address:

```bash
ip a
```

Look for an address under your network interface (for example `eth0` or `wlan0`).

Example:

```
192.168.1.50
```

---

# Connect From Another Machine

From another computer on the same network:

```bash
ssh user@IP_ADDRESS
```

Example:

```bash
ssh root@192.168.1.50
```

Replace `user` with the username you want to log in as.

During installation this is usually `root`.

---

# Basic SSH Commands

Disconnect from SSH:

```bash
exit
```

or press:

```
Ctrl + D
```

---

# Notes

* SSH is useful for installing Arch from another computer.
* Both machines must be on the **same network**.
* If connection fails, verify:

  * the SSH service is running
  * the IP address is correct
  * a password has been set

---

# Future Topics

This section will expand later to include:

* SSH key authentication
* disabling password login
* SSH config file
* port changes and hardening
* SSH agent
* port forwarding
* tunneling
* using SSH with Git
