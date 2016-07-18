class User < CacheDependendRecord
  attr_accessor :password
  before_save :encrypt_password
  
  has_many :user_assessment_abilities, dependent: :destroy
  has_many :assessments, through: :user_assessment_abilities

  default_scope { order(:id) }

  validates_confirmation_of :password
  validates_presence_of :password, on: :create
  validates :name, presence: true, uniqueness: true
  
  def self.authenticate(name, password)
    user = find_by(name: name)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def self.configured?
    first.try(:password_hash).present?
  end

  def admin?
    name == 'admin'
  end

  private
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end