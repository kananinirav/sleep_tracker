class CreateUserFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :user_friendships do |t|
      t.references :follower_user, foreign_key: { to_table: :users }
      t.references :following_user, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :user_friendships, %i[follower_user_id following_user_id], unique: true, name: 'user_friendship_index'
  end
end
