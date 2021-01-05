module WrestlersHelper
  DEFAULT_SIZE = "100x100"

  def avatar(wrestler, options={})
    size = (options[:size] || DEFAULT_SIZE)
    width, height = size.split("x")
    options = {resize_to_limit: [width, height]}
    if wrestler.avatar.attached?
      image_tag wrestler.avatar.variant(options)
    else
      image_tag "default_wrestler_avatar.png", options.merge(size: size)
    end
  end
end
