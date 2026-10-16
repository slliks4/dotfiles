# SSH — Basic Setup

This section covers the **basic SSH setup** used during installation.

SSH allows controlling the system remotely from another computer, which can simplify the Arch installation process.

This guide covers:

- installing SSH
- enabling the service
- connecting from another system

More advanced configuration will be documented later.

---

# Install SSH (Live ISO)

Install the OpenSSH package:

```bash
pacman -Sy openssh
````

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

Look for an address under your network interface (e.g. `eth0`, `wlan0`).

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

Replace `user` with the target username.

During installation this is typically `root`.

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

* Both machines must be on the same network.
* If connection fails, verify:

  * SSH service is running
  * IP address is correct
  * password has been set

---

# Future Topics

This section will expand to include:

* SSH key authentication
* disabling password login
* SSH config (`~/.ssh/config`)
* port changes and hardening
* SSH agent
* port forwarding and tunneling
* using SSH with Git
