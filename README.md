# 20210928-IBN-Demo

This project runs Terraform + Ansible demo for ISE. At a high level it does the following:

Terraform:
- Setup VPC and other networking resources
- Setup ISE instances
- Setup AWS Network Load Balancer
- Setup Route 53 entries
- Create Ansible varaibles file

Ansible:
- Setup AD
- Add sample groups & users
- Add sample network devices
- add sample policy sets
- For a deployment between the two ISE nodes

This has been tested and supports Cisco ISE 3.1.

## Requirements
- Ansible >= 2.9
- Terraform >= 1.0.7
- [Cisco ISE SDK](https://github.com/CiscoISE/ciscoisesdk) v1.0.0 or newer
- Python >= 3.6, as the Cisco ISE SDK doesn't support Python version 2.x

## Install
Terraform must be installed
Ansible must be installed
```
sudo pip install ansible
```

Cisco ISE SDK must be installed
```
sudo pip install ciscoisesdk
```

Install the collection
```
ansible-galaxy collection install cisco.ise
```

## Use
First, initialize Terraform:
```
terraform init
```

Rename the included `terraform.samplevars` to `terraform.tfvars` file and modify to suit your environment:
```
mv terraform.samplevars terraform.tfvars
```

Modify the userdata entry in both ISE instances in the `aws_instance.tf` file. Note the username `admin` should not be changed and the `password` entry should be more than 8 characters long and have at least one of each; lowe, upper, and a number

Apply the configuration
```
terraform apply
```

This will take about 30 mintes for ISE instances to be fully booted up. Once both nodes can be accessed via GUI, you can run the ansible playbook.
```
cd ansible
ansible-playbook demo_all.yml
```

Once demo finishes, you can run following to remove the setup in AWS:
```
terraform destroy
```

Note that the Terraform process creates the Ansible variables file `vars.yml` upon completion and as such if running the Ansible playbook without running the Terraform file, then copy the content of the `ansible_var.tpl` file to `ansible/vars.yml` file manually.

The examples found on the `playbooks` directory uses the `group_vars` variables. Consider using `ansible-vault` to encrypt the file that has the `ise_username` and `ise_password`.

## Attention macOS users

If you're using macOS you may receive this error when running your playbook:

```
objc[34120]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called.
objc[34120]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called. We cannot safely call it or ignore it in the fork() child process. Crashing instead. Set a breakpoint on objc_initializeAfterForkError to debug.
ERROR! A worker was found in a dead state
```

If that's the case try setting these environment variables:
```
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export no_proxy=*
```

You can also run the following:
```
cd ansible
source source_me.sh
```

## License

The examples in this repository are licensed under the [Cisco Sample Code License](https://developer.cisco.com/site/license/cisco-sample-code-license/).
