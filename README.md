# shifting-schedule

# on jump host:
1. sudo usermod -aG docker jenkins
2. sudo systemctl restart jenkins

# on jenkins ui:
1. Manage Jenkins > Credentials > Add your Docker Hub Credentials
   - ID = "docker_credentials"

# on pipeline:
1. pipeline name "mini-proj"

# to access shift_sched
1. k exec -it $(kubectl get pods -o name | grep mini-proj-app | cut -d'/' -f2 | shuf -n 1) -c shift-sched-container  -- ./shift_sched.sh
