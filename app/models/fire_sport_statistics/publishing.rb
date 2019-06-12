class FireSportStatistics::Publishing
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :id
  alias to_param id

  def save
    FireSportStatistics::API::Post.new.post(:import_requests, 'import_request[compressed_data]': export_data)
  rescue OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, SocketError => e
    errors.add(:base, e.message)
    false
  end

  def export_data
    Exports::FullDump.new.to_export_data
  end
end
