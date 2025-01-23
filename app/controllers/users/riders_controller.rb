class Users::RidersController < ApplicationController
  def new
    @rider = Rider.new
  end 

  def create
  end

  def rider_params
    params.require(:rider).require(:model).permit(%i[driving_licence vehical_number date_of_birth])
  end
end
