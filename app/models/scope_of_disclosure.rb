class ScopeOfDisclosure < ApplicationRecord
  has_many :report_scope_of_disclosures, dependent: :destroy
  has_many :reports, through: :report_scope_of_disclosures

  def str_scope_of_disclosure
    return self.scope
  end
end

# == Schema Information
#
# Table name: scope_of_disclosures
#
#  id         :bigint           not null, primary key
#  scope      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
