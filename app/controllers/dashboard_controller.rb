class DashboardController < ApplicationController
  before_action do
    redirect_to(presets_path) unless Competition.one.configured?
  end

  def show
    default_meta_description title: "#{Competition.one.name} - #{l Competition.one.date} - Wettkampf-Manager"
  end

  def impressum
    default_meta_description title: "#{Competition.one.name} - Wettkampf-Manager - Impressum"
  end

  def flyer
    send_pdf(PDF::Flyer, filename: 'flyer.pdf', format: nil)
  end
end
