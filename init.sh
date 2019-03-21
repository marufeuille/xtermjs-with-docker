apt update -y
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt update -y && apt install -y docker-ce 

apt install -y nodejs npm
hash -r
npm cache clean
npm install -g n
n stable
npm update -g npm

apt install -y nginx

cd /var/www/html
npm install xterm
mv /tmp/index.html .

mkdir -p /etc/systemd/system/docker.service.d/
mv /tmp/override.conf /etc/systemd/system/docker.service.d/
systemctl daemon-reload
systemctl restart docker

docker run -itd --name websocket alpine:latest /bin/ash

mv /tmp/websocket.conf /etc/nginx/conf.d/
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx
