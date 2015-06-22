class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ResourceAccess
  include AutoDecorate
  include CRUD::Accessor
  include Authentication
  before_action :check_user_configured

  protected

  def page_title title, prawn_options={}
    info = { Title: title }
    prawnto prawn: prawn_options.merge(info: info), filename: "#{title.parameterize}.pdf"
    @page_title = title.to_s
  end

  private

  def check_user_configured
    redirect_to edit_user_path(User.first) if controller_name != "users" && !User.configured?
  end

end
