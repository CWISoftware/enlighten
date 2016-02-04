class CreateUsersLikingCards < ActiveRecord::Migration
  def change
    create_table :users_liking_cards, { id: false } do |t|
      t.references :user, index: true, foreign_key: true
      t.references :card, index: true, foreign_key: true
      t.timestamps
    end

    add_index :users_liking_cards, [:user_id, :card_id], unique: true
  end
end
