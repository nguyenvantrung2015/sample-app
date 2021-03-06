class Micropost < ApplicationRecord
  belongs_to :user
  scope :feed_by_time, ->{order created_at: :desc}
  scope :by_user_id, ->(id){where user_id: id}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.post_size}
  validate :picture_size

  private
  def picture_size
    return unless picture.size > Settings.limit_size_update_image.megabytes
    errors.add(:picture, t("micropost.should_less_5m"))
  end
end
