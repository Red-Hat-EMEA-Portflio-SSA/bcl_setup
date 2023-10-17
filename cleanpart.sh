#!/bin/sh
# find all disks not being the root disk and delete the partitions

# if debug is 1 loads of debug is written to stderr
debug=${debug:-0}

# if armed is 1 partitions get deleted - be careful no guarantie
armed=${armed:-0}

if [ $1 == "-h" ] ; then
  cat << EOF

  $0

Deletes partitions on an ESXi server in order to clean the disk up for being used again.
If the pyhsical server was part of a vsan cluster but ESXi got reinstalled, partitions still reside on the data disks preventing 
the disk to be used again for e.g. vsan.
This script deletes these vsan partitions.
The script avoids deleting partitionson the boot disk.
The sript understand 2 environment variables:
   debug=1 prints out a lot of debug messages to stderr
   armed=1 actually deletes the partitions
EOF
  exit 9
fi
# find the root disk / boot disk first:
bootdisk=$(esxcli storage core device list | awk -v debug=$debug '
  /^naa/  {
    device_path = $NF
    if (debug) { print "debug: device_path:", device_path > "/dev/stderr" }
    while ($0 !~ /Is Boot Device/) { 
      if (debug) {  print "debug: within while loop:", $0 > "/dev/stderr" }
      getline
    }
    if (debug) {  print "debug: AFTER while loop:", $0 > "/dev/stderr" }
    if ( $NF == "true" ) {
       if (debug) {   print "debug: line found:", $0 > "/dev/stderr" }
       found = device_path
       exit 0
    }
    else {
      next
    }
  } 
  END { 
    if (found) {
      print found
    } else {
      print "Can not find boot device" > "/dev/stderr"
      exit 1
    }
  }
') 

echo "INFO: boot disk found: $bootdisk"

[ $debug == 1 ] && {
   echo DEBUG: list of all disk paths found, no sym-links  without boot disk 1>&2
   ls -ltrh /vmfs/devices/disks/  | awk '/^-.*naa\.[^:]*$/ { print $NF}' | grep -v $bootdisk >&2
}
ls -ltrh /vmfs/devices/disks/  | awk '/^-.*naa\.[^:]*$/ { print $NF}' | grep -v $bootdisk | while read dev
do
   [ $debug == 1 ] && {
      ls /vmfs/devices/disks/$dev:[34567890]* 2>&1 | grep -q "No such file or directory" && echo DEBUG: $dev ok >&2
   }
   ls /vmfs/devices/disks/$dev:[34567890]* 2>&1 | grep -q "No such file or directory" || {
      echo "ERROR: device $dev has partitions 3,4,5,6,7,8,9 or 0" >&2
      exit 2
   }
done 

ls -ltrh /vmfs/devices/disks/  | awk '/^-.*naa\.[^:]*$/ { print $NF}' | grep -v $bootdisk | while read dev
do
   echo INFO: partedUtil delete "vmfs/devices/disks/$dev" 1 >&2 
   [ $armed == 1 ] && { partedUtil delete "vmfs/devices/disks/$dev" 1
   } 
   echo INFO: partedUtil delete "vmfs/devices/disks/$dev" 2 >&2 
   [ $armed == 1 ] && { partedUtil delete "vmfs/devices/disks/$dev" 2
   }
done 
[ $armed != 1 ] && { echo "INFO: Did not change anything you need to set armed=1 to actually delete partitions" >&2 
}
