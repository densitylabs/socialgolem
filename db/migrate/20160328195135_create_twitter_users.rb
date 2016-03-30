class CreateTwitterUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :twitter_users do |t|
      t.bigint :twitter_id
      t.string :name
      t.string :screen_name
      t.integer :friends_count
      t.integer :followers_count
      t.integer :statuses_count
      t.string :profile_image_url
    end

    add_index :twitter_users, :twitter_id
  end
end
