JENKINS_POD=$(kubectl get pods -n jenkins-ns  -o jsonpath='{.items[0].metadata.name}')
PASSWORD=$(kubectl exec -n jenkins-ns $JENKINS_POD -- cat /var/jenkins_home/secrets/initialAdminPassword)
echo "Initial Jenkins admin password: $PASSWORD"
echo $PASSWORD > jenkins_password.txt