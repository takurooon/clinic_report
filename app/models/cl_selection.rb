class ClSelection < ApplicationRecord
  has_many :report_cl_selections, dependent: :destroy
  has_many :reports, through: :report_cl_selections

  def str_cl_serection
    return self.name
  end
end

# == Schema Information
#
# Table name: cl_selections
#
#  id         :bigint           not null, primary key
#  name       :string
#  number     :integer
#  yomigana   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
