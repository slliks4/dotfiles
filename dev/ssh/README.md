## Install and start SSH on the live ISO:

```bash
pacman -Sy openssh
systemctl enable sshd
systemctl start sshd
ip a
```

Note you must set password using because this is required for ssh
```bash
passwd
```

From another system:

```bash
ssh user@<IP>
```

user is for the user, it could be root, or whatever


MORE THINGS TO BE DISCUSSED AS I PROGRESSIVELY LEARN SSH

For now this is the basics
