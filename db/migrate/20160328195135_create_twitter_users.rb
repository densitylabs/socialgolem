class CreateTwitterUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :twitter_users do |t|
      t.string :twitter_id
      t.string :screen_name
      t.integer :friends_count
      t.integer :followers_count
      t.integer :tweet_count
      t.string :profile_image_url
    end
  end
end
