class CreateCardAttachments < ActiveRecord::Migration
  def change
    create_table :card_attachments do |t|
      t.references :card, index: true, foreign_key: true
      t.string :attachment_id

      t.timestamps null: false
    end
  end
end
