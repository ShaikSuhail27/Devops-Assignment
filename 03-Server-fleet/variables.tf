variable "common_tags" {
    type = map 
    default = {
        Name = "Amazon"
        Environment ="DEV"
        Terraform = true
    }
}

variable "project_name" {
    default = "Amazon"
  
}