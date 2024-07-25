# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(_resource)
    books_path
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

  def update_resource(_resource, params)
    resource.update_without_current_password(params)
  end
end
