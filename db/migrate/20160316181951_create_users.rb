class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :screen_name
      t.bigint :twitter_id
      t.string :token
      t.string :secret
    end
  end
end
