class ClientsController < ApplicationController
  def create
    client = Client.new(clients_params)
    if client.save
      tags = params[:tags]
      tags = tags ? tags.map { |tag| Tag.find_or_create_by(name: tag) } : []
      client.tags << tags
      render json: client, status: 201
    else
      render json: { message: client.errors.full_messages }, status: 400
    end
  end

  private

  def clients_params
    params.require(:client).permit(:name, :surname, :patronymic, :identification_number)
  end
end
