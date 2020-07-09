# == Schema Information
#
# Table name: users
#
#  id                                     :bigint           not null, primary key
#  all_cost                               :integer
#  all_grant_amount                       :integer
#  all_number_of_sairan                   :integer
#  all_number_of_transplants              :integer
#  birthday                               :datetime
#  confirmation_sent_at                   :datetime
#  confirmation_token                     :string
#  confirmed_at                           :datetime
#  current_sign_in_at                     :datetime
#  current_sign_in_ip                     :inet
#  drink                                  :integer
#  email                                  :string           default(""), not null
#  encrypted_password                     :string           default(""), not null
#  first_age_to_start                     :integer
#  first_age_to_start_art                 :integer
#  gender                                 :integer          default("female"), not null
#  image_url                              :string
#  last_sign_in_at                        :datetime
#  last_sign_in_ip                        :inet
#  link                                   :string
#  name                                   :string
#  number_of_aih                          :integer
#  number_of_early_miscarriages           :integer
#  number_of_late_miscarriages            :integer
#  number_of_times_the_grant_was_received :integer
#  provider                               :string
#  remember_created_at                    :datetime
#  reset_password_sent_at                 :datetime
#  reset_password_token                   :string
#  self_introduction                      :text
#  sign_in_count                          :integer          default(0), not null
#  uid                                    :string
#  unconfirmed_email                      :string
#  username                               :string
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
