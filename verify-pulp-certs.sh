#!/bin/bash

# This script uses a Pulp debug certificate to check whether
# the Pulp certificate is signed by the correct CA i.e.
# by katello-server-ca.crt

USAGE="USAGE:
\$ $0 -s SATELLITE_SERVER -o ORGANIZATION_ID [-f OUTPUT_FILENAME]

** EXAMPLES **
\$ $0 -s mysat.example.com -u admin -p mypassword -o 5 -f my-pulp-debug-cert.pem
\$ $0 -s satellite.example.net -u pcollins -p mYpAssw0Rd -o 99   # This will output the certs to stdout"


OUTFILE=/dev/stdout
while getopts "s:u:p:o:f:" OPT; do
   case $OPT in
      "s") SAT="$OPTARG" ;;
      "u") USER="$OPTARG" ;;
      "p") PASS="$OPTARG" ;;
      "o") ORGID="$OPTARG" ;;
      "f") OUTFILE="$OPTARG" ;;
   esac
done

REQUIRED_ARGS="s u p o"
for onearg in $REQUIRED_ARGS; do
   echo "$*" |grep -q "\-${onearg}"
   if [ $? -ne 0 ]; then
      echo "ARGUMENT MISSING: -$onearg"
      echo "$USAGE"
      exit 5
   fi
done



CACERTFILE=/etc/pki/katello/certs/katello-server-ca.crt
APIURL="/katello/api/organizations/${ORGID}/download_debug_certificate"


command="curl -k -u $USER:$PASS https://${SAT}${APIURL} > \"$OUTFILE\""
echo "Running $command"
eval "$command"