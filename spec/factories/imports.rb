FactoryBot.define do
  factory :imports_configuration, class: Imports::Configuration do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'import.wettkampf_manager_import')) }
  end
end
