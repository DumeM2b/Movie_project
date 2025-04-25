# variables.tf

# Variable pour l'ID du projet
variable "project_id" {
  type        = string
  description = "ID du projet Google Cloud"
  
}

# Variable pour la région
variable "region" {
  type        = string
  description = "Région où les ressources seront créées"
  default     = "europe-west9"
}

# Variable pour le nom du VPC
variable "vpc_name" {
  type        = string
  description = "Nom du VPC"
  default     = "movie-vpc"
}

# Variable pour le nom du subnet
variable "subnet_name" {
  type        = string
  description = "Nom du sous-réseau"
  default     = "movie-subnet"
}


# Variable pour le nom du dataset BQ
variable "bq_dataset_name" {
  type        = string
  description = "Nom du dataset BQ"
  default     = "bq_dataset_movie"
}


variable "github_owner" {
  type        = string
  description = "GitHub org/user"
  default     = "DumeM2b"
}

variable "github_repo" {
  type        = string
  description = "GitHub repo name"
  default     = "Movie_project"
}

variable "github_token" {
  description = "GitHub personal access token with repo access"
  sensitive   = true
  
}

variable "github_installation_id" {
  type        = number
  description = "GitHub App installation ID for Cloud Build GitHub connection"
  
}
