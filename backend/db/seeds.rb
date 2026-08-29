services = %w[Dietético Desportivo Clínico Infantil Vegetariano Integrativo].to_h do |name|
  [ name, Service.find_or_create_by!(name: name) ]
end

nutritionists = [
  { name: "Carla Santos",    license_number: "2963N", title: "Nutricionista" },
  { name: "Miguel Almeida",  license_number: "1847N", title: "Dietista" },
  { name: "Patrícia Gomes",  license_number: "3521N", title: "Nutricionista" },
  { name: "Tiago Correia",   license_number: "0938N", title: "Nutricionista Desportivo" },
  { name: "Sofia Costa",     license_number: "4102N", title: "Dietista" }
].to_h do |attrs|
  [ attrs[:name], Nutritionist.find_or_create_by!(license_number: attrs[:license_number]) { |n| n.assign_attributes(attrs) } ]
end

[
  [ "Carla Santos",   "Dietético",   "Rua de Santa Catarina 450",        "Porto",             1490,  45 ],
  [ "Miguel Almeida", "Dietético",   "Avenida da República 250",         "Vila Nova de Gaia", 1890,  60 ],
  [ "Miguel Almeida", "Desportivo",  "Praça Mouzinho de Albuquerque 12", "Porto",             2100,  90 ],
  [ "Patrícia Gomes", "Clínico",     "Rua da Junqueira 88",              "Lisboa",            1750,  60 ],
  [ "Patrícia Gomes", "Infantil",    "Avenida da Boavista 1234",         "Porto",             1995,  30 ],
  [ "Tiago Correia",  "Dietético",   "Rua Brito Capelo 320",             "Matosinhos",        2250,  45 ],
  [ "Tiago Correia",  "Infantil",    "Avenida 25 de Abril 90",           "Braga",             1620,  30 ],
  [ "Sofia Costa",    "Desportivo",  "Rua Direita 15",                   "Guimarães",         1830,  90 ],
  [ "Sofia Costa",    "Vegetariano", "Avenida Fernão Magalhães 800",     "Coimbra",           2050,  60 ]
].each do |nutritionist_name, service_name, street, city, price_cents, duration_minutes|
  NutritionistService.find_or_create_by!(
    nutritionist: nutritionists.fetch(nutritionist_name),
    service: services.fetch(service_name),
    city: city
  ) { |ns| ns.assign_attributes(street: street, price_cents: price_cents, duration_minutes: duration_minutes) }
end

guests = [
  { name: "Ana Martins",    email: "anamartins@gmail.com" },
  { name: "João Carvalho",  email: "joaocarvalho@gmail.com" },
  { name: "Marta Sousa",    email: "martasousa@gmail.com" }
].to_h { |attrs| [ attrs[:name], Guest.find_or_create_by!(email: attrs[:email]) { |g| g.name = attrs[:name] } ] }

next_monday = Date.current.next_occurring(:monday)
carla_dietetico = NutritionistService.find_by!(nutritionist: nutritionists.fetch("Carla Santos"), city: "Porto")
patricia_clinico = NutritionistService.find_by!(nutritionist: nutritionists.fetch("Patrícia Gomes"), city: "Lisboa")

[
  [ "Ana Martins",   carla_dietetico,  next_monday.in_time_zone.change(hour: 10, min: 0) ],
  [ "João Carvalho", carla_dietetico,  next_monday.in_time_zone.change(hour: 10, min: 30) ],
  [ "Marta Sousa",   patricia_clinico, next_monday.in_time_zone.change(hour: 15, min: 0) ]
].each do |guest_name, nutritionist_service, starts_at|
  guest = guests.fetch(guest_name)
  next if guest.appointments.pending.exists?

  Appointment.create!(guest: guest, nutritionist_service: nutritionist_service, starts_at: starts_at)
end

puts "Seeded: #{Service.count} services, #{Nutritionist.count} nutritionists, " \
     "#{NutritionistService.count} offerings, #{Guest.count} guests, #{Appointment.count} appointments"
