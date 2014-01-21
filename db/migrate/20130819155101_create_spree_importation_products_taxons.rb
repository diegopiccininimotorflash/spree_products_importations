class CreateSpreeImportationProductsTaxons < ActiveRecord::Migration
  def up
    create_table :spree_importation_products_taxons do |t|
      t.string     :sku,           :default => '',    :null => false
      t.string     :taxon_name,    :default => '', :null => false
      t.integer    :product_id      
      t.integer    :taxon_id
      t.integer    :status,        :default => 1,  :null => false
      t.references :importation
      t.references :importation_attachment
    end
    
  end

  def down
    drop_table :spree_importation_products_taxons
  end
end
