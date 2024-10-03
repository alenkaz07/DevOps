#!/bin/bash

# Получение IP адреса менеджера и токена
MANAGER_IP=$(cat /vagrant/manager_ip.txt)
TOKEN=$(cat /vagrant/worker_token.txt)

# Подкдючение к Docker Swarm
sudo docker swarm join --token $TOKEN $MANAGER_IP:2377

