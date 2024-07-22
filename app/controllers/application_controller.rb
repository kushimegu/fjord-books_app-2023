# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    # サインアップ時にnameのストロングパラメータを追加
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # アカウント編集の時のストロングパラメータを追加
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :postal_code, :address, :bio])
  end
end
