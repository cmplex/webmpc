class AddLastWishToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_wish, :datetime
  end
end
