# Instance Data
data "aws_instance" "foo" {

  filter {
    name   = "tag:Name"
    values = ["My Amazon Linux Vm"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
  depends_on = [aws_instance.my_vm]
}

# Create Ec2
resource "aws_instance" "my_vm" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_default_security_group.my_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  tags = {
    "Name" = "My Amazon Linux Vm"
  }
  # depends_on = [aws_key_pair.gen_key_pair]
}

#ebs volume created
resource "aws_ebs_volume" "ebs" {
  availability_zone = aws_instance.my_vm.availability_zone
  size              = 1
  tags = {
    Name = "My Amazon Linux Vm EBS"
  }
}
#ebs volume attatched to instance
resource "aws_volume_attachment" "ebs_att" {
  device_name  = "/dev/sdh"
  volume_id    = aws_ebs_volume.ebs.id
  instance_id  = aws_instance.my_vm.id
  force_detach = true
}
