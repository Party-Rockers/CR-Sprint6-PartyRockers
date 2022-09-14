variable "default_tags" {
  default = {
    Name        = "sprint6-cr-partyrockers"
    Pod         = "PartyRockers"
    Sprint      = "sprint6"
    Environment = "dev"
  }
  type = map(string)
}

variable "region" {
    type = string
    default = "us-east-2"
}