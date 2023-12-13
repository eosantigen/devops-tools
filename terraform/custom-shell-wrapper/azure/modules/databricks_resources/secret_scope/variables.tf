variable "secret_scopes" {

  type = set(string)
  description = "Avoid duplicates, hence conflicts, with a set."
  
}