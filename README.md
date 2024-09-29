# shifting-schedule

on jump host:
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

on jenkins ui:
Manage Jenkins > Credentials > add mo Docker Hub Credentials eto ilagay mo sa ID = "docker_credentials"

on pipeline:
1. pipeline name "mini-proj"
2. change master to main
