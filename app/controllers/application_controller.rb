class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_before_action :verify_authenticity_token




  protected
  def user_params(model)
    params.require(model).require(:user).permit(%i[name password password_confirmation email phone address])
  end
end
