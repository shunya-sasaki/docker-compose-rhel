#!/bin/bash
dnf install -y sudo openssh-server

# Create the /var/run/sshd directory
if [ ! -d /var/run/sshd ]; then
    mkdir /var/run/sshd
fi

ssh-keygen -A

# Change the sudoers file to allow passwordless sudo
sed -i "s/^%wheel\s*ALL=(ALL)\s*ALL$/#&/" /etc/sudoers
sed -i "s/^#\s*%wheel\s*ALL=(ALL)\s*NOPASSWD:\s*ALL$/%wheel  ALL=(ALL)    NOPASSWD: ALL/" /etc/sudoers

# Read the user name and password from secret
{
    read -r username
    read -r password
} </run/secrets/my_secrets

# Check if user exists
if id $username &>/dev/null; then
    echo "User $username already exists"
else
    # Create a new user
    useradd -m -s /bin/bash $username
    usermod -aG wheel $username
    echo $username:$password | chpasswd
    sudo -u $username ssh-keygen -t rsa -b 4096 -f /home/$username/.ssh/id_rsa -P ""
    cp /run/secrets/authorized_keys /home/$username/.ssh/authorized_keys
    chown $username:$username /home/$username/.ssh/authorized_keys
fi

# /bin/bash
/usr/sbin/sshd -D
