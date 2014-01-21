class CreateImportations < ActiveRecord::Migration
  def up
    create_table :spree_importations do |t|
      t.string :name
      t.integer :status
      t.timestamp :created_at

      t.timestamps
    end
  end
  def down
    drop_table      :spree_importations
  end
end
