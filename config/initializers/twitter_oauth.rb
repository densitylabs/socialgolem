# Required overwrites for the TwitterOauth gem
module TwitterOAuth
  class Client
    def unfriend(id)
      post("/friendships/destroy.json?user_id=#{id}")
    end

    def friend(id)
      post("/friendships/create.json?user_id=#{id}")
    end
  end
end
