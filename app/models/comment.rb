class Comment < ActiveRecord::Base
  # Building the relationship between Comment Model with Entry Model
  belongs_to :entry
  # Adding Validation for fields of the Comment Model
  validates_presence_of :name, :email, :body
  validate :entry_should_be_published

  after_create :notify_author
  # Adding the extra validation method.

  def entry_should_be_published
    errors.add(:entry_id, I18n.t('comments.errors.not_published_yet')) if entry && !entry.published?
  end

  def notify_author

  end
end
