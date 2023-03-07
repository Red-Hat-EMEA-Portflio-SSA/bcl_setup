##Needs to run form someone with SSH key to connect to the RHEL template used later...
## HandsOnLab@Deployment
## ansible@bastion21
## mschreie@mschreie
## mschreie@rhel9msi.example.com

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


cat << EOF
Usage: 

# Setting up AAP (including bastion host)
ansible-navigator run bcl-install.yml -e @bcl_setup_config/extra_vars.yml -e @bcl_setup_config/vaulted_vars.yml --eei bcl-ov:5 --pp never

# Setting up ESXi, vCenter and VMware
ansible-navigator run bcl-vmw-setup.yml -e @bcl_setup_config/extra_vars.yml -e @bcl_setup_config/vaulted_vars.yml --eei localhost/bcl-ov:4 --pp never

# Adding Usecases into AAP
still missing

Hint: still struggle to get the ONE working Execution Environment in place. That's why there are different versions NEEDED fpr the 2 different plays..


For all 3 plays you can add:
-e remove=true		removes the artifacts created
-e debug=true		enbles debugging output (not consistently implemented yet)
EOF

