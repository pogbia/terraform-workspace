locals {
  common_tags = {
    Name        = "${var.project_name}-${var.project_env}"
    Project     = var.project_name
    Environment = var.project_env
  }
}