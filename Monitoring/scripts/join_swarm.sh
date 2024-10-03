#!/bin/bash

# Получение IP адреса менеджера и токена
# MANAGER_IP=$(cat /vagrant/manager_ip.txt)
TOKEN=$(cat /vagrant/worker_token.txt)

# Подкдючение к Docker Swarm
sudo docker swarm join --token $TOKEN 192.168.56.10:2377
