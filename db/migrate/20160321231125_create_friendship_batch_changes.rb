class CreateFriendshipBatchChanges < ActiveRecord::Migration
  def change
    create_table :friendship_batch_changes do |t|
      t.integer :user_id
      t.text :twitter_users_ids
      t.string :friendship_status
      t.string :status
      t.text :processed_twitter_users_ids
      t.text :unprocessed_twitter_users_ids
    end
  end
end
