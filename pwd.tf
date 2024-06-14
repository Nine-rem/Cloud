#GENEREZ UN MDP ALEATOIRE ET LE METTRE DANS LA VALUE DE VOTRE SECRET EN TERRAFORM
resource "random_password" "password" { 
  count =3
  length           = 16
  min_numeric      = 1
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}