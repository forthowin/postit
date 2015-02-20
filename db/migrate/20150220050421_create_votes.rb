class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.boolean :vote
      t.string :voteable_type
      t.integer :voteable_id
      t.timestamps
    end
  end
end
