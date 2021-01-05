class Wrestler < ApplicationRecord
  has_one_attached :avatar
  belongs_to :college, required: false
end
