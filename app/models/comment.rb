class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :report
  has_many :notifications, dependent: :destroy
  validates :comment, presence: true, length: { in: 1..500 }
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
