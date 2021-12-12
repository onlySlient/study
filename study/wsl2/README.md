# wsl2

> <https://docs.microsoft.com/fr-fr/windows/wsl/>

## Install wsl2

```shell
# 安装默认linux发行版
wsl --install

# 通过 -d 更改版本
wsl --install -d <Distribution Name>

# 通过在线商店查看发行版列表
wsl --list --online
wsl -l -o
```

## Install centos on wsl2

```shell
# 开启虚拟机平台
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 以下两种使能方式二选一
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

# 将wsl2设置为默认版本
wsl --set-default-version 2

# 重启操作系统

# 查看wsl已安装的子系统
wsl --list --verbose

# 安装 Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# 安装 LxRunOffline
choco install lxrunoffline

# 重开Powershell

# 下载github包：https://github.com/CentOS/sig-cloud-instance-images，切换到指定分支，下载*.tar.xz文件
# 切换到下载位置

LxRunOffline install -n 自定义系统名称 -d 安装目录路径 -f tar.xz安装包路径
# 注意windows系统命令行中的文件路径和linux系统差别很大
# 比如我这里的安装命令就是
LxRunOffline.exe install -n centos -d D:/centos -f .\centos-7-x86_64-docker.tar.xz
# 将centos安装到D盘的centos文件夹下，并且命名为centos

LxRunOffline run -n 自定义系统名称
wsl -d 自定义系统名称
```

## 升级centos为wsl2

``` shell
# 列出已经安装的wsl的信息
wsl -l -v
# 将对应的wsl设为wsl2，注意<Distro>要和上面查询到的信息一致
wsl --set-version centos 2
# 设置默认使用的发行版
wsl -s centos
```

## centos 配置

更新

> yum update && yum upgrade

添加一个新的用户

```shell
adduser slient
passwd slient

# 赋权
```

## ubuntu 配置

更换源

```shell
sudo vim /etc/apt/sources.list

deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse

sudo apt-get update && apt-get upgrade
```

添加用户

```shell
apt-get install sudo -y

adduser slient sudo
chmod  0440  /etc/sudoers
sudo adduser slient
```

## 问题

> 参考的对象类型不支持尝试的操作

<https://github.com/microsoft/WSL/issues/4177>  
注： 在管理员的Powershell下使用`NoLsp.exe c:\windows\system32\wsl.exe`命令
