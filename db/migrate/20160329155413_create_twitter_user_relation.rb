class CreateTwitterUserRelation < ActiveRecord::Migration[5.0]
  def change
    create_table :twitter_user_relations do |t|
      t.integer :from_id
      t.integer :to_id
    end

    add_index :twitter_user_relations, :from_id
    add_index :twitter_user_relations, :to_id
  end
end
