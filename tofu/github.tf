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


resource "tls_private_key" "github_secret_test" {
  algorithm = "ED25519"
}

resource "github_actions_secret" "github_secret_test" {
  repository      = "dotfiles"
  secret_name     = "FOOBARBAZ"
  plaintext_value = tls_private_key.github_secret_test.private_key_pem
}

resource "github_repository" "resume" {
  name          = "resume"
  homepage_url  = "https://www.grigorjan.net/resume.pdf"
  has_issues    = true
  has_downloads = false
  has_projects  = false
  has_wiki      = false
}
