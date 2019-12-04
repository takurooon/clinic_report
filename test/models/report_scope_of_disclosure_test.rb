# == Schema Information
#
# Table name: report_scope_of_disclosures
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  report_id              :bigint           not null
#  scope_of_disclosure_id :bigint           not null
#
# Indexes
#
#  index_report_scope_of_disclosures_on_report_id               (report_id)
#  index_report_scope_of_disclosures_on_scope_of_disclosure_id  (scope_of_disclosure_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#  fk_rails_...  (scope_of_disclosure_id => scope_of_disclosures.id)
#

require 'test_helper'

class ReportScopeOfDisclosureTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
