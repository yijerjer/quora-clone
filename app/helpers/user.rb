helpers do
  # This will return the current user, if they exist
  # Replace with code that works with your application
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    end
  end

  # Returns true if current_user exists, false otherwise
  def logged_in?
    !current_user.nil?
  end

  def set_question_vote_button_color(question, vote_type)
    if vote_type == "upvote"
      num_1 = 1
      num_2 = -1
    elsif vote_type == "downvote"
      num_1 = -1
      num_2 = 1
    end

    if !logged_in? || question.question_votes.find_by(user_id: current_user.id) == nil || question.question_votes.find_by(user_id: current_user.id).vote == num_2
      html_string = "<button type=\"submit\" class=\"btn btn-default btn-sm\">"
    elsif question.question_votes.find_by(user_id: current_user.id).vote == num_1
      html_string = "<button type=\"submit\" class=\"btn btn-default btn-sm btn-grey\">"
    end
  end

  def set_answer_vote_button_color(answer, vote_type)
    if vote_type == "upvote"
      num_1 = 1
      num_2 = -1
    elsif vote_type == "downvote"
      num_1 = -1
      num_2 = 1
    end

    if !logged_in? || answer.answer_votes.find_by(user_id: current_user.id) == nil || answer.answer_votes.find_by(user_id: current_user.id).vote == num_2
      html_string = "<button type=\"submit\" class=\"btn btn-default btn-xs\">"
    elsif answer.answer_votes.find_by(user_id: current_user.id).vote == num_1
      html_string = "<button type=\"submit\" class=\"btn btn-default btn-xs btn-grey\">"
    end
  end
end