variable "default_tags" {
  default = {
    Name        = "sprint6-cr-kyle"
    Pod         = "N/A"
    Sprint      = "sprint6"
    Environment = "dev"
  }
  type = map(string)
}

variable "allowed_cidr_blocks" {
  type = list(string)
  default = [
    "174.103.114.161/32", # Kyle

    # Github
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20",
  ]
}

variable "allowed_cidr_blocks_ipv6" {
  type = list(string)
  default = [
    "2a0a:a440::/29",
    "2606:50c0::/32"
  ]
}

variable "region" {
  type    = string
  default = "us-east-2"
}