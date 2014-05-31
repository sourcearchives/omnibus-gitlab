#!/bin/bash

# Generate a build ID based on the current time and the PID of this script
build="$(date '+%s')-$$"

# Do the build and capture its output in a .log file
make do_release 2>&1 | tee -a ${build}.log

# Check the exit status of `make`, not `tee`
if [[ ${PIPESTATUS[0]} -eq 0 ]]; then
  subject="omnibus-gitlab build ${build} SUCCESS"
else
  subject="omnibus-gitlab build ${build} FAIL"
fi

# We assume that email to the current system user will somehow reach the right
# human eyes
tail -15 ${build}.log | mail -s "${subject}" $(whoami)
