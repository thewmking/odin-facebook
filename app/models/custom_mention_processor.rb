class CustomMentionProcessor < MentionSystem::MentionProcessor

  def extract_mentioner_content(mentioner)
    mentioner.content.downcase
  end

  def find_mentionees_by_handles(*handles)
    User.where(username: handles)
  end
end
