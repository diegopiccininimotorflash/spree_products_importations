module Spree
  class ImportationVariant < ActiveRecord::Base
    attr_accessible :sku, :weight, :height, :width, :depth, :deleted_at, :is_master, :product_sku, :count_on_hand, :cost_price, :position, :on_demand, :cost_currency, :color, :talla, :imagen, :price
    belongs_to :importation_attachment, class_name: 'Spree::ImportationAttachment' 
    def set_attributes(hash_attributes)
      hash_attributes["count_on_hand"]=0 if hash_attributes["count_on_hand"]==''
      self.update_attributes(hash_attributes)      
    end
    def update_variant(svariant)  
      svariant.sku = self.sku
      svariant.weight = self.weight
      svariant.height = self.height
      svariant.width  = self.width
      svariant.depth = self.depth           
      svariant.deleted_at = self.deleted_at
      svariant.is_master = self.is_master      
      svariant.product_id = self.product_id
      svariant.count_on_hand = self.count_on_hand            
      svariant.cost_price = self.cost_price
      svariant.position = self.position
      svariant.on_demand = self.on_demand
      svariant.cost_currency = self.cost_currency        
      svariant.price = self.price
      svariant.save
      unless svariant.is_master
        svariant.prices.destroy_all
        svariant.save        
      end

      self.variant_id = svariant.id
      self.status = self.status + 200
      self.save      
    end
    
    def update_options
      variant = Variant.find(self.variant_id)
      if variant.nil?
        self.status += 1000       
      else
        variant.set_option_value('casco_size', self.talla)
        variant.set_option_value('casco_color', self.color)
        variant.price = self.price
        variant.save
        self.status += 2000
      end
      self.save
    end 

    def prepare_image
      if self.imagen == ''
        self.image_status = 4 # no se hace nada por tener el campo imagen vacio
      else
        spree_variant = Variant.find(self.variant_id)
        @image = spree_variant.images.find(:first, :conditions => {:attachment_file_name => self.imagen.to_s })
        if @image.nil?
          @asset=Asset.joins('INNER JOIN spree_variants ON spree_variants.id = viewable_id').find(:first,:conditions=> { :viewable_type => 'Spree::Variant' , :attachment_file_name => self.imagen })
          if @asset.nil?
            self.image_status = 3 # no existe imagen hay que crearla nueva
          else
            self.image_status = 2 # existe imagen pero es de otra variante
            self.asset_id = @asset.id
          end
        else
          self.image_status = 1 # la imagen ya estaba igual a la deseada
          self.asset_id = @image.id
        end
        
      end
      self.save
    end
    def original_image_path
      if self.asset_id > 0
        @image=Image.find(self.asset_id)      
        return @image.attachment.path(:original) unless @image.nil?      
      end  
      return false    
    end
    def original_image    
      path = self.original_image_path
      return false if !File.exist?(path)
      File.open(path)
    end
    def copy_asset
      if self.asset_id > 0
        @image=Image.find(:first,self.asset_id)  
        @variant = Variant.find(self.variant_id)
        @variant.images.destroy_all
        if @image.nil?
          self.image_status = 6 # error al copiar imagen
        else
          @variant.images.create!(:attachment => self.original_image )
          self.image_status = 5 # imagen copiada          
        end  
        self.save
      end
    end
    def get_message_by_image_status
      @status_hash = { 0 => 'Sin procesar' , 1 => 'ok', 2 => 'existe imagen pero es de otra variante',
         3 => 'se debe subir la imagen', 4 => '-' , 5 => 'imagen copiada' , 6 => 'error al copiar imagen' , 10 => 'imagen subida y grabada' }
      @message = 'estado desconocido'
      if  @status_hash.has_key?(self.image_status)  
        @message = @status_hash[self.image_status]     
      end
      return @message
    end   
    def get_color_by_image_status
      @status_hash = { 1 => 'green', 2 => 'orange', 3 => 'red', 5 => 'green', 6 => 'red' ,10 => 'green' }
      @color = 'blue'
      if  @status_hash.has_key?(self.image_status)  
        @color = @status_hash[self.image_status]     
      end
      return @color
    end
    
    def get_array_images_by_status(importation_attachment_id, status)
      @images_to_upload = ImportationVariant.where("importation_attachment_id = ? AND image_status = ? ", importation_attachment_id, status).group("imagen").order("imagen")
      return @images_to_upload
    end   
    
    def get_url_image(size = :mini)
        @spree_variant = Variant.find(self.variant_id)
        @image = @spree_variant.images.find(:first, :conditions =>{:attachment_file_name => self.imagen.to_s })
        @image_path = false 
        @image_path = @image.attachment.url(size)  unless @image.nil?          
 
        return @image_path
    end  
    def get_variant
      if self.variant_id.nil?
        return nil
      else
        variant = Variant.find(self.variant_id)
        return variant
      end
    end    
  end
end