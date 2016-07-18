class UsersController < ApplicationController
  implement_crud_actions

  def show
    redirect_to action: :index
  end

  protected

  def after_save
    if @user.admin?
      session[:user_id] = @user.id
      redirect_to root_path
    else
      super
    end
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, assessment_ids: [])
  end
end
