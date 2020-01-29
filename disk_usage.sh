#!/bin/bash
# Test if the disc usage is critical
test $(df / | grep ^/ | awk '{print $4}') -lt 1048576 && echo "Warning: Free disk space is less than 1G on /"

## Show the state
echo "Actual root volume usage:  $(df -h / | grep ^/ | awk '{print $3}') " of $(df -h / | grep ^/ | awk '{print $2}')
