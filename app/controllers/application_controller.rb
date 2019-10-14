class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ResourceAccess
  include AutoDecorate
  include CRUD::Accessor
  include Authentication
  before_action :check_user_configured

  protected

  def page_title(title)
    @page_title = title.to_s

    return unless request.format.xlsx?

    response.headers['Content-Disposition'] = "attachment; filename=\"#{title.parameterize}.xlsx\""
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

  def send_pdf(klass, filename: nil, args: [], format: :pdf, &block)
    send_attachment(klass, filename: filename, args: args, format: format, type: :pdf, &block)
  end

  def send_xlsx(klass, filename: nil, args: [], format: :xlsx, &block)
    send_attachment(klass, filename: filename, args: args, format: format, type: :xlsx, &block)
  end

  private

  def check_user_configured
    redirect_to edit_user_path(User.first) if controller_name != 'users' && !User.configured?
  end

  def send_attachment(klass, filename: nil, args: [], format:, type:)
    return if format.present? && request.format.to_sym != format

    args = yield if block_given?
    model = klass.perform(*args)
    filename ||= model.filename if model.respond_to?(:filename)
    filename ||= "#{@page_title.parameterize}.#{type}" if @page_title.present?
    options = { type: Mime[type], disposition: (type == :pdf ? 'inline' : 'attachment') }
    send_data(model.bytestream, options.merge(filename: filename))
  end
end
