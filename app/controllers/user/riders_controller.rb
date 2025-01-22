class User::RidersController < ApplicationController
  def new
    @rider = Rider.new
  end 

  def create
    debugger
    debugger
  end

  def rider_params
    params.require(:rider).require(:model).permit(%i[driving_licence vehical_number date_of_birth])
    params.require(:rider).require(:model).permit(%i[driving_licence vehical_number date_of_birth])
  end
end
