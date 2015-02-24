class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, presence: true, length: {minimum: 5}
  validates :url, presence: true
  validates :description, presence: true

  before_save :generate_slug

  def total_votes
    upvote - downvote
  end

  def upvote
    self.votes.where(vote: true).size
  end

  def downvote
    self.votes.where(vote: false).size
  end

  def to_param
    self.slug
  end

  def generate_slug
    the_slug = to_slug(self.title)
    post = Post.find_by slug: the_slug
    count = 2
    while post and post != self
      the_slug = append_suffix(the_slug, count)
      post = Post.find_by slug: the_slug
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
end