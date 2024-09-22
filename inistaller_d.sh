#!/bin/bash

# Обновление репозиториев
sudo apt update
echo "Данные репозиториев обновлены"

# Установка необходимых пакетов
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Добавление ключа Docker GPG
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Добавление репозитория Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Повторное обновление репозиториев
sudo apt update
echo "Данные репозиториев обновлены"

# Установка Docker
sudo apt install -y docker-ce

# Проверка статуса Docker
sudo systemctl status docker

# Вывод IP-адреса
ip a

# Настройка MTU в файле конфигурации Docker
file=$(sudo cat /lib/systemd/system/docker.service)
echo "------- file -------"
echo "$file"

template="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock"
replaceTo="ExecStart=/usr/bin/dockerd --mtu 1450 -H fd:// --containerd=/run/containerd/containerd.sock"

result=$(echo "$file" | sed 's|'"$template"'|'"$replaceTo"'|g')
echo "------- result -------"
echo "$result"

echo "$result" | sudo tee /lib/systemd/system/docker.service > /dev/null

# Перезапуск Docker
sudo systemctl daemon-reload
sudo service docker restart

# Добавление пользователя в группу docker
sudo usermod -aG docker mynameromashka

# Переключение на пользователя
su - mynameromashka

# Запуск тестового контейнера
docker run hello-world

echo "Установка Docker завершена!"
