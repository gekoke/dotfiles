provider "neon" {
  api_key = var.neon_api_key
}

resource "neon_project" "arugula" {
  name      = "arugula"
  region_id = "aws-eu-central-1"

  branch {
    name          = "main"
    database_name = "arugula"
    role_name     = "arugula_owner"
  }
}
