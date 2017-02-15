enable :sessions
require 'byebug'
####################
# SIGNUP
####################

# render signup page
get '/users/new' do
	erb :'static/signup'
end

#signup user
post '/users' do	
	new_user = User.new(
		name: params[:user_name], 
		email: params[:user_email], 
		password: params[:user_password],
		password_confirmation: params[:user_reenter_password]
	)

	if new_user.valid?
		new_user.save
		"/sessions/new".to_json
	else
		new_user.errors.messages.to_json
	end
end

####################
# SIGN IN/SIGN OUT
####################

# render signin page
get '/sessions/new' do
	@msg = params[:msg]

	erb :'static/login'
end

# signin user
post '/sessions' do
	login_user = User.find_by(email: params[:login_email]).try(:authenticate, params[:login_password])
	if login_user
		session[:user_id] = login_user.id
		'/'.to_json
	elsif login_user == nil # when email is incorrect
		'Invalid email.'.to_json
	elsif login_user == false # when password is incorrect
		'Incorrect password.'.to_json
	end

end

# signout user
get '/sessions/destroy' do
	session[:user_id] = nil
	redirect "/"
end

####################
# RENDER INFO
####################

# displays all questions
get '/' do
	@all_qu = Question.all

  erb :'static/index'
end

# get profile page of user
get '/users/:id' do
	@profile = User.find(params[:id])
	@user_ques = @profile.questions
	@user_ans = @profile.answers

	erb :'static/profile_page'
end

####################
# QUESTIONS
####################

# display a specific question
get '/questions/:id' do
	@question = Question.find(params[:id])

	erb :'static/question'
end

# creates a new question
post '/questions' do
	if logged_in?
		if params[:question_text] != ""
			new_question = Question.create(text: params[:question_text], user_id: current_user.id)
			"/questions/#{new_question.id}".to_json
		else
			"Eh WHere question?!?!".to_json
		end
	else
	"/sessions/new".to_json
	end
end

# deletes a question
delete '/questions/:id' do
	Question.find(params[:id]).destroy
	Answer.where(question_id: params[:id]).delete_all

	"destroyed question and its answers".to_json
end
	

# upvote question
post '/questions/:id/upvote' do
	if logged_in?
		user_vote = QuestionVote.find_by(question_id: params[:id], user_id: current_user.id)

		if user_vote == nil
			QuestionVote.create(question_id: params[:id], 
													user_id: current_user.id, 
													vote: 1
													)
			"upvote".to_json
		elsif user_vote.vote == 1 # if the user has already upvoted, remove his upvote
			user_vote.destroy
			"un-upvote".to_json
		elsif user_vote.vote == -1 # if the user has downvoted, make it an upvote
			user_vote.update(vote: 1)
			"upvote un-downvote".to_json
		end
	else
 		"/sessions/new".to_json
	end
end

# downvote question
post '/questions/:id/downvote' do
	if logged_in?
		user_vote = QuestionVote.find_by(question_id: params[:id], user_id: current_user.id)

		if user_vote == nil
			QuestionVote.create(question_id: params[:id], 
													user_id: current_user.id, 
													vote: -1
													)
			"downvote".to_json
		elsif user_vote.vote == -1 # if the user has already downvoted, remove his downvote
			user_vote.destroy
			"un-downvote".to_json
		elsif user_vote.vote == 1 # if the user has upvoted, make it a downvote
			user_vote.update(vote: -1)
			"un-upvote downvote".to_json
		end
	else
		"/sessions/new".to_json
	end
end

####################
# ANSWERS
####################

#answer a question
post '/questions/:id/answers' do
	if logged_in?
		if params[:answer_text] == ""
			"You did not provide an answer.".to_json
		else
			new_answer = Answer.create(text: params[:answer_text], question_id: params[:id], user_id: current_user.id)
			"/questions/#{params[:id]}".to_json
		end
	else
		"/sessions/new".to_json
	end
end

delete '/answers/:id' do
	Answer.find(params[:id]).destroy
	"destroyed answer".to_json
end


#upvote answer
post '/answers/:id/upvote' do
	if logged_in?
		user_vote = AnswerVote.find_by(answer_id: params[:id], user_id: current_user.id)

		if user_vote == nil
			AnswerVote.create(answer_id: params[:id], 
													user_id: current_user.id, 
													vote: 1
													)
			"upvote".to_json
		elsif user_vote.vote == 1 # if the user has already upvoted, remove his upvote
			user_vote.destroy
			"un-upvote".to_json
		elsif user_vote.vote == -1 # if the user has downvoted, make it an upvote
			user_vote.update(vote: 1)
			"upvote un-downvote".to_json
		end
	else
		"/sessions/new".to_json
	end
end

#downvote answer
post '/answers/:id/downvote' do
	if logged_in?
		user_vote = AnswerVote.find_by(answer_id: params[:id], user_id: current_user.id)

		if user_vote == nil
			AnswerVote.create(answer_id: params[:id], 
													user_id: current_user.id, 
													vote: -1
													)
			"downvote".to_json
		elsif user_vote.vote == -1 # if the user has already downvoted, remove his downvote
			user_vote.destroy
			"un-downvote".to_json
		elsif user_vote.vote == 1 # if the user has upvoted, make it a downvote
			user_vote.update(vote: -1)
			"un-upvote downvote".to_json
		end
	else
		"/sessions/new".to_json
	end
end
