Company.create(
  address: "Jalan Tegalsari Barat 3 No.55",
  api_key: SecureRandom.uuid, name: "ITLIFE",
  phone_number: "082121217937",
  latitude: "-7.0077199",
  longitude: "110.4244441"
)

Administrator.create(email: "admin@itlife.com", password: "Password000", name: "Admin",
  phone_number: "082121217937", company: Company.first)