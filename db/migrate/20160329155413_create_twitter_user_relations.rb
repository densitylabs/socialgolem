class CreateTwitterUserRelation < ActiveRecord::Migration[5.0]
  def change
    create_table :twitter_user_relations do |t|
      t.integer :friend_id
      t.integer :follower_id
    end

    add_index :twitter_user_relations, :friend_id
    add_index :twitter_user_relations, :follower_id
  end
end
