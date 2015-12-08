class Relationship < ActiveRecord::Base
    belongs_to :follower_id, class: "User"
    belongs_to :followed_id, class: "User"
    validates :followed_id, presence: true
    validates :follower_id, presence: true
end
