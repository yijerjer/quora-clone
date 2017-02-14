enable :sessions

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
	new_question = Question.create(text: params[:question_text], user_id: current_user.id)
	p new_question.id
	redirect "/questions/#{new_question.id}"
end

# upvote question
post '/questions/:id/upvote' do
	if logged_in?
		QuestionVote.create(question_id: params[:id], 
												user_id: current_user.id, 
												vote: 1
												)
		redirect '/'
	else
		redirect '/sessions/new'
	end
end

# downvote question
post '/questions/:id/downvote' do
	if logged_in?
		QuestionVote.create(question_id: params[:id], 
												user_id: current_user.id, 
												vote: -1
												)
		redirect '/'
	else
		redirect '/sessions/new'
	end
end

####################
# ANSWERS
####################

#upvote answer
post '/answers/:id/upvote' do
	if logged_in?
		AnswerVote.create(answer_id: params[:id], 
												user_id: current_user.id, 
												vote: 1
												)
		redirect '/'
	else
		redirect '/sessions/new'
	end
end

#downvote answer
post '/answers/:id/downvote' do
	if logged_in?
		AnswerVote.create(answer_id: params[:id], 
												user_id: current_user.id, 
												vote: -1
												)
		redirect '/'
	else
		redirect '/sessions/new'
	end
end
