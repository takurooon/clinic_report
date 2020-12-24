# == Schema Information
#
# Table name: unsuccessful_sairan_cycles
#
#  id                                       :bigint           not null, primary key
#  un_sairan_age                            :integer
#  un_sairan_memo                           :text
#  un_sairan_number                         :integer
#  un_sairan_number_of_eggs_collected       :integer
#  un_sairan_number_of_fertilized_eggs      :integer
#  un_sairan_number_of_frozen_eggs          :integer
#  un_sairan_number_of_transferable_embryos :integer
#  un_sairan_type_of_ovarian_stimulation    :integer
#  created_at                               :datetime         not null
#  updated_at                               :datetime         not null
#  report_id                                :bigint           not null
#
# Indexes
#
#  index_unsuccessful_sairan_cycles_on_report_id  (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
require 'test_helper'

class UnsuccessfulSairanCycleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
