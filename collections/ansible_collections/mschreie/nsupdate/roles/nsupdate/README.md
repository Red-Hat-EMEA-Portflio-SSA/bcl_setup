Role Name
=========

This role adds or deletes A and PTR records to a bind9  dns server.

Requirements
------------

The DNS server needs to be in the ansible inventory and given as a parameter. 
The role connects to that server and executes nsupdate from there. The primary 
zones, which this module can update need to have set "update-policy local" 

Role Variables
--------------

please see the example

Dependencies
------------

I only tested 
 - ipv4 A and PTR records
 - the dns server to be running on RHEL 8
 - the dns server to be a bind nameserver
 - with python3-dns installed on that nameserver
The nsupdate key needs to be foun
I believe any dns server allowing local 

Example Playbook
----------------

This example includes the role to add one server with forward and reverse record
into a nameserver residing on host "bastion"

    - name: include nsupdate
      ansible.builtin.include_role: 
        name: mschreie.nsupdate.nsupdate
      vars:
        record: aap-controller.bcl.redhat.hpecic.com.  # fully correct key (most likely with . at the end)
        value: "10.6.55.2"
        rrtype: "both"              # values: A, PTR or both
        instruction: "add"     # values: add, remove
        nameserver: "bastion"  # needs to be in our inventory


License
-------

BSD

Author Information
------------------

This role is written by mschreie@redhat.com.
