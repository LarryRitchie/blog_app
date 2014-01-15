class Entry < ActiveRecord::Base
  validates_presence_of :title, :body

  # Building the relationship between the Entry model with other models(user, comment)
  belongs_to :user
  has_many :comments

  # Adding the scope for checking published date, draft entries, recent entries, title
  scope :published, -> { where("entries.published_at IS NOT NULL")}
  scope :draft, -> { where("entries.published_at IS NULL") }
  scope :recent, -> { published.where("entries.published_at > ?", 1.week.ago.to_date)}
  scope :where_title, -> { term| where("entries.title LIKE ?", "%#{term}%") }

  # Method 'long_title', used to express the long format of title.
  def long_title
    "#{title} - #{published_at}"
  end

  # Method 'published?', to check the entry which was published or not.
  # @return boolean
  def published?
    published_at.present?
  end

  # Method 'owned_by', to check the current user are owner or not..
  # @return boolean
  def owned_by?
    return false unless owner.is_a?(User)
    user == owner
  end
end
