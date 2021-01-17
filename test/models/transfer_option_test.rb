# == Schema Information
#
# Table name: transfer_options
#
#  id         :bigint           not null, primary key
#  name       :string
#  number     :integer
#  yomigana   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TransferOptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
