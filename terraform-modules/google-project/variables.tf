# destroy on disable
variable "destroy" {
  default = "false"
}

# enable/disable var
variable "enable_flag" { 
   default = "1" 
}

variable "google_project_name" {
  default = "broad-project-env"
}

variable "google_project_id" {
  default = "1234567"
}

variable "google_project_folder_display_name" {
  default = "Broad Project Env"
}

variable "google_project_folder_parent" {
  default = "Broad Project Folder Parent"
}

