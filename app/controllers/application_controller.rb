
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    flash.keep(:alert)
    redirect_to root_url
  end

  def after_sign_in_path_for(resource)
    topics_path
  end

  before_filter :update_sanitized_params, if: :devise_controller?
  def update_sanitized_params
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:email, :name, :avatar, :password, :password_confirmation, :current_password)}
  end
end
