class AnswerVote < ActiveRecord::Base
	belongs_to :answer

	validates :answer_id, :user_id, :vote, presence: true
	validates :answer_id, uniqueness: { scope: :user_id }
end
