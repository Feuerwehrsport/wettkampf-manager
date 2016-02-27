module DashboardHelper
  def qrcode url
    RQRCode::QRCode.new(url, level: :h ).to_img.resize(200, 200).to_data_url
  end

  def hostname_url
    "http://#{decorated_competition.hostname}/"
  end

  def ip_url
    @ip_url ||= "http://#{Socket.ip_address_list.find {|a| a.ipv4?  && !a.ipv4_loopback? }.try(:ip_address)}/"
  end
end
