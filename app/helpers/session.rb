helpers do
  def login(user)
    session[:current_user_id] = user.id unless login?
  end

  def current_user
    @current_user ||= User.find_by_id(session[:current_user_id])
  end

  def login?
    current_user ? true : false
  end

end