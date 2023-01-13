class Api::V1::ClientConfigsController < Api::V1::BaseController
  def show
    
  end

  private

  def permitted_params
    params.permit(:ip_address)
  end
end
