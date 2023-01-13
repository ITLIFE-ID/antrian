class Api::V1::ClientConfigsController < Api::V1::BaseController
  def show
    ClientConfigService.execute({ip_address: ip_address, api: true})
  end

  private

  def ip_address
    request.ip
  end
end
