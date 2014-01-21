class AddToImportationAttachmentDataHash < ActiveRecord::Migration
  def up
    add_column :spree_importation_attachments, :data_hash, :binary
  end

  def down
    remove_column :spree_importation_attachments, :data_hash
  end
end
