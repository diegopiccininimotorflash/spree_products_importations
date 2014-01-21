class AddStatusToImportationProductsAndVariants < ActiveRecord::Migration
  def up
    add_column :spree_importation_products, :status, :integer, default: 1
    add_column :spree_importation_variants, :status, :integer, default: 1
   
  end
  def down
    remove_column :spree_importation_products , :status
    remove_column :spree_importation_variants , :status
   
  end
end
