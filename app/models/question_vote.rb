class QuestionVote < ActiveRecord::Base
	belongs_to :question 

	validates :question_id, :user_id, :vote, presence: true
	validates :question_id, uniqueness: { scope: :user_id }
end
