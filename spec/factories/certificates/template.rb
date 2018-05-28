FactoryBot.define do
  factory :certificates_template, class: Certificates::Template do
    name  'Hindernisbahn'
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'image.jpg')) }
    font { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'font.ttf')) }
  end
end
