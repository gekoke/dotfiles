provider "github" {
  token = var.github_token
}

resource "github_repository" "dotfiles" {
  name          = "dotfiles"
  description   = "My NixOS system configurations"
  has_issues    = true
  has_downloads = false
  has_projects  = false
  has_wiki      = false

  allow_auto_merge = true
}

resource "github_repository" "resume" {
  name          = "resume"
  homepage_url  = "https://www.grigorjan.net/resume.pdf"
  has_issues    = true
  has_downloads = false
  has_projects  = false
  has_wiki      = false
}
