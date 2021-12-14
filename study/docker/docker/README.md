# docker

## Install

```shell
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker

sudo systemctl start docker

# test
sudo docker run hello-world
```

## Chmod user permission

```shell
sudo groupadd docker

sudo gpasswd -a ${USER} docker

sudo service docker restart

# 然后重开 terminal 即可
```

## Config docker daemon in china

> vim /etc/docker/daemon.json

```vim
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```

> sudo systemctl daemon-reload
> sudo systemctl restart docker
