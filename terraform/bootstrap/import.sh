#!/usr/bin/env bash

read -p "Are you sure you want to import terraform state (y/n)? " verify

if [[ $verify == "y" ]]; then
  echo "Importing bootstrap state"
  ./run.sh import cloudfoundry_service_instance.shared_config_bucket 804abf2a-8993-4201-9ede-3b4da2b1babf
  ./run.sh import cloudfoundry_service_key.config_bucket_creds 1205fa53-d63f-4ea7-a229-0b9e1ccc9bd7
  ./run.sh plan
else
  echo "Not importing bootstrap state"
fi
