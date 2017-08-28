module UsersHelper
  def gravatar_for(user, options = { size: 100 })
    size = options[:size]
    if user.avatar.exists?
      if size > 100
        image_size = :medium
      elsif size < 100
        image_size = :mini
      else
        image_size = :thumb
      end
      image_url = user.avatar.url(image_size)
    else
      gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
      image_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    end
    image_tag(image_url, alt: user.username, class: "gravatar")
  end
end
