class Certificates::FontUploader < BaseUploader
  def extension_white_list
    %w[ttf dfont]
  end
end
