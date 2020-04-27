class SSelectionMethod < ApplicationRecord
  has_many :report_s_selection_methods, dependent: :destroy
  has_many :reports, through: :report_s_selection_methods

  def str_s_selection_method
    return self.name
  end
end

# == Schema Information
#
# Table name: s_selection_methods
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
