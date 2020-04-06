output "db_public_ip_address" {
  value     = google_sql_database_instance.master.public_ip_address
}

output "db_user" {
  value     = google_sql_user.postgres.name
}

output "db_password" {
  value     = google_sql_user.postgres.password
  sensitive = true
}
