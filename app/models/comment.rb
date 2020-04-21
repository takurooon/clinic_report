class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :report
  has_many :notifications, dependent: :destroy
  validates :comment, presence: true, length: { in: 1..1000 }


  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(report_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      report_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end

# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  comment    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  report_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_report_id  (report_id)
#  index_comments_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#  fk_rails_...  (user_id => users.id)
#
