class AddIndexToQuestionUserId < ActiveRecord::Migration
	def change
		add_index :question_votes, [:question_id, :user_id], unique: true
		add_index :answer_votes, [:answer_id, :user_id], unique: true
	end
end
