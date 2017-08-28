class CustomMentionProcessor < MentionSystem::MentionProcessor

  def extract_mentioner_content(post)
    post.content.downcase
  end

  def find_mentionees_by_handles(*handles)
    User.where(username: handles)
  end
end
