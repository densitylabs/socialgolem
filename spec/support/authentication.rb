module Authentication
  def authenticate_user(user = nil)
    user ||= create(:user)
    session[:user_id] = user.id
  end
end
