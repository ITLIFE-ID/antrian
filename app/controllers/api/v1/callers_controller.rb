class Api::V1::CallersController < Api::V1::BaseController
  def create
    execute = CallerService.execute(permitted_params["message"])

    if execute.success?
      render json: execute.result, status: :created
    else
      render json: execute.error_messages, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.permit(:message).merge!(api: true)
  end
end
