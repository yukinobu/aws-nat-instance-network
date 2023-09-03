# NAT Instance Network

An AWS CloudFormation template of NAT instance and private network, low-cost alternative to NAT Gateway, suitable for your non-production environment.

## Features

### Cost efficiency

* Graviton (arm64) architecture.
* Instance type `t4g.small` is on a free trial until the end of 2023.
* Minimum EBS footprint (1GB).

### Performance/Reliability

* Tuned NAT table size to accommodate a large number of clients.
* Auto replace NAT instance in case of problems, without changing global IPv4 address.
* IPv6 support for reachability to v6-only peers.
* ...but this template is inferior to NAT Gateway :-)

### Security

* Auto-update NAT instance.
* Tuned kernel parameters to drop some malformed packets.
* Tuned least IAM privilege for NAT instance profile.

## Getting Started

Make sure your AWS Region is in a supported region.

### AWS Management Console

1. Select [CloudFormation] -> [Stacks] -> [Create stack] -> [With new resources (standard)]
2. Specify template source to [Upload a template file] and choose  `cf-nat-instance-network.yml` as a template file to upload. Then click [Next].
3. Specify your stack name and click [Next].
4. Continue clicking [Next] until you reach the [Review test] screen.
5. Confirm the capabilities section, check the checkbox if ok, and finally click Submit.

### CLI

```bash
aws cloudformation create-stack --stack-name YOUR_STACK_NAME --template-body "file://$(realpath cf-nat-instance-network.yml)" --capabilities CAPABILITY_IAM
```

### Nest step

Now you can place your instances to a private subnet named `YOUR_STACK_NAME-PrivateSubnetA`.

## Operational charge example

* EC2 `t4g.nano` spot instance: 1.3 ~ 1.6 USD/month, but you may have [free trial for `t4g.small` until Dec 31st 2023](https://repost.aws/articles/ARdZ3_Qv8TQdyWhmy4npRMRQ/announcing-amazon-ec2-t4g-free-trial-extension).
* EBS: 0.096 USD/month.
* Ingress traffic: free.
* Egress traffic: depends your traffic, but you may have [100 GB/month free tier](https://aws.amazon.com/blogs/aws/aws-free-tier-data-transfer-expansion-100-gb-from-regions-and-1-tb-from-amazon-cloudfront-per-month/).

Note: prices are based on ap-northeast-1 region, as of Sep 2023.

## Parameter

* `EC2NATInstanceInstanceType`
  * EC2 instance type of the NAT instance.
  * The default `t4g.small` is on a [free trial until Dec 31st 2023](https://repost.aws/articles/ARdZ3_Qv8TQdyWhmy4npRMRQ/announcing-amazon-ec2-t4g-free-trial-extension).
* `EC2NATInstanceKeyName`
  * If you want to ssh login to the NAT instance, specify the key pair name.
  * No need to specify if you do not manage NAT instances.
* `EC2NATInstanceAdminNetwork`
  * If you want to ssh login to the NAT instance, specify the login source in a format like `203.0.113.114/32`.
  * No need to specify if you do not manage NAT instances.

Note that the ssh host key changes when the NAT instance is replaced. Therefore, the ssh command may say "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!". In this case you need to edit your `known_hosts`.

## Supported regions

This template works in AWS regions below:

* ap-northeast-1
* ap-northeast-2
* ap-northeast-3
* ap-south-1
* ap-southeast-1
* ap-southeast-2
* ca-central-1
* eu-central-1
* eu-north-1
* eu-west-1
* eu-west-2
* eu-west-3
* sa-east-1
* us-east-1
* us-east-2
* us-west-1
* us-west-2

## Similar projects

* [int128/terraform-aws-nat-instance: Terraform module to provision a NAT Instance using an Auto Scaling Group and Spot Instance from $1/month](https://github.com/int128/terraform-aws-nat-instance)

