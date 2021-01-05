module WrestlersHelper
  DEFAULT_SIZE = "100x100"

  def avatar(wrestler, options={})
    options[:size] ||= DEFAULT_SIZE
    width, height = options[:size].split("x")
    if wrestler.avatar.attached?
      image_tag wrestler.avatar.variant(resize_to_limit: [width, height]), options
    else
      image_tag "default_wrestler_avatar.png", options
    end
  end
end
