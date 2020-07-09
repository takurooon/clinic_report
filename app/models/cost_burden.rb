class CostBurden < ApplicationRecord
  has_many :report_cost_burdens, dependent: :destroy
  has_many :reports, through: :report_cost_burdens

  def str_cost_burden
    return self.name
  end
end

# == Schema Information
#
# Table name: cost_burdens
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
