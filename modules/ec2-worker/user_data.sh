#!/bin/bash
set -ex

# Install needed packages (awscli, kubectl, etc.)
yum update -y
yum install -y docker amazon-linux-extras
amazon-linux-extras install -y kubectl1.24

systemctl enable docker
systemctl start docker

# (In a real scenario, you'd need to configure the node to connect to EKS
#  by installing the AWS EKS optimized AMI or running extra scripts. 
#  This minimal example might not fully register to EKS but demonstrates structure.)
