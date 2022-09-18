class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pagy::Backend

  before_action do
    I18n.locale = :cs
  end

  protected

  def configure_permitted_parameters
    # Fields for sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :second_name,  :email, :password])
    # Fields for editing an existing account
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :second_name, :email, :password])
  end
end
