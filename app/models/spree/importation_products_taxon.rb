module Spree
  class ImportationProductsTaxon < ActiveRecord::Base
    attr_accessible :sku, :taxon_name, :product_id, :taxon_id, :importation_id, :importation_attachment_id
    belongs_to :importation_attachment, class_name: 'Spree::ImportationAttachment' 
    def set_attributes(hash_attributes)
      self.update_attributes(hash_attributes)            
    end
    def get_product
      if self.product_id.nil?
        return nil
      else
        product = Product.find(self.product_id)
        return product
      end
    end  
    def get_taxon
      if self.taxon_id.nil?
        return nil
      else
        taxon = Taxon.find(self.taxon_id)
        return taxon
      end
    end         
  end
end