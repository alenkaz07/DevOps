#!/bin/bash

sudo apt-get update

# Для установки докера требуется дополнительно загрузить 4 пакета, а именно:

# curl — необходим для работы с веб-ресурсами;
# software-properties-common — пакет для управления ПО с помощью скриптов;
# ca-certificates — содержит информацию о центрах сертификации;
# apt-transport-https — необходим для передачи данных по протоколу HTTPS.

sudo apt-get install curl software-properties-common ca-certificates apt-transport-https -y

# GPG-ключ нужен для верификации подписей ПО.
# Он понадобится для добавления репозитория докера в локальный список.
# Импортируем GPG-ключ:

wget -O- https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null

# Добавление репозитория докера
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable"| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce -y

# Чтобы завершить установку осталось добавить пользователя в группу docker.
# Иначе при запуске утилиты будет ошибка подключения к сокету.
sudo usermod -aG docker $(whoami)
