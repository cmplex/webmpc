class CreateHypeVotes < ActiveRecord::Migration
  def change
    create_table :hype_votes do |t|
      t.references :user, index: true
      t.references :song, index: true

      t.timestamps
    end
  end
end
