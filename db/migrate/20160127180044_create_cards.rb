class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :section
      t.string :title
      t.string :subtitle
      t.text :description
      t.text :style
      t.integer :size
      t.references :cardable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
