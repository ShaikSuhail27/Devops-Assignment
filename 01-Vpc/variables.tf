variable "cidr_block" {
#     default = ["172.31.96.0/20","172.31.80.0/20"]
      default = ["172.31.95.0/24","172.31.96.0/24"]
 }

variable "common_tags" {
    type = map 
    default = {
        Name = "Amazon"
        Environment ="DEV"
        Terraform = true
    }
}