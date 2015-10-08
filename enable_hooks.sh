#!/bin/bash
#
# Enable all supplied git hooks.  Cannot be done automatically due to security
# concerns.  Developers working on this module are recommended to run this 
# script once code has been checked out to prevent committing code with syntax
# errors
for FILE in hooks/* ; do
  cp $FILE .git/$FILE
done
