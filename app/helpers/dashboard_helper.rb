module DashboardHelper
  def qrcode(url)
    RQRCode::QRCode.new(url, level: :h).to_img.resize(200, 200).to_data_url
  end
end
