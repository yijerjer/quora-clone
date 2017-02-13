enable :sessions

get '/' do
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


