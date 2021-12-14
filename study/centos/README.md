# centos

## Install

TODO

## 解决用户无法sudo问题

```shell
yum update

yum install vim

# 普通用户的sudo权限
chmod u+w /etc/sudoers
# 添加`centos ALL=(ALL) ALL`
chmod u-w /etc/sudoers
```

## 解决初始化的centos没有网络的问题

```shell
sudo vi /etc/sysconfig/network-script/ifcfg-enp0s3

# onboot=no 改成 yes

sudo service network start
```
