class CreateImportationAttachments < ActiveRecord::Migration
  def up
    create_table :spree_importation_attachments do |t|
      t.string :filename
      t.string :content_type
      t.binary :data
      t.string :collection_name
      t.references  :importation
      t.timestamps
    end
  end
  def down
    drop_table :spree_importation_attachments
  end
end
