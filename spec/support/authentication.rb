module Authentication
  def authenticate_user(user = nil)
    user ||= create(:user)
    cookies.signed[:user_id] = user.id
  end
end
