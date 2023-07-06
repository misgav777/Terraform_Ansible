# IP of aws instance copied to a file ip.txt in local system
resource "local_file" "ip" {
  content  = aws_instance.my_vm.public_ip
  filename = "ip.txt"
}
#connecting to the Ansible control node using SSH connection
resource "null_resource" "nullremote1" {
  depends_on = [aws_instance.my_vm]
  # triggers = {
  #   id = timestamp()
  # }

  connection {
    type        = "ssh"
    user        = var.user
    host        = aws_instance.my_vm.public_ip
    private_key = file(var.private_key_path)
  }

  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.my_vm.public_ip}, --private-key ${var.private_key_path} jenkins.yml"
  }
  # Copying the files to the Ansible control node from local system 
  # provisioner "file" {
  #   source      = "inventory"
  #   destination = "/home/ec2-user/ip.txt"
  # }
  # provisioner "file" {
  #   source      = "mykey777.pem"
  #   destination = "/home/ec2-user/mykey777.pem"
  # }
  # provisioner "file" {
  #   source      = "jenkins.yml"
  #   destination = "/home/ec2-user/jenkins.yml"
  # }
  # provisioner "file" {
  #   source      = "ansible.cfg"
  #   destination = "/home/ec2-user/ansible.cfg"
  # }
  # provisioner "file" {
  #   source      = "install.sh"
  #   destination = "/home/ec2-user/install.sh"
  # }

}

# # Connecting to the Linux OS having the Ansible playbook
# resource "null_resource" "nullremote2" {
#   depends_on = [aws_volume_attachment.ebs_att]
#   triggers = {
#     id = timestamp()
#   }
#   connection {
#     type        = "ssh"
#     user        = var.user
#     host        = aws_instance.my_vm.public_ip
#     private_key = file(var.private_key_path)
#   }
#   # Command to install and run ansible playbook on remote Linux OS
#   # provisioner "remote-exec" {
#   #   inline = [
#   #     "chmod +x /home/ubuntu/install.sh",
#   #     "./install.sh",
#   #   ]
#   # }
#   provisioner "local-exec" {
#     command = "ansible-playbook  -i ${aws_instance.my_vm.public_ip}, --private-key ${var.private_key_path} jenkins.yaml"
#   }

#   #   provisioner "local-exec" {
#   #     command = "echo ${aws_instance.my_vm.public_ip} > inventory"

#   #   }
#   # provisioner "local-exec" {
#   #   command = "echo [jenkins-server] > inventory"

#   # }
#   # provisioner "local-exec" {
#   #   command = "echo ${aws_instance.os1.private_ip} >> inventory"

#   # }
#   #   provisioner "remote-exec" {
#   #     inline = [
#   #       "chmod 777 install.sh",
#   #       "/home/ec2-user/install.sh"
#   #     ]
#   #   }
# }
