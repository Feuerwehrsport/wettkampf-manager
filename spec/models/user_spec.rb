require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe '.configured?' do
    subject { User.configured? }
    context "when user not exists" do
      it "returns false" do
        expect(subject).to be_falsey
      end
    end
    context "when user exists" do
      let!(:user) { u = User.new ; u.save!(validate: false) ; u }

      context "when user is not configured" do
        it "returns false" do
          expect(subject).to be_falsey
        end
      end
      context "when user is configured" do
        before { user.update_attributes!(password: "a", password_confirmation: "a") }
        it "returns true" do
          expect(subject).to be_truthy
        end
      end
    end
  end

  describe '.authenticate' do
    let!(:user) { create(:user) }
    it "returns authenticated user or nil" do
      expect(User.authenticate("a")).to eq user
      expect(User.authenticate("b")).to be_nil
    end
  end

  describe 'password' do
    let!(:user) { create(:user) }
    it "does not show password" do
      user = User.authenticate("a")
      expect(user.password).to be_nil
      expect(user.password_salt).to_not be_nil
      expect(user.password_salt).to_not eq "a"
      expect(user.password_hash).to_not be_nil
      expect(user.password_hash).to_not eq "a"
    end
  end
end
