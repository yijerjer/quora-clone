class Answer < ActiveRecord::Base
	belongs_to :question
	belongs_to :user
	has_many :answer_votes

	validates :text, :user_id, :question_id, presence: true
end
