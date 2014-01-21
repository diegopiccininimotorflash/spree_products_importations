class AddStatusToImportationAtachment < ActiveRecord::Migration
  def up
    add_column :spree_importation_attachments, :status, :integer, default: 1
  end
  def down
    remove_column :spree_importation_attachments, :status
  end
end
