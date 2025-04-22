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
  description = "Nom du bucket GCS"
}



