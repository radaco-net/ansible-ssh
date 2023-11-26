#!/bin/bash

# Ask for remote IP or URL
read -p "Enter the remote IP or URL: " remote_ip

# Ask for SSH port
read -p "Enter the SSH port (default 22): " ssh_port
ssh_port=${ssh_port:-22}

# Ask for root user (default root)
read -p "Enter the root user (default root): " root_user
root_user=${root_user:-root}

# Ask for password
read -s -p "Enter the password: " password
echo  # Move to the next line


echo  # Move to the next line

# Check if SSH key exists
ssh_key_path="$HOME/.ssh/id_rsa"
if [ ! -f "$ssh_key_path" ]; then
    # Generate SSH key if not exists
    ssh-keygen -t rsa -b 4096 -f "$ssh_key_path" -N ""
fi

# Copy SSH public key to remote authorized_keys
sshpass -p "$password" ssh-copy-id -i "$ssh_key_path.pub" -p "$ssh_port" "$root_user@$remote_ip"

# Test SSH connection for passwordless authentication
yes | ssh -o StrictHostKeyChecking=no -p "$ssh_port" "$root_user@$remote_ip" "echo OK"

# Check the result
if [ $? -eq 0 ]; then
    echo "Connection successful. Passwordless authentication is set up."
else
    echo "Error: Passwordless authentication setup failed."
fi


