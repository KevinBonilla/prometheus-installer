# Mission Statement

To provide system monitoring via node and wmi exporter for Prometheus monitoring:

Features on this repo include:
```
	- Prometheus config files and targets
        - Prometheus install scripts for these architectures:
		- x86
		- ppc64le
		- ppc64
		- s390x
		- darwin-amd64
	- Ansible playbooks for node and wmi exporter
		- Requires 'jq' and 'ssh-keypass' for full automation
		- Supported OS
			- SLES12
			- RedHat6/7
			- CentOS6/7
			- Windows
			- UB16/18
```
- Ansible playbook grabs each bash script based on OS/Arch, for example a RHEL6 x86 vm will run the `node_exporter_x86_systemctl.sh` script

