class User < ApplicationRecord
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
            length: {minimum: Settings.user.pass_min_length}

  private

  def downcase_mail
    email.downcase!
  end
end
