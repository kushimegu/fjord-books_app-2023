class UsersController < ApplicationController
  def index
    @users = User.order(:id).page(params[:page]).per(2)
  end

  def show
    @user = User.find(params[:id])
    @current_user = current_user
  end

  def edit
  end
end
