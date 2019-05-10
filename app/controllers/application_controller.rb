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

  def default_meta_description(title: nil)
    page_title(title) if title.present?
    description = []
    description.push("Der Wettkampf »#{Competition.one.name}« findet am #{l Competition.one.date} in " \
      "#{Competition.one.place} statt.")
    description.push("Angemeldete Wettkämpfer: #{Person.count}") if Person.present?
    description.push("Angemeldete Mannschaften: #{Team.count}") if Team.present?
    description.push('Das Programm »Wettkampf-Manager« ist eine kostenlose und freie Software. Sie steht unter der ' \
      'Software-Lizenz AGPLv3.')
    @meta_description = description.join("\n")
  end

  private

  def check_user_configured
    redirect_to edit_user_path(User.first) if controller_name != 'users' && !User.configured?
  end

  def send_pdf(pdf_class, filename: nil, args: [], format: :pdf)
    return if format.present? && request.format.to_sym != format

    pdf = pdf_class.perform(*args)
    filename ||= pdf.filename if pdf.respond_to?(:filename)
    filename ||= "#{@page_title.parameterize}.pdf" if @page_title.present?
    send_data(pdf.bytestream, filename: filename, type: 'application/pdf', disposition: 'inline')
  end
end
