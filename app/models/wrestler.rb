class Wrestler < ApplicationRecord

  def image_name
    name.downcase.gsub(" ", "_") + ".png"
  end

  def college_image_name
    college.downcase.gsub(" ", "_") + ".png"
  end
end
