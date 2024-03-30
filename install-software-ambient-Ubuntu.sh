#!/bin/bash

# Access as root
sudo -u

sudo apt-get update

sudo apt list --upgradable

# Lista de software a ser instalado
software=(
  "curl" 
  "software-properties-common" 
  "ubuntu-restricted-extras" 
  "gdebi" 
  "chrome-gnome-shell" 
  "gnome-shell-extensions" 
  "flameshot" 
  "gnome-tweak-tool" 
  "network-manager-openvpn-gnome" 
  "nfs-common" 
  "libxss1"
  "libappindicator1" 
  "libindicator7" 
  "sublime-text"
)

# Verifica se o usuário possui permissões de superusuário
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script precisa ser executado com privilégios de superusuário." 1>&2
  exit 1
fi

# Atualiza o sistema e o gerenciador de pacotes
sudo apt update
sudo apt upgrade -y

# Loop para instalar cada software na lista
for s in "${software[@]}"; do
  echo "Instalando $s ..."
  apt install -y "$s"
  if [ $? -eq 0 ]; then
    echo "$s instalado com sucesso!"
  else
    echo "Erro ao instalar $s. Abortando..."
    exit 1
  fi
done


# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# install docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# docker
apt-get install docker-ce -y
groupadd docker
usermod -aG docker germano

systemctl enable docker
systemctl disable docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

chown san:san /home/san/.docker -R
chmod g+rwx "/home/san/.docker" -R

echo "Todos os softwares foram instalados com sucesso."
