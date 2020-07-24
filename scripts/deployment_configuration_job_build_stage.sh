#Example of IMAGE_NAME => riteshsoni296/apache-php7:latest
IMAGE_NAME="riteshsoni296/simplewebsite"

deployment_name=`echo $IMAGE_NAME| cut -d: -f 1 | awk -F/ '{print $2}'`

# Check if application already deployed
if kubectl get deployment $deployment_name > /dev/null
then
	#Get all running container names from deployment configuration 
	container_name=`kubectl get deploy $deployment_name -o jsonpath="{.spec.template.spec.containers[*].name}"`

	#Rollout of new application
	kubectl set image deployment/$deployment_name $container_name=$IMAGE_NAME
	# Wait for the rollout to be complete
	if ! kubectl rollout status deploy/$deployment_name | grep success
	then
		echo "Rollout of new Application Failed"
		exit 1
	fi

#If application is not yet deployed
else
	# Create new deployment for the application
	if kubectl create deployment $deployment_name --image $IMAGE_NAME
	then
		#Wait till the pods are in running state
		while [ -z "$(kubectl get pods -n $DEPLOYMENT_NAME -l app=$DEPLOYMENT_NAME -o jsonpath=\"{.items[*].status.containerStatuses[*].state.running}\"))" ]
		do
			sleep 5
		done

		#Expose the application using service
		kubectl expose deployment/$deployment_name --port 80 --type=NodePort
	else
		echo "Failed to create a deployment"
		exit 1
	fi
fi 

