module Spree
  class Importation < ActiveRecord::Base
    attr_accessible :created_at, :name, :status
    has_many :importation_attachments, class_name: 'Spree::ImportationAttachment', dependent: :destroy
    def attachments_list      
      return self.attachments_table_map.keys
    end
    def attachments_table_map
      return {"products"=> :spree_importation_products, "variants" => :spree_importation_variants, "products_taxons" => :spree_importation_products_taxons, "images" => :spree_importation_images }
    end

    def attachments 
      attachment_list = ImportationAttachment.where(importation_id: self.id, collection_name: self.attachments_list)
      return attachment_list
    end
    def attachments_not_uploaded
      attachment_files = self.attachments
      files_uploaded = Array.new
      attachment_files.each do |af|
        files_uploaded.push af.collection_name 
      end     
      files_not_uploaded = self.attachments_list - files_uploaded
      files_not_uploaded.push 'images' unless files_not_uploaded.include?('images')
      return files_not_uploaded
    end
    def get_path_files
      return Rails.root.join('public','spree', 'importations', self.id.to_s) 
    end    
    def remove_all_files
      directory =  self.get_path_files
      system "rm -rf #{directory}/* "     
    end    
    def remove_directory
      directory =  self.get_path_files
      system "rmdir #{directory} "     
    end       
    def get_files
      @files = Dir.glob(self.get_path_files + "*")
      @f = Hash.new
      for file in @files
        f= { :name => File.basename(file) , :url =>  "/spree/importations/" + self.id.to_s + "/" + File.basename(file) , :file => file }
        @f[ File.basename(file) ] = f
      end
      return  @f
    end

  end
end