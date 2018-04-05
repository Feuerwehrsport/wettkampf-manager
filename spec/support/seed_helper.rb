RSpec.shared_context 'configured seed loaded', seed: :configured do
  before do
    ENV['SET_USER_PASSWORD'] = 'password'
    Rails.application.load_seed
    ENV['SET_USER_PASSWORD'] = nil
  end
end

RSpec.shared_context 'seed loaded', seed: :load do
  before do
    Rails.application.load_seed
  end
end
