#!/bin/bash

./destroy.sh

echo "Destroying bootstrap..."

cd bootstrap

terraform destroy -auto-approve