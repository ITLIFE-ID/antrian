class ClientConfigService < ApplicationService
  attr_accessor :ip_address

  def execute
    may_i_get_my_config?
    
    @result = send(client_display.type)
  rescue => e
    return_errors(e)
  end

  private

  def tv
    {videos: {}, musics: {}, services: {}}
  end

  def tab
    {last_queue_number: ""}
  end

  def kiosk
    {videos: {}, services: {}}
  end

  def p10
    {last_queue_number: ""}
  end

  def client_display
    ClientDisplay.find_by(ip_address: ip_address)
  end

  def may_i_get_my_config?
    is_ip_address_present?
    is_ip_address_valid?
    is_client_display_exists?
  end

  def is_ip_address_present?
    raise "Ip Address cannot be blank!" if ip_address.blank?
  end

  def is_ip_address_valid?
    raise "Ip Address invalid" unless IPAddress.valid? ip_address
  end

  def is_client_display_exists?
    raise "Client display with #{ip_address} cannot be founded" unless ip_address?
  end
end
