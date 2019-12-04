class Supplement < ApplicationRecord
  has_many :report_supplements, dependent: :destroy
  has_many :reports, through: :report_supplements

  def str_supplement
    return self.name
  end
end

# == Schema Information
#
# Table name: supplements
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
