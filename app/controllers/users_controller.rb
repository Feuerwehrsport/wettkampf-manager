class UsersController < ApplicationController
  implement_crud_actions only: [:edit, :update]

  protected

  def after_save
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
