kubectl delete -R -f k8s/

echo "Waiting for Load Balancers to disappear..."

while true
do
  COUNT=$(aws elb describe-load-balancers \
    --region eu-central-1 \
    --query "length(LoadBalancerDescriptions)" \
    --output text)

  if [ "$COUNT" = "0" ]; then
    break
  fi

  sleep 15
done

echo "Load Balancers deleted."

echo "Waiting 60 more seconds for ENI and Security Group cleanup..."

sleep 60

cd terraform

terraform destroy -auto-approve