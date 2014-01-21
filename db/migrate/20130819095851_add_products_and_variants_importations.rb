class AddProductsAndVariantsImportations < ActiveRecord::Migration
  def up
    create_table :spree_importation_products do |t|
      t.string     :sku,                                         :default => '',    :null => false
      t.string     :name,                 :default => '', :null => false
      t.text       :description
      t.datetime   :available_on
      t.datetime   :deleted_at
      t.string     :permalink
      t.string     :meta_description
      t.string     :meta_keywords
      t.references :tax_category
      t.references :shipping_category
      t.integer    :count_on_hand,        :default => 0,  :null => false
      t.decimal    :price,         :precision => 8, :scale => 2,                    :null => false
      t.references :importation
      t.references :importation_attachment
      t.integer    :product_id
    end

    create_table :spree_importation_variants do |t|
      t.string     :sku,                                         :default => '',    :null => false      
      t.decimal    :weight,        :precision => 8, :scale => 2
      t.decimal    :height,        :precision => 8, :scale => 2
      t.decimal    :width,         :precision => 8, :scale => 2
      t.decimal    :depth,         :precision => 8, :scale => 2
      t.datetime   :deleted_at
      t.boolean    :is_master,                                   :default => false
      t.string     :product_sku,                                 :default => '',    :null => false    
      t.integer    :count_on_hand,                               :default => 0,     :null => false
      t.decimal    :cost_price,    :precision => 8, :scale => 2
      t.integer    :position
      t.boolean    :on_demand,                                   :default => false
      t.string     :cost_currency,                               :default => 'EUR'
      t.string     :color,                               :default => ''
      t.string     :talla,                               :default => ''
      t.string     :imagen,                              :default => ''
      t.decimal    :price,         :precision => 8, :scale => 2,                    :null => false
      t.references :importation
      t.references :importation_attachment
      t.integer    :product_id
      t.integer    :variant_id
    end   
  end

  def down
     drop_table :spree_importation_products
     drop_table :spree_importation_variants
  end
end
