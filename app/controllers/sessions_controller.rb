class SessionsController < ApplicationController
  def new
    @user_names = User.all.pluck(:name)
  end

  def create
    @user_names = User.all.pluck(:name)
    user = User.authenticate(user_params[:name], user_params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Anmeldung erfolgreich'
    else
      flash.now.alert = 'Passwort nicht korrekt'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Abgemeldet'
  end

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
