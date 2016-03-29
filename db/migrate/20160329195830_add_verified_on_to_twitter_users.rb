class AddVerifiedOnToTwitterUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :twitter_users, :verified_on, :datetime
  end
end
