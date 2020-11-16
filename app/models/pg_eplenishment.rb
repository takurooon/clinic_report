class PgEplenishment < ApplicationRecord
  has_many :report_pg_eplenishments, dependent: :destroy
  has_many :reports, through: :report_pg_eplenishments

  def str_pg_eplenishment
    return self.name
  end
end

# == Schema Information
#
# Table name: pg_eplenishments
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
