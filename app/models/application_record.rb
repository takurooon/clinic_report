class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :name_yomigana, -> { order('yomigana COLLATE "C" ASC') }
end
