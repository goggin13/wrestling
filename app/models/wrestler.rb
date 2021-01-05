class Wrestler < ApplicationRecord
  has_one_attached :avatar

  def college_image_name
    college.downcase.gsub(" ", "_") + ".png"
  end
end
