# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

AppointmentStatus.create(status: "Pending")
AppointmentStatus.create(status: "Accepted")
AppointmentStatus.create(status: "Rejected")
AppointmentStatus.create(status: "Canceled")

Service.create(name: "Dietético")
Service.create(name: "Desportivo")
Service.create(name: "Clínico")
Service.create(name: "Infantil")
Service.create(name: "Vegetariano")
Service.create(name: "Integrativo")

Nutritionist.create(name: "Carla Santos", street: "Avenida da Liberdade 123", city: "Matosinhos", price: 1995)
Nutritionist.create(name: "Miguel Almeida", street: "Rua das Flores 45", city: "Porto", price: 1535)
Nutritionist.create(name: "Patrícia Gomes", street: "Praça da República 67", city: "Porto", price: 2290)
Nutritionist.create(name: "Tiago Correia", street: "Rua Augusta 89", city: "Lisboa", price: 2499)
Nutritionist.create(name: "Sofia Costa", street: "Travessa do Mar 12", city: "Vieira de Leiria", price: 1800)

NutritionistsService.create(nutritionist_id: 1, service_id: 1)
NutritionistsService.create(nutritionist_id: 2, service_id: 1)
NutritionistsService.create(nutritionist_id: 2, service_id: 2)
NutritionistsService.create(nutritionist_id: 3, service_id: 3)
NutritionistsService.create(nutritionist_id: 3, service_id: 4)
NutritionistsService.create(nutritionist_id: 4, service_id: 1)
NutritionistsService.create(nutritionist_id: 4, service_id: 4)
NutritionistsService.create(nutritionist_id: 5, service_id: 2)
NutritionistsService.create(nutritionist_id: 5, service_id: 5)

Guest.create(name: "Ana Martins", email: "anamartins@gmail.com")
Guest.create(name: "João Carvalho", email: "joaocarvalho@gmail.com")
Guest.create(name: "Marta Sousa", email: "martasousa@gmail.com")

Appointment.create(date: "2025-10-06 10:00:00.000", status_id: 1, nutritionist_id: 3, guest_id: 2)
Appointment.create(date: "2025-10-06 10:30:00.000", status_id: 1, nutritionist_id: 2, guest_id: 1)
Appointment.create(date: "2025-10-06 10:30:00.000", status_id: 1, nutritionist_id: 2, guest_id: 3)
Appointment.create(date: "2025-10-07 18:00:00.000", status_id: 1, nutritionist_id: 1, guest_id: 2)
Appointment.create(date: "2025-10-07 18:00:00.000", status_id: 1, nutritionist_id: 3, guest_id: 3)
Appointment.create(date: "2025-10-08 12:00:00.000", status_id: 1, nutritionist_id: 4, guest_id: 1)
