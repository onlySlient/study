# frp

> <https://github.com/fatedier/frp>  
> frp 是一个专注于内网手机的终端的中转应用，支持TCP、UDP、HTTP可以HTTPS、等多种协议。将内网服务以安全、便捷的方式通过具有公网IP节点的中转暴露到公网。

## 优缺点

* 优点
  * 开源，免费
* 缺点
  * ssh不稳定，经过测试`ssh`、`p2p_ssh(stcp)`，这两者都不稳定

## install on docker-compose

`frps`

```shell
docker-compose up -d
```

```yml
version: '3.9'

services:
  frps:
    image: snowdreamtech/frps
    hostname: "frps"
    restart: always
    expose:
      - 7000
      - 7500
      - 6000
    network_mode: "host"
    volumes:
      - "/opt/infra/frps/frps.ini:/etc/frp/frps.ini"
```

`frpc`

```shell
docker-compose up -d
```

```yml
version: '3.9'

services:
  frpc:
    image: snowdreamtech/frpc
    hostname: "frpc"
    restart: always    
    network_mode: "host"
    volumes:
      - "/opt/infra/frpc/frpc.ini:/etc/frp/frpc.ini"
```

* 启动时由于本地没有对应的配置文件而导致启动失败，可以通过`docker run`临时运行一个容器，将容器中的配置文件通过`docker cp`拷贝出来，进而再通过`docker-compose up -d`开启服务

## Configuration file

### SSH

```ini
# frps.ini
[common]
bind_port = 7000

# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000 # 此端口用于远程ssh连接的端口,即服务器暴露的ssh端口

# ssh connect
ssh -p 6000 root@x.x.x.x
```

### WEB

```ini
# frps.ini
[common]
bind_port = 7000
vhost_http_port = 8080

# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000

[web]
type = http
local_port = 80
custom_domains = x.x.x.x # 服务器ip或者域名

# 开启一个nginx
docker run -itd --name nginx -p 80:80 nginx
# 访问服务
curl -I http://x.x.x.x:8080
```

### DNS

```ini
# frps.ini
[common]
bind_port = 7000

# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000

[dns]
type = udp
local_ip = 8.8.8.8
local_port = 53
remote_port = 6000

# try
dig @x.x.x.x -p 6000 www.google.com
```

### Forward Unix domain socket

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000

[unix_domain_socket]
type = tcp
remote_port = 6000
plugin = unix_domain_socket
plugin_unix_path = /var/run/docker.sock

# 获取docker版本
curl http://x.x.x.x:6000/version
```

### Expose a simple http file server

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000

[test_static_file]
type = tcp
remote_port = 6000
plugin = static_file
plugin_local_path = /tmp/files
plugin_strip_prefix = static
plugin_http_user = abc
plugin_http_passwd = abc
```

> 该项尝试失败,原因未找到，现象：配置完成后，返回404

### HTTPS

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000

[test_https2http]
type = https
custom_domains = x.x.x.x # 服务器域名或者ip

plugin = https2http
plugin_local_addr = 127.0.0.1:9001
plugin_crt_path = ./server.crt
plugin_key_path = ./server.key
plugin_host_header_rewrite = 127.0.0.1
plugin_header_X-From-Where = frp

# 创建证书
openssl genrsa -out private.key 2048
openssl req -new -x509 -nodes -days 730 -key private.key -out public.crt -config openssl.conf

# 开启minio服务
docker run --name minio -p 9000:9000 -p 9001:9001 -v /opt/infra/minio/:/root/.minio/certs/ -itd minio/minio server /data --console-address ":9001"

# 通过浏览器验证
https://x.x.x.x:7000
```

> 该项失败，由于不懂ssl/tls证书

### STCP

```ini
# client A
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000

[secret_ssh]
type = stcp
sk = abcdefg
local_ip = 127.0.0.1
local_port = 22

# client B
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000

[secret_ssh_visitor]
type = stcp
role = visitor
server_name = secret_ssh
sk = abcdefg
bind_addr = 127.0.0.1
bind_port = 6000

# ssh
ssh -p 6000 127.0.0.1
```

> TODO 鉴于目前没有需求，待手动操作以下

### p2p

> xtcp设计用于在客户端之间直接传输大量数据。frps服务器还是需要的，这里的P2P只是指实际的数据传输。  
>  
> 请注意，它无法穿透所有类型的 NAT 设备。如果xtcp不起作用，您可能想要回退到 stcp。

```ini
# frps.ini server
bind_udp_port = 7001

# frpc.ini client A
[common]
server_addr = x.x.x.x
server_port = 7000

[p2p_ssh]
type = xtcp
sk = abcdefg
local_ip = 127.0.0.1
local_port = 22

# frpc.ini client B
[common]
server_addr = x.x.x.x
server_port = 7000

[p2p_ssh_visitor]
type = xtcp
role = visitor
server_name = p2p_ssh
sk = abcdefg
bind_addr = 127.0.0.1
bind_port = 6000

# ssh
ssh -p 6000 127.0.0.1
```

## Environment variables

```ini
# frpc.ini
[common]
server_addr = {{ .Envs.FRP_SERVER_ADDR }}
server_port = 7000

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = {{ .Envs.FRP_SSH_REMOTE_PORT }}
```

```shell
export FRP_SERVER_ADDR="x.x.x.x"
export FRP_SSH_REMOTE_PORT="6000"
./frpc -c ./frpc.ini
```

## include

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000
includes=./confd/*.ini

# ./confd/test.ini
[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000
```

## Dashboard

```ini
[common]
dashboard_port = 7500
# dashboard's username and password are both optional
dashboard_user = admin
dashboard_pwd = admin
```

## Admin UI

```ini
# frpc.ini
[common]
admin_addr = 127.0.0.1
admin_port = 7400
admin_user = admin
admin_pwd = admin

# curl
curl -I http://127.0.0.1:7400
```

## prometheus

```ini
# frps.ini
enable_prometheus = true

# visit `http://{dashboard_addr}/metrics`
```

## Authenticating the Client

```ini
[common]
authenticate_heartbeats = true # 开启心跳和认证方法
authenticate_new_work_conns = true # do the same for every new work connection between frpc and frps.

authentication_method = token # 指定token认证
```

### OIDC认证

> <https://github.com/fatedier/frp#oidc-authentication>

```ini
# frps.ini
[common]
authentication_method = oidc
oidc_issuer = https://example-oidc-issuer.com/
oidc_audience = https://oidc-audience.com/.default
# frpc.ini
[common]
authentication_method = oidc
oidc_client_id = 98692467-37de-409a-9fac-bb2585826f18 # Replace with OIDC client ID
oidc_client_secret = oidc_secret
oidc_audience = https://oidc-audience.com/.default
oidc_token_endpoint_url = https://example-oidc-endpoint.com/oauth2/v2.0/token
```

> 第三方认证，暂不考虑，需要代理

## Encryption and Compression

```ini
# frpc.ini
[ssh]
type = tcp
local_port = 22
remote_port = 6000
use_encryption = true
use_compression = true
```

## TLS

> <https://github.com/fatedier/frp#tls>

```ini
# frps
[common]
tls_only = true
tls_enable = true
tls_cert_file = certificate.crt
tls_key_file = certificate.key
tls_trusted_ca_file = ca.crt

# frpc
[common]
tls_enable = true
tls_cert_file = certificate.crt
tls_key_file = certificate.key
tls_trusted_ca_file = ca.crt
```

## hot reload

```ini
# frpc.ini
[common]
admin_addr = 127.0.0.1
admin_port = 7400

# verify config is ok
frpc verify -c ./frpc.ini

# reload
frpc reload -c ./frpc.ini
```

## proxy status

```shell
frpc status -c ./frpc.ini
```

## allow ports

```ini
# frps.ini
[common]
allow_ports = 2000-3000,3001,3003,4000-50000
```

## Port Reuse

`vhost_http_port` and `vhost_https_port` in frps can use same port with bind_port

## Bandwidth Limit

```ini
# frpc.ini
[ssh]
type = tcp
local_port = 22
remote_port = 6000
bandwidth_limit = 1MB
```

## TCP Stream Multiplexing

```ini
# frps.ini and frpc.ini, must be same
[common]
tcp_mux = false
```

## KCP Protocol

```ini
# frps.ini
[common]
bind_port = 7000
# Specify a UDP port for KCP.
kcp_bind_port = 7000

# frpc.ini
[common]
server_addr = x.x.x.x
# Same as the 'kcp_bind_port' in frps.ini
server_port = 7000
protocol = kcp
```

## Connection pool

```ini
# frps.ini
[common]
max_pool_count = 5

# frpc.ini
[common]
pool_count = 1
```

## Load balancing

> This feature is only available for types tcp, http, tcpmux now

```ini
# frpc.ini
[test1]
type = tcp
local_port = 8080
remote_port = 80
group = web
group_key = 123

[test2]
type = tcp
local_port = 8081
remote_port = 80
group = web
group_key = 123
```

> For type `tcp`, `remote_port` in the `same group` should be the same.  
> For type `http`, `custom_domains`, `subdomain`, `locations` should be the same.

## Service Health Check

```ini
# tcp
# frpc.ini 
[test1]
type = tcp
local_port = 22
remote_port = 6000
# Enable TCP health check
health_check_type = tcp
# TCPing timeout seconds
health_check_timeout_s = 3
# If health check failed 3 times in a row, the proxy will be removed from frps
health_check_max_failed = 3
# A health check every 10 seconds
health_check_interval_s = 10

# http
# frpc.ini
[web]
type = http
local_ip = 127.0.0.1
local_port = 80
custom_domains = x.x.x.x
# Enable HTTP health check
health_check_type = http
# frpc will send a GET request to '/status'
# and expect an HTTP 2xx OK response
health_check_url = /status
health_check_timeout_s = 3
health_check_max_failed = 3
health_check_interval_s = 10
```

## Rewriting the HTTP Host Header

```ini
# frpc.ini
[web]
type = http
local_port = 80
custom_domains = test.example.com
host_header_rewrite = dev.example.com
```

## Setting other HTTP Headers

```ini
# frpc.ini
[web]
type = http
local_port = 80
custom_domains = test.example.com
host_header_rewrite = dev.example.com
header_X-From-Where = frp
```

## Get Real IP

### HTTP X-Forwarded-For

`X-Forwarded-For`  
`X-Real-IP`

### Proxy Protocol

```ini
# frpc.ini
[web]
type = https
local_port = 443
custom_domains = test.example.com

# now v1 and v2 are supported
proxy_protocol_version = v2
```

get real ip: `X-Real-IP`

## Require HTTP Basic Auth (Password) for Web Services

```ini
# frpc.ini
[web]
type = http
local_port = 80
custom_domains = test.example.com
http_user = abc
http_pwd = abc
```

## Custom Subdomain Names

```ini
# frps.ini
subdomain_host = frps.com

# frpc.ini
[web]
type = http
local_port = 80
subdomain = test

# visit: test.frps.com  
```

> Note that if subdomain_host is not empty, custom_domains should not be the subdomain of subdomain_host.

## URL Routing

```ini
# frpc.ini
[web01]
type = http
local_port = 80
custom_domains = web.example.com
locations = /

[web02]
type = http
local_port = 81
custom_domains = web.example.com
locations = /news,/about
```

## TCP Port Multiplexing

```ini
# frps.ini
[common]
bind_port = 7000
tcpmux_httpconnect_port = 1337
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000

[proxy1]
type = tcpmux
multiplexer = httpconnect
custom_domains = test1
local_port = 80

[proxy2]
type = tcpmux
multiplexer = httpconnect
custom_domains = test2
local_port = 8080
```

## Connecting to frps via HTTP PROXY

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000
http_proxy = http://user:pwd@192.168.1.128:8080
```

## Range ports mapping

```ini
# frpc.ini
[range:test_tcp]
type = tcp
local_ip = 127.0.0.1
local_port = 6000-6006,6007
remote_port = 6000-6006,6007
```

## Client Plugins

> frpc only forwards requests to local TCP or UDP ports by default.
> Plugins are used for providing rich features. There are built-in plugins such as unix_domain_socket, http_proxy, socks5, static_file, http2https, https2http, https2https and you can see [example usage](https://github.com/fatedier/frp#example-usage).

```ini
# frpc.ini example for plugin
[http_proxy]
type = tcp
remote_port = 6000
plugin = http_proxy
plugin_http_user = abc
plugin_http_passwd = abc
```

## Server Manage Plugins

> <https://github.com/fatedier/frp#server-manage-plugins>
