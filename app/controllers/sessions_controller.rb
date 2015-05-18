class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(user_params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, notice: "Anmeldung erfolgreich"
    else
      flash.now.alert = "Passwort nicht korrekt"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Abgemeldet"
  end

  def user_params
    params.require(:user).permit(:password)
  end
end
