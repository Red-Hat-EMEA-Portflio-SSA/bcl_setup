# Repo to set up BCL Lab environment in CIC
# you need VPN connection to CIC
# you need credentials to log int to CIC VCenter

# Needs two or three self created collections:
# if not solved via execution environment you need to put:
git@github.com:Red-Hat-EMEA-Portflio-SSA/collection_portfoliossa_nsupdate.git
into:  collections/ansible_collections/portfoliossa/nsupdate

git@github.com:Red-Hat-EMEA-Portflio-SSA/collection_portfoliossa_resolver.git
into:  collections/ansible_collections/portfoliossa/resolver

and:
git@github.com:Red-Hat-EMEA-Portflio-SSA/collection_portfoliossa_bcl.git
into   collections/ansible_collections/portfoliossa/bcl


##Needs to run form someone with SSH key to connect to the RHEL template used later...
## HandsOnLab@Deployment
## ansible@bastion21
## mschreie@mschreie
## mschreie@rhel9msi.example.com

# I'm working with an execution environment, which has included all pyhton modules and the needed 
# content collections (including the three above).
# bcl-ov:8 is the current ee used.
#   the definition is based on the definition of:
#      quay.io/redhat_emp1/ee-ansible-ssa:2.x.x.x
#   includes:
#    hpeOneView                8.1.0     HPE OneView Python Library
#    hpICsp                    1.0.2     HP Insight Control Server Provisioning Python Library
#    pyvmomi                   8.0.0.1.2 VMware vSphere Python SDK
#    PyYAML                    5.4.1     YAML parser and emitter for Python
#    requests                  2.25.0    Python HTTP for Humans.
#    vapi-client-bindings      4.0.0     vapi client bindings for VMware vSphere Automation
#    vapi-common-client        2.37.0    vAPI Common Services Client Bindings
#    vapi-runtime              2.37.0    vAPI Runtime
# works best when not collections_path in ansible.cfg is not set
#       ##collections_paths = ./collections


# configuration:
I'm using this repo with an additional, private configuration repository, found in the directory as ./bcl_setup_config
this directory provides private and public ssh-keys, credentials and an extra_vars file. For your convenience i moved 
the extra_vars.yml file into this current repository. It references vault_ -variables, which you would need to set up 
yourself. 


Before starting download ansible-automation-platform-setup-2.3-2.tar.gz 
and ensure the that within ./extra_vars.yml
controller_version: "2.3-2"
is set correctly and accordingly.

echo "start the ssh-agent like this:"
echo "eval `ssh-agent`
#ssh-add ./bcl_setup_config/cic_aap_labs
ssh-add ./bcl_setup_config/bcl_lab
ssh-add -l
echo podman login quay.io
podman login quay.io

echo podman login registry.redhat.io
podman login registry.redhat.io


echo "set environment by calling:"
echo ". ./bcl_setup_config/env.sh"


Usage: 

# Setting up AAP (including bastion host)
ansible-navigator run 01-bcl-install.yml -e @extra_vars.yml -e @bcl_setup_config/vaulted_vars.yml --eei bcl-ov:4 --pp never

# Setting up ESXi, vCenter and VMware
ansible-navigator run 02-bcl-vmw-setup.yml -e @extra_vars.yml -e @bcl_setup_config/vaulted_vars.yml --eei localhost/bcl-ov:4 --pp never

# Adding Usecases into AAP
see seperate repo

For all 3 plays you can add:
-e remove=true		removes the artifacts created
-e debug=true		enbles debugging output (not consistently implemented yet)


I've added some test-.. plays to the repo. Most likely they are not needed anymore, but their existance does not harm either.
