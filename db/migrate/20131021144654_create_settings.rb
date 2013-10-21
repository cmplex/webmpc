class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.float :next_vote_trigger
      t.float :wish_timeout

      t.timestamps
    end
  end
end
