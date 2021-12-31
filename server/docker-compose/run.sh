export NGINX_HOME=$(pwd)/nginx
export NEXTCLOUD_HOME=$(pwd)/nextcloud
export DB_HOME=$(pwd)/db
export FRPS_HOME=$(pwd)/frps

export CERT_HOME=$(pwd)/certs

export USER=slient
export PASSWD=kcwnx5tPrzpTKJ8ErHE=

docker-compose -f docker-compose.yml up -d