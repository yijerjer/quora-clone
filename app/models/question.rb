class Question < ActiveRecord::Base
	belongs_to :user
	has_many :answers
	has_many :question_votes
	
	validates :text, :user_id, presence: true
end


