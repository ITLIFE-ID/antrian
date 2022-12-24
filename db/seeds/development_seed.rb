# frozen_string_literal: true

ActiveRecord::Base.transaction do
  Company.create(
    address: "Jalan Tegalsari Barat 3 No.55",
    api_key: SecureRandom.uuid, name: "ITLIFE",
    phone_number: "082121217937",
    latitude: "-7.0077199",
    longitude: "110.4244441"
  )

  Administrator.create(email: "superadmin@itlife.com", password: "Password000", name: "Super Admin",
    phone_number: "082121217937", company: Company.first)

  Administrator.create(email: "admin@itlife.com", password: "Password000", name: "Admin",
    phone_number: "082121217937", company: Company.first)

  VoiceOver.create(name: "Michele Angelina", slug: "MICHEL_ANGELINA")

  Building.create(name: "Gedung utama", company: Company.first)

  ClientDisplay.create(
    client_display_type: "tv",
    ip_address: Faker::Internet.unique.ip_v4_address,
    location: "Di atas pintu",
    building: Building.first
  )

  ServiceType.create(name: "Pendaftaran", company: Company.first)
  ServiceType.create(name: "Poli", company: Company.first)
  ServiceType.create(name: "kasir", company: Company.first)
  ServiceType.create(name: "apotek", company: Company.first)

  Service.create(active: true,
    closing_time: "18:00:00", letter: "A",
    open_time: "07:00:00",
    priority: false,
    name: "Pendaftaran",
    parent: nil,
    service_type: ServiceType.first,
    company: Company.first)

  Service.create(active: true,
    closing_time: "18:00:00", letter: "B",
    open_time: "07:00:00",
    priority: false,
    name: "Poli Umum",
    parent: nil,
    service_type: ServiceType.second,
    company: Company.first)

  Service.create(active: true,
    closing_time: "18:00:00",
    letter: "C",
    open_time: "07:00:00",
    priority: false,
    name: "Kasir",
    parent: nil,
    service_type: ServiceType.third,
    company: Company.first)

  Service.create(active: true,
    closing_time: "18:00:00",
    letter: "D",
    open_time: "07:00:00",
    priority: false,
    name: "Apotek",
    parent: nil,
    service_type: ServiceType.fourth,
    company: Company.first)

  User.create(name: "Helmi", email: "helmi@gmal.com", phone_number: "+6282121217937", password: "Password000")
  User.create(name: "Putri", email: "putri@gmal.com", phone_number: "+6282121217927", password: "Password000")
  User.create(name: "Amel", email: "amel@gmal.com", phone_number: "+6282121217917", password: "Password000")

  (1..6).each do |d|
    WorkingDay.create(day: d, closing_time: "18::00:00", open_time: "07:00:00",
      workable: Company.first)
    ClosingDay.create(date: Date.today - d, start_time: "08:00:00", finish_time: "18:00:00",
      closeable: Company.first)

    Service.all.each do |service|
      WorkingDay.create(day: d, closing_time: "18::00:00", open_time: "07:00:00",
        workable: service)
      ClosingDay.create(date: Date.today - d, start_time: "08:00:00", finish_time: "18:00:00",
        closeable: service)
    end
  end

  Service.all.each do |service|
    (1..2).each do |i|
      counter = Counter.create(service: service, number: i)
      client_display = ClientDisplay.create(
        client_display_type: "p10", ip_address: Faker::Internet.unique.ip_v4_address, location: "Di depan Pendaftaran 1", building: Building.first
      )
      SharedClientDisplay.create(counter: counter, client_display: client_display)
    end

    User.all.each do |user|
      Counter.all.each do |counter|
        UserCounter.create(user: user, counter: counter)
      end
    end
  end
rescue => e
  puts e
  ActiveRecord::Rollback
end
