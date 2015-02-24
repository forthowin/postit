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

  before_save :generate_slug

  def to_param
    self.slug
  end

  def generate_slug
    the_slug = to_slug(self.username)
    user = User.find_by slug: the_slug
    count = 2
    while user and user != self
      the_slug = append_suffix(the_slug, count)
      user = User.find_by slug: the_slug
      count += 1
    end
    self.slug = the_slug.downcase
  end

  def append_suffix(str, count)
    if str.split('-').last.to_i != 0
      return str.split('-').slic(0...-1).join('-') + '-' + count.to_s
    else
      return str + '-' + count.to_s
    end
  end

  def to_slug(name)
    str = name.strip
    str.gsub!(/\s*[^A-Za-z0-9]\s*/, '-')
    str.gsub!(/-+/,'-')
    str.downcase
  end

  private

  def password_does_not_match_password_confirmation
    if password.blank? and !password_confirmation.blank?
      errors.add("Password_confirmation_doesn't_match_Password", '')
    end
  end
end