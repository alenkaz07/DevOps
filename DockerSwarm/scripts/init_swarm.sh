#!/bin/bash

IP=$(hostname -I | awk '{print $2}')

# Иницициализация
sudo docker swarm init --advertise-addr $IP

# Создание токена для добавления worker узлов
sudo docker swarm join-token worker -q > /vagrant/worker_token.txt

# Сохранение IP в файл
echo $IP > /vagrant/manager_ip.txt
