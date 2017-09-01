module ApplicationHelper

  def render_with_mentions(resource)
    content_words = resource.content.split(" ")
    content_with_links = content_words.map do |word|
      if word.start_with?("@")
        user = User.where(username: word.downcase.gsub('@', '')).first
        link_to "@#{user.username}", user, class: 'user-link'
      else
        word
      end
    end
    content_with_links.join(" ")
  end

end
