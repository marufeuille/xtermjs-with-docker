# xtermjs-with-docker
## What is this demo

This demo explain how xtemrm.js connect to docker websocket.
This app consist software below,
- nginx
- docker
- xterm.js
- terraform

and now, this demo only deproyable
- Alibaba Cloud(ap-northeast-1)
- Ubuntu 18.04

## How to deploy

1. Get Your own AliCloud's api key

2. Write Your config like below.

sample config is terraform.tfvars.sample

Rename to terraform.tfvars and write below.

```terraform.tfvars
ACCESS_KEY=YOUR_ACCESSKEY
SECRET_KEY=YOYR_SECRETKEY
```

3. enter commands below.

```bash
bash bootstrap.sh
```

this commands get current global ip and set sg rule.
because docker remote api is very dangerous to publish all over the world.

## Will be requently asked question.
### Does not connect web

- This auto deploy scripts set Your Global IP to Security Group.
- This Global IP is Your Development Enviroment.
- If you use remote enviroment like cloud, you modify Security Group after setup.

### Want to connect ecs via ssh

- If deploy is finished, SecretKey is on outputs/id_rsa
