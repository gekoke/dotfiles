provider "github" {
  token = var.github_token
}

resource "github_repository" "resume" {
  name          = "resume"
  homepage_url  = "https://www.grigorjan.net/resume.pdf"
  has_issues    = true
  has_downloads = false
  has_projects  = false
  has_wiki      = false
}
