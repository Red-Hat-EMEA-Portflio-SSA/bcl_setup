##Needs to run form someone with SSH key to connect to the RHEL template used later...
## HandsOnLab@Deployment
## ansible@bastion21
## mschreie@mschreie
## mschreie@rhel9msi.example.com

echo "start the ssh-agent like this:"
echo "eval `ssh-agent`
#ssh-add ./cic_aap_lab/cic_aap_labs
ssh-add ./cic_aap_lab/bcl_lab
ssh-add -l
echo podman login quay.io
podman login quay.io

echo "set environment by calling:"
echo ". ./cic_aap_lab/env.sh"

echo "then run" 
echo "ansible-navigator run bcl-install.yml -e @cic_aap_lab/extra_vars.yml -e @cic_aap_lab/vaulted_vars.yml"

