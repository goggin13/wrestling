class Wrestler < ApplicationRecord
  has_one_attached :avatar
  belongs_to :college, required: false

  def initials
    name.split(" ").map do |name|
      name[0]
    end.join("")
  end
end
