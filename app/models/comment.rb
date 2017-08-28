class Comment < ApplicationRecord

act_as_mentioner

belongs_to :post
belongs_to :user

validates  :content, presence: true


end
