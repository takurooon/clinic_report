# == Schema Information
#
# Table name: pg_eplenishments
#
#  id         :bigint           not null, primary key
#  name       :string
#  number     :integer
#  yomigana   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class PgEplenishmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
