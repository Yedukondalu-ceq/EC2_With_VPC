provider "aws" {
  region = "ap-southeast-1"
}

# An alternate configuration is also defined for a different
# region, using the alias "dev".
provider "aws" {
  alias  = "dev"
  region = "us-east-1"
}