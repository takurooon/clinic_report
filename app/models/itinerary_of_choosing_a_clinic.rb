class ItineraryOfChoosingAClinic < ApplicationRecord
  belongs_to :report
  belongs_to :clinic, optional: true
end

# == Schema Information
#
# Table name: itinerary_of_choosing_a_clinics
#
#  id                :bigint           not null, primary key
#  order_of_transfer :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  clinic_id         :bigint
#  report_id         :bigint           not null
#
# Indexes
#
#  index_itinerary_of_choosing_a_clinics_on_clinic_id  (clinic_id)
#  index_itinerary_of_choosing_a_clinics_on_report_id  (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (clinic_id => clinics.id)
#  fk_rails_...  (report_id => reports.id)
#
