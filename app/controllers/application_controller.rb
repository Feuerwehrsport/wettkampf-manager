class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ResourceAccess
  include AutoDecorate
  include CRUD::Accessor
  include Authentication
  before_action :check_user_configured

  protected

  def page_title(title, prawn_options = {})
    @page_title = title.to_s

    if request.format.pdf?
      info = { Title: title }
      prawnto prawn: prawn_options.reverse_merge(margin: [45, 36, 40, 36], info: info, page_size: 'A4'),
              filename: "#{title.parameterize}.pdf"
    elsif request.format.xlsx?
      response.headers['Content-Disposition'] = "attachment; filename=\"#{title.parameterize}.xlsx\""
    end
  end

  private

  def check_user_configured
    redirect_to edit_user_path(User.first) if controller_name != 'users' && !User.configured?
  end
end
