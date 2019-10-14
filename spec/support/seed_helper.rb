RSpec.shared_context 'when configured seed loaded', seed: :configured do
  before do
    ENV['SET_USER_PASSWORD'] = 'password'
    Rails.application.load_seed
    ENV['SET_USER_PASSWORD'] = nil
  end
end

RSpec.shared_context 'when seed loaded', seed: :load do
  before do
    Rails.application.load_seed
  end
end

RSpec.shared_context 'when logged in', user: :logged_in do
  before do
    allow(controller).to receive(:current_user).and_return(User.first)
  end
end
