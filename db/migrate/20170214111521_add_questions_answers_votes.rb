class AddQuestionsAnswersVotes < ActiveRecord::Migration
	def change
		create_table :question_votes do |t|
			t.integer :question_id
			t.integer :user_id
			t.integer :vote
		end

		create_table :answer_votes do |t|
			t.integer :answer_id
			t.integer :user_id
			t.integer :vote
		end		
	end
end
