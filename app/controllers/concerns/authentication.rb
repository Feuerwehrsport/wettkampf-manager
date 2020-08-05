# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?, :admin_logged_in?

    rescue_from CanCan::AccessDenied do |_exception|
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def admin_logged_in?
    current_user.present? && can?(:manage, Competition)
  end
end
