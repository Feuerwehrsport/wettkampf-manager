# frozen_string_literal: true

class User < CacheDependendRecord
  attr_accessor :password
  before_save :encrypt_password

  has_many :user_assessment_abilities, dependent: :destroy
  has_many :assessments, through: :user_assessment_abilities

  default_scope { order(:id) }

  validates :password, confirmation: true
  validates :password, presence: { on: :create }
  validates :name, presence: true, uniqueness: true

  def self.authenticate(name, password)
    user = find_by(name: name)
    user if user && user.password_hash == OpenSSL::HMAC.hexdigest('SHA512', user.password_salt.to_s, password.to_s)
  end

  def self.configured?
    first.try(:password_hash).present?
  end

  def admin?
    name == 'admin'
  end

  def api?
    name == 'API'
  end

  private

  def encrypt_password
    return if password.blank?

    self.password_salt = SecureRandom.uuid
    self.password_hash = OpenSSL::HMAC.hexdigest('SHA512', password_salt.to_s, password.to_s)
  end
end
