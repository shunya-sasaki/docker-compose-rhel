#!/bin/bash
dnf install -y sudo openssh-server
mkdir /var/run/sshd
ssh-keygen -A

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
