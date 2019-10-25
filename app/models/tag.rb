class Tag < ApplicationRecord
  has_many :report_tags, dependent: :destroy
  has_many :reports, through: :report_tags
end

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
