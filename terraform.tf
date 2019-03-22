provider "alicloud" {
  access_key = "${var.ACCESS_KEY}"
  secret_key = "${var.SECRET_KEY}"
  region     = "ap-northeast-1"
}

resource "alicloud_vpc" "vpc" {
  name       = "xterm-docker"
  cidr_block = "172.16.0.0/12"
}

resource "alicloud_vswitch" "vsw" {
  vpc_id            = "${alicloud_vpc.vpc.id}"
  cidr_block        = "172.16.200.0/28"
  availability_zone = "ap-northeast-1a"
}

resource "alicloud_security_group" "sg" {
  name     = "xterm-sg"
  vpc_id   = "${alicloud_vpc.vpc.id}"
}

resource "alicloud_security_group_rule" "allow_icmp" {
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg.id}"
  cidr_ip           = "${var.EXTERNAL_IP}"
}

resource "alicloud_security_group_rule" "allow_http_access" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = "${alicloud_security_group.sg.id}"
  cidr_ip           = "${var.EXTERNAL_IP}"
}

resource "alicloud_eip" "eip" {}

resource "alicloud_key_pair" "publickey" {
    key_name = "xterm_public_keypair"
    public_key = "${file("outputs/id_rsa.pub")}"
}

resource "alicloud_instance" "xterm-ecs" {
  instance_name        = "xterm-ecs"
  host_name            = "xterm-ecs"
  availability_zone    = "ap-northeast-1a"
  image_id             = "ubuntu_18_04_64_20G_alibase_20190223.vhd"
  instance_type        = "ecs.n4.small"
  system_disk_category = "cloud_efficiency"
  security_groups      = ["${alicloud_security_group.sg.id}"]
  vswitch_id           = "${alicloud_vswitch.vsw.id}"
  user_data            = "#!/bin/bash\necho '${file("src/var/www/html/index.html")}' > /tmp/index.html\necho '${file("src/etc/nginx/conf.d/websocket.conf")}' > /tmp/websocket.conf\n${file("src/init.sh")}"
}

resource "alicloud_key_pair_attachment" "attach" {
  key_name = "${alicloud_key_pair.publickey.id}"
  instance_ids = ["${alicloud_instance.xterm-ecs.id}"]
}

resource "alicloud_eip_association" "eip-ass" {
  allocation_id = "${alicloud_eip.eip.id}"
  instance_id   = "${alicloud_instance.xterm-ecs.id}"
}
