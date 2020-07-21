class Like < ApplicationRecord
  belongs_to :user
  belongs_to :report
  validates_uniqueness_of :report_id, scope: :user_id
end

# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  report_id  :integer
#  user_id    :integer
#
