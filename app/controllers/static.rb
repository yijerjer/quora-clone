enable :sessions

# displays all questions
get '/' do
	@all_qu = Question.all

  erb :'static/index'
end

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
		redirect "/"

	else
		@errors = new_user.errors.messages
		# redirect "/users/new?#{@errors}"
	end

	erb :'static/signup'
end

# get profile page of user
get '/users/:id' do
	@profile = User.find(params[:id])
	@user_ques = @profile.questions
	@user_ans = @profile.answers
	erb :'static/profile_page'
end

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
		redirect "/"
	elsif login_user == nil # when email is incorrect
		msg = 'Invalid email'
		redirect "/sessions/new?msg=#{msg}"
	elsif login_user == false # when password is incorrect
		msg = 'Incorrect password'
		redirect "/sessions/new?msg=#{msg}"
	end

end

# signout user
get '/sessions/destroy' do
	session[:user_id] = nil
	redirect "/"
end

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
