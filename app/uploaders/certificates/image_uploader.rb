class Certificates::ImageUploader < BaseUploader
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
