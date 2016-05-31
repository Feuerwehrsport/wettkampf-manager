class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ResourceAccess
  include AutoDecorate
  include CRUD::Accessor
  include Authentication
  before_action :check_user_configured

  protected

  def page_title title, prawn_options={}

    @page_title = title.to_s
    
    if request.format.pdf?
      info = { Title: title }
      prawnto prawn: prawn_options.merge(info: info, page_size: 'A4'), filename: "#{title.parameterize}.pdf"
    elsif request.format.xlsx?
      response.headers['Content-Disposition'] = "attachment; filename=\"#{title.parameterize}.xlsx\""
    end
  end

  private

  def check_user_configured
    redirect_to edit_users_path if controller_name != "users" && !User.configured?
  end

end
