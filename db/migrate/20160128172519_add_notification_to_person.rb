class AddNotificationToPerson < ActiveRecord::Migration
  def change
    add_column :people, :notification, :boolean
  end
end
