class User < ApplicationRecord
  attr_accessor :remember_token
  before_save :downcase_mail

  validates :name,  presence: true,
            length: {maximum: Settings.user.name_max_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            length: {maximum: Settings.user.mail_max_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true,
            length: {minimum: Settings.user.pass_min_length},
            allow_nil: true

  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine.MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  private

  def downcase_mail
    email.downcase!
  end
end
