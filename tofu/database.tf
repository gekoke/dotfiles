provider "neon" {
  api_key = var.neon_api_key
}

resource "neon_project" "glucose" {
  name      = "glucose"
  region_id = "aws-eu-central-1"

  branch {
    name          = "main"
    database_name = "glucosedb"
    role_name     = "glucosedb_owner"
  }
}

resource "neon_branch" "glucose_dev" {
  name       = "dev"
  project_id = neon_project.glucose.id
  parent_id  = neon_project.glucose.default_branch_id
}

resource "neon_endpoint" "glucose_dev" {
  type       = "read_write"
  project_id = neon_project.glucose.id
  branch_id  = neon_branch.glucose_dev.id
}
