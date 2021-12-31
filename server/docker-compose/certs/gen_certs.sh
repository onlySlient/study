# only write common name : ip or domain
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./nginx/nginx.key -out ./nginx/nginx.crt