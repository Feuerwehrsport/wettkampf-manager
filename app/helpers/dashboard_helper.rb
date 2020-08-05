# frozen_string_literal: true

module DashboardHelper
  def qrcode(url)
    RQRCode::QRCode.new(url).as_png(size: 200).to_data_url
  end
end
