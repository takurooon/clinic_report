class Tag < ApplicationRecord
  has_many :report_tags, dependent: :destroy
  has_many :reports, through: :report_tags

  def str_tag
    return self.tag_name
  end
end

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  tag_name   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
