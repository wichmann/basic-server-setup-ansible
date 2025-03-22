# Setting up a server - Ansible playbooks
Ansible playbooks for setting up and configuring a server and services.

## Requirements
Install ansible first by following the [official handbook](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html):

After that you can install all ansible roles from Ansible Galaxy:

    ansible-galaxy install -r requirements.yml

These scripts require a virtual machine or a bare metal server running Ubuntu
Linux (or a similar distribution) and SSH access with authentication by
password!

## Usage
First, you have to provide all necessary parameters and settings by editing the
files in the directories "group_vars" and "host_vars". Then you have to set the
hostname or IP address of your server in the directory 'inventory/production'.

For accessing the server, you need to create a SSH key on your host machine:

    ssh-keygen -t ed25519

You can check the SSH connection with the following command:

    ansible servers -m ping --user xxxxxx --ask-pass

After that you can just run the first playbook to configure a admin user and
upload your SSH key:

    ansible-playbook initial-setup.yml --extra-vars "ansible_user=pi ansible_password=raspberry"

All following playbook run as the admin user, that was created in the first
playbook and use the uploaded SSH key.

    ansible-playbook infrastructure.yml
    ansible-playbook services.yml

Before you can access the services, the necessary name records have to be
inserted into the file '/etc/hosts':

    192.168.24.xxx  server.internal
    192.168.24.xxx  dashboard.server.internal
    192.168.24.xxx  portainer.server.internal
    192.168.24.xxx  status.server.internal
    192.168.24.xxx  pad.server.internal
    192.168.24.xxx  www.server.internal

## Useful commands
Show full inventory with all variables:

    ansible-inventory --list

Try to log in to all hosts defined in the group 'servers':

    ansible servers -m ping

Simple tasks can be executed manually as [ad hoc commands](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html):

    ansible server-01 -a "/sbin/reboot" -u wichmann
    ansible server-01 -m ansible.builtin.copy -a "src=/etc/hosts dest=/tmp/hosts" -u wichmann
    ansible servers -m ansible.builtin.apt -a "force_apt_get: true upgrade: dist" -u wichmann
    ansible servers -a "sudo systemctl reload alloy" -u wichmann
    ansible servers -m ansible.builtin.service -a "name=alloy state=reloaded" -u wichmann
    ansible all -m ansible.builtin.setup -u wichmann

## Links

* Best practices for directory layout: https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html#content-organization
* Real world example for complex Ansible setup: https://github.com/ct-Open-Source/telerec-t-base
