# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  def after_sign_out_path_for(resource)
    user_session_path
  end
  
  def after_sign_in_path_for(resource)
    books_path
  end
end
