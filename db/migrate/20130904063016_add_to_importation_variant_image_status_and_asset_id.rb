class AddToImportationVariantImageStatusAndAssetId < ActiveRecord::Migration
  def up
    add_column :spree_importation_variants, :image_status, :integer, default: 0
    add_column :spree_importation_variants, :asset_id, :integer, default: 0
  end
  def down
    remove_column :spree_importation_variants, :image_status
    remove_column :spree_importation_variants, :asset_id
  end
end
