class CreateCardGalleries < ActiveRecord::Migration
  def change
    create_table :card_galleries do |t|
      t.references :card, index: true, foreign_key: true
      t.integer :timeout
      t.integer :order
      t.string :attachment_id

      t.timestamps null: false
    end
  end
end
