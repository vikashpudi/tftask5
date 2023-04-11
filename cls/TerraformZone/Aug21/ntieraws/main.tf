resource "aws_vpc" "ntiervpc" {
    cidr_block = var.ntier_cidr

    tags = {
      "Name" = "ntier"
    }
  
}
# aws_vpc.ntiervpc.id

# depending on subnet cidr variables
resource "aws_subnet" "subnets" {
   
   count = length(var.ntier_subnet_azs)

   cidr_block = cidrsubnet(var.ntier_cidr, 8, count.index)
   availability_zone = var.ntier_subnet_azs[count.index]
   tags = {
      "Name" = var.ntier_subnet_tags[count.index]
    }
    vpc_id = aws_vpc.ntiervpc.id

    depends_on = [
      aws_vpc.ntiervpc
    ]
  
}

# Create an internet gateway and attach to vpc

resource "aws_internet_gateway" "ntierigw" {
  vpc_id = aws_vpc.ntiervpc.id

  tags = {
    "Name" = "ntier-igw"
  }

  depends_on = [
    aws_vpc.ntiervpc
  ]
  
}

# create a public route table

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.ntiervpc.id
  route = [ ]
  
  tags = {
    "Name" = "ntier-publicrt"
  }

  depends_on = [
    aws_vpc.ntiervpc,
    aws_subnet.subnets  
  ]
}

resource "aws_route" "publicroute" {
  route_table_id = aws_route_table.publicrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ntierigw.id
}

resource "aws_route_table_association" "publicrtassociations" {
  count = length(var.web_subnet_indexes)
  subnet_id = aws_subnet.subnets[var.web_subnet_indexes[count.index]].id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_security_group" "websg" {
  name = "openhttp"
  description = "Open http and ssh"
  vpc_id = aws_vpc.ntiervpc.id

  tags = {
    "Name" = "Openhttp"
  }
  depends_on = [
    aws_vpc.ntiervpc,
    aws_subnet.subnets,
    aws_route_table.publicrt,
    aws_route_table.ntierprivatert
  ]

}

resource "aws_security_group_rule" "websghttp" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.websg.id
  
  
}

resource "aws_security_group_rule" "websgssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.websg.id

  
  
}

resource "aws_instance" "webserver1" {
  ami = "ami-0c1a7f89451184c8b" # ami for ubuntu in mumbai
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id = aws_subnet.subnets[0].id
  key_name = "ebcli"

  depends_on = [
    aws_vpc.ntiervpc,
    aws_subnet.subnets,
    aws_security_group.websg,
    aws_route_table.publicrt

  ]

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("./ebcli.pem")
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo hello",
      "set",
      "pwd",
      "sudo apt update",
      "sudo apt install apache2 -y"
    ]
    
  }
  
}

resource "aws_route_table" "ntierprivatert" {
  vpc_id = aws_vpc.ntiervpc.id
  route = [ ]
  
  tags = {
    "Name" = "ntier-privatert"
  }
  
}

resource "aws_route_table_association" "privatertassociations" {
  count = length(var.other_subnet_indexes)
  subnet_id = aws_subnet.subnets[var.other_subnet_indexes[count.index]].id
  route_table_id = aws_route_table.ntierprivatert.id

  depends_on = [
    aws_subnet.subnets,
    aws_route_table.ntierprivatert
  ]
}