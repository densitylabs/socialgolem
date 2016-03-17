# Required overwrites for the TwitterOauth gem
module TwitterOAuth
  class Client
    def unfriend(id)
      post("/friendships/destroy.json?user_id=#{id}")
    end
  end
end
