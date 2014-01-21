module Spree
  class ImportationProduct < ActiveRecord::Base
    attr_accessible :sku, :name, :description, :available_on, :deleted_at, :permalink, :meta_description, :meta_keywords, :tax_category_id, :shipping_category_id, :count_on_hand, :price
    belongs_to :importation_attachment, class_name: 'Spree::ImportationAttachment' 
    def set_attributes(hash_attributes)
      hash_attributes["count_on_hand"]= 0 
      if hash_attributes["count_on_hand"].to_i
        hash_attributes["count_on_hand"]= hash_attributes["count_on_hand"].to_i
      else
        hash_attributes["count_on_hand"]= 0 
      end
      self.update_attributes(hash_attributes)      
    end
    def update_product(sproduct)  
      sproduct.sku = self.sku
      sproduct.name=self.name
      sproduct.description = self.description      
      sproduct.available_on = self.available_on 
      sproduct.deleted_at = self.deleted_at
      sproduct.permalink =self.permalink  if self.permalink != ''
      sproduct.meta_description = self.meta_description
      sproduct.meta_keywords = self.meta_keywords
      sproduct.tax_category_id = self.tax_category_id
      sproduct.shipping_category_id = self.shipping_category_id
      sproduct.count_on_hand = self.count_on_hand 
      sproduct.price = self.price     
      sproduct.save!

      self.product_id=sproduct.id;
      self.status = self.status + 200
      self.save
      
    end
    def get_product
      if self.product_id.nil?
        return nil
      else
        product = Product.find(self.product_id)
        return product
      end
    end
  end
end