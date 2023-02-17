locals {
  common_tags = {
    env = var.env
    owner = "roboshop"
    project = "roboshop-ecommerce"
    project_unit = "roboshop-infra"
  }
}