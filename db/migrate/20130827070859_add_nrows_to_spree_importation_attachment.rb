class AddNrowsToSpreeImportationAttachment < ActiveRecord::Migration
  def up
    add_column :spree_importation_attachments, :ncols, :integer, default: 0
    add_column :spree_importation_attachments, :nrows, :integer, default: 0
    add_column :spree_importation_attachments, :nlines, :integer, default: 0
    add_column :spree_importation_attachments, :nupdates, :integer, default: 0
    add_column :spree_importation_attachments, :ncreates, :integer, default: 0
    add_column :spree_importation_attachments, :nerrors, :integer, default: 0
  end
  def down
    remove_column :spree_importation_attachments, :ncols
    remove_column :spree_importation_attachments, :nrows
    remove_column :spree_importation_attachments, :nlines
    remove_column :spree_importation_attachments, :nupdates
    remove_column :spree_importation_attachments, :ncreates
    remove_column :spree_importation_attachments, :nerrors   
  end
end
