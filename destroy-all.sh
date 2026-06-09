#!/bin/bash

set -e

./destroy.sh

echo "Destroying bootstrap..."

cd terraform/bootstrap

terraform destroy -auto-approve