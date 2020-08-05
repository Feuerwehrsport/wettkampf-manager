FactoryBot.define do
  factory :imports_configuration, class: 'Imports::Configuration' do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/import.wettkampf_manager_import')) }
  end
end
