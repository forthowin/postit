class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, confirmation: true, presence: true, length: {minimum: 5}, on: :create
  validates_confirmation_of :password_confirmation, on: :create
  validates :password, confirmation: true, length: {minimum: 5}, allow_blank: true, on: :update
  validate  :password_does_not_match_password_confirmation, on: :update

  private

  def password_does_not_match_password_confirmation
    if password.blank? and !password_confirmation.blank?
      errors.add("Password_confirmation_doesn't_match_Password", '')
    end
  end
end