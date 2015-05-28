module DashboardHelper
  def url_as_qrcode
    RQRCode::QRCode.new(own_url, size: 4, level: :h ).to_img.resize(200, 200).to_data_url
  end

  def own_url
    @own_url ||= "http://#{Socket.ip_address_list.find {|a| a.ipv4?  && !a.ipv4_loopback? }.try(:ip_address)}"
  end
end
