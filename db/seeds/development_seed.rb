# frozen_string_literal: true

ActiveRecord::Base.transaction do
  Company.create(
    address: "Jl. Pahlawan No.98, Getas, Purworejo, Kec. Temanggung, Kabupaten Temanggung, Jawa Tengah 56277",
    api_key: SecureRandom.uuid, name: "Dispenduk capil temanggung",
    phone_number: "0293491127",
    latitude: "-7.3346557",
    longitude: "110.1783978"
  ) 

  Administrator.create(email: "capiltemanggung@jatengprov.co.id", password: "Password000", name: "Admin capil temanggung",
    phone_number: "0293491127", company: Company.second)

  VoiceOver.create(name: "Michele Angelina", slug: "MICHEL_ANGELINA")
  Building.create(name: "Gedung utama", company: Company.second)

  ClientDisplay.create(
    client_display_type: "tv",
    ip_address: Faker::Internet.unique.ip_v4_address,
    location: "Di atas pintu",
    building: Building.first
  )

  ServiceType.create(name: "Layanan", company: Company.second)

  debugger
  Service.create(
    active: true,
    letter: "A",    
    priority: false,
    name: "Kependudukan",
    parent: nil,
    service_type: ServiceType.first,
    company: Company.second)

  Service.create(active: true,
    letter: "B",    
    priority: false,
    name: "Akte",
    parent: nil,
    service_type: ServiceType.first,
    company: Company.second)

  Service.create(active: true,    
    letter: "C",    
    priority: false,
    name: "Sertifikat",
    parent: nil,
    service_type: ServiceType.first,
    company: Company.second)

  Service.create(active: true,    
    letter: "D",    
    priority: false,
    name: "Pindah / Datang",
    parent: nil,
    service_type: ServiceType.first,
    company: Company.second)

  User.create(name: "Helmi", email: "helmi@gmal.com", phone_number: "+6282121217937", password: "Password000")
  User.create(name: "Putri", email: "putri@gmal.com", phone_number: "+6282121217927", password: "Password000")
  User.create(name: "Amel", email: "amel@gmal.com", phone_number: "+6282121217917", password: "Password000")

  (1..6).each do |d|
    WorkingDay.create(day: d, closing_time: "18::00:00", open_time: "07:00:00", workable: Company.second)    

    Company.second.services.each do |service|
      WorkingDay.create(day: d, closing_time: "18::00:00", open_time: "07:00:00", workable: service)      
    end
  end

  Service.all.each do |service|
    (1..2).each do |i|
      counter = Counter.create(service: service, number: i)

      client_display = ClientDisplay.create(
        client_display_type: "p10", ip_address: Faker::Internet.unique.ip_v4_address, 
        location: "Di depan Pendaftaran 1", building: Building.first
      )

      SharedClientDisplay.create(clientdisplay_able: counter, client_display: client_display)
    end

    User.all.each do |user|
      Counter.all.each do |counter|
        UserCounter.create(user: user, counter: counter)
      end
    end
  end
  puts "success!"
rescue => e
  puts "Error: #{e.message}"
  ActiveRecord::Rollback
end
