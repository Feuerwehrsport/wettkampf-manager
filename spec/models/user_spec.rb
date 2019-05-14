require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.configured?' do
    let(:configured) { User.configured? }

    context 'when user not exists' do
      it 'returns false' do
        expect(configured).to be_falsey
      end
    end
    context 'when user exists' do
      let!(:user) { User.new(name: 'admin').tap { |u| u.save!(validate: false) } }

      context 'when user is not configured' do
        it 'returns false' do
          expect(configured).to be_falsey
        end
      end
      context 'when user is configured' do
        before { user.update!(password: 'a', password_confirmation: 'a') }
        it 'returns true' do
          expect(configured).to be_truthy
        end
      end
    end
  end

  describe '.authenticate' do
    let!(:user) { create(:user) }

    it 'returns authenticated user or nil' do
      expect(User.authenticate('admin', 'a')).to eq user
      expect(User.authenticate('admin', 'b')).to be_nil
    end
  end

  describe 'password' do
    let!(:user) { create(:user) }

    it 'does not show password' do
      user = User.authenticate('admin', 'a')
      expect(user.password).to be_nil
      expect(user.password_salt).not_to be_nil
      expect(user.password_salt).not_to eq 'a'
      expect(user.password_hash).not_to be_nil
      expect(user.password_hash).not_to eq 'a'
    end
  end
end
