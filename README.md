# REpo to set up BCL Lab environment in CIC
# you need VPN connection to CIC
# you need credentials to log int to CIC VCenter

# Needs two or three self created collections:
# if not solved otherwise you need to put:
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

# I'm working with execution environments, whihc are needed for the different
# moduels. I do not have one EE which just works for everything due to 
# dependencies.
# bcl-ov:1
#   base:
#      quay.io/redhat_emp1/ee-ansible-ssa:2.0.0.1 
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
ansible-navigator run bcl-install.yml -e @bcl_setup_config/extra_vars.yml -e @bcl_setup_config/vaulted_vars.yml --eei bcl-ov:4 --pp never

# Setting up ESXi, vCenter and VMware
ansible-navigator run bcl-vmw-setup.yml -e @bcl_setup_config/extra_vars.yml -e @bcl_setup_config/vaulted_vars.yml --eei localhost/bcl-ov:4 --pp never

# Adding Usecases into AAP
still missing

For all 3 plays you can add:
-e remove=true		removes the artifacts created
-e debug=true		enbles debugging output (not consistently implemented yet)


I've added some test-.. plays to the repo. Most likely they are not needed anymore, but their existance does not harm either.
