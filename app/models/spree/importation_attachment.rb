module Spree
  class ImportationAttachment < ActiveRecord::Base
    attr_accessible :collection_name, :content_type, :data, :filename, :importation_id
    belongs_to :importation, class_name: 'Spree::Importation'
    serialize :data_hash
    has_many :importation_products_taxons, dependent: :destroy, class_name: 'Spree::ImportationProductsTaxon'
    has_many :importation_variants, dependent: :destroy, class_name: 'Spree::ImportationVariant'
    has_many :importation_products, dependent: :destroy, class_name: 'Spree::ImportationProduct'
 
    def uploaded_file=(incoming_file)
        self.filename = incoming_file.original_filename
        self.content_type = incoming_file.content_type
        self.data = incoming_file.read
    end

    def filename=(new_filename)
        write_attribute("filename", sanitize_filename(new_filename))
    end
    
    def parse_file
      hash_lines=self.data.to_s.split("\n")
      @i=1
      @rows = Array.new
      @pre_row = Array.new
      hash_lines.each do |line|
        if @i==1
          @columns=line.split("\t")  
        else
           @row = line.split("\t")
           if @row.count==@columns.count
             @rows.push @row 
           else
             if @pre_row.empty?
               @pre_row = @row
             else
               @row.delete_at(0)
               @new_row = @pre_row + @row
               if @new_row.count >= @columns.count
                 @rows.push @new_row
                 @pre_row = Array.new
               end
             end
           end
           
        end
        @i = @i.next
      end      
      if self.nlines == 0
        self.nlines = @rows.count
        self.ncols = @columns.count
        self.save
      end      

      return @rows
    end
    
    def get_columns
      hash_lines=self.data.to_s.split("\n")    
      return hash_lines[0].split("\t")
    end
    
    def step1
      @i=1
      @columns = self.get_columns
      @rows = Array.new
      @messages = Array.new
      @total_hash = Array.new
      @ok = false 
      
      self.parse_file.each do |line|
        @hash_row = Hash.new
        @row = line
        @nrow = @i.pred
        if @row.count != @columns.count 
          @messages.push "La fila #{@nrow} no tiene las columnas correctas #{@row.count} de #{@columns.count}" 
        else     
          @columns.each do |column_name|
            @hash_row[column_name]= @row[@columns.index(column_name)]
          end 
          @total_hash.push @hash_row
        end       
        @i = @i.next
      end
      @messages.push "No hay datos a importar" if @total_hash.empty?
      @messages.push "No hay columnas en el fichero que ha subido compruebe que sea un csv tabulado" if @columns.empty?

      @columns.each do |c|
        unless ActiveRecord::Base.connection.column_exists?(self.get_importation_table, c)
          @messages.push "la columna #{c} no existe"
        end
      end
      if @messages.empty?
        @ok=true
        @messages.push "Validacion de campos completada. filas a importar #{@total_hash.count}" 
      end
      case self.collection_name
      when 'products'
        ImportationProduct.destroy_all(:importation_attachment_id => self.id)
      when 'variants'
        ImportationVariant.destroy_all(:importation_attachment_id => self.id)
      when 'products_taxons'
        ImportationProductsTaxon.destroy_all(:importation_attachment_id => self.id)
      end    
        
      @response_returned = {"ok" => @ok, 'messages' => @messages , 'total_hash' => @total_hash }  
      return @response_returned           
    end
    
    def step2
      @messages = Array.new
      @total_hash = self.data_hash
      @ok = false 
      
      case self.collection_name
      when 'products'
        @total_hash.each do |product|
          @product = ImportationProduct.find(:first,:conditions=> {:sku => product["sku"], :importation_attachment_id => self.id })
          @product = ImportationProduct.new if @product.nil?
          @product.set_attributes(product)
          @product.importation_id=self.importation_id
          @product.importation_attachment_id=self.id
          @product.save
          @messages.push "sku #{@product.sku} "
        end

      when 'variants'
        @total_hash.each do |variant|
          @variant = ImportationVariant.find(:first,:conditions=> {:sku => variant["sku"], :importation_attachment_id => self.id })
          @variant = ImportationVariant.new if @variant.nil?
          @variant.set_attributes(variant)
          @variant.importation_id=self.importation_id
          @variant.importation_attachment_id=self.id
          @variant.save
          @messages.push "sku #{@variant.sku} "
        end    
      when 'products_taxons'
        @total_hash.each do |product_taxon|
          @product_taxon = ImportationProductsTaxon.find(:first,:conditions=> {:sku => product_taxon["sku"], :importation_attachment_id => self.id })
          @product_taxon = ImportationProductsTaxon.new if @product_taxon.nil?
          @product_taxon.set_attributes(product_taxon)
          @product_taxon.importation_id=self.importation_id
          @product_taxon.importation_attachment_id=self.id
          @product_taxon.save
          @messages.push "sku #{@product_taxon.sku } , #{@product_taxon.taxon_name } "  
        end      
      end
     
      @ok = true
      @response_returned = {"ok" => @ok, 'messages' => @messages } 
      return @response_returned
    end
    
    def step3
      @messages = Array.new
 
      @ok = false 
      case self.collection_name
      when 'products'
        @products = ImportationProduct.find(:all,:conditions=> { :importation_attachment_id => self.id })
        @products.each do |product|
          spree_variant = Variant.find(:first ,:conditions=> { :sku => product.sku, :deleted_at => nil })
          if spree_variant.nil?
            product.status = 2
          else 
            product.product_id = spree_variant.product_id
            if spree_variant.is_master?
              product.status = 3 
            else
              product.status = 10
            end
          end
          product.save
          message = {:sku => product.sku, :status => product.status }
          @messages.push message
        end

      when 'variants'
        @variants = ImportationVariant.find(:all,:conditions=> { :importation_attachment_id => self.id })
        @variants.each do |variant|
          spree_variant = Variant.find(:first ,:conditions=> { :sku => variant.sku, :deleted_at => nil })
          if spree_variant.nil?
            variant.status = 2
          else
            variant.product_id = spree_variant.product_id 
            variant.variant_id = spree_variant.id
            if spree_variant.is_master?
              variant.status = 11
            else
              variant.status = 3
            end
          end
          spree_variant_product = Variant.find(:first ,:conditions=> { :sku => variant.product_sku, :deleted_at => nil })
          if spree_variant_product.nil?
            variant.status = variant.status + 100 
          else
            variant.product_id=spree_variant_product.product_id
          end
          variant.save
          message = {:sku => variant.sku, :status => variant.status }
          @messages.push message
        end
      when 'products_taxons'
        @products_taxons = ImportationProductsTaxon.find(:all,:conditions=> { :importation_attachment_id => self.id })
        @products_taxons.each do |product_taxon|
          spree_variant = Variant.find(:first ,:conditions=> { :sku => product_taxon.sku, :deleted_at => nil })
          spree_taxon = Taxon.find(:first ,:conditions=> { :name => product_taxon.taxon_name, :taxonomy_id => 1 })
          unless spree_taxon.nil? || spree_variant.nil?
            product_taxon.taxon_id = spree_taxon.id      
            product_taxon.product_id = spree_variant.product_id
            product_taxon.status = 3            
          else
            product_taxon.status = 12 if spree_variant.nil?
            product_taxon.status = 13 if spree_taxon.nil?            
            product_taxon.status = 14 if spree_variant.nil? && spree_taxon.nil?
          end
          product_taxon.save
          message = {:sku => product_taxon.sku + ' ' + product_taxon.taxon_name, :status => product_taxon.status }
          @messages.push message     
        end

      end
      @ok = true      
      @response_returned = {"ok" => @ok, 'messages' => @messages } 
      return @response_returned      
    end
    
     def step4
      @messages = Array.new
 
      @ok = false 
      case self.collection_name
      when 'products'
        @products = ImportationProduct.where("importation_attachment_id = ? AND status IN (?) ",self.id, [2,3])
        @products.each do |product|
          case product.status
          when 2
            @sproduct = Product.new
           
          when 3
            @sproduct = Product.find(product.product_id)
          end
          product.update_product(@sproduct)         

          message = {:sku => product.sku, :status => product.status }
          @messages.push message
        end

      when 'variants'
        @variants = ImportationVariant.where("importation_attachment_id = ? AND status IN (?) ",self.id, [2,3,11])
        @variants.each do |variant|
          case variant.status
          when 2
            svariant = Variant.new
            
          when 3
            svariant = Variant.find(variant.variant_id)
          when 11
            svariant = Variant.find(variant.variant_id)
          end
          variant.update_variant(svariant)
          message = {:sku => variant.sku, :status => variant.status }
          @messages.push message
        end
      when 'products_taxons'
        @products_taxons = ImportationProductsTaxon.where("importation_attachment_id = ? AND status = ? ",self.id, 3)
        @products_taxons.each do |product_taxon|
          @product = Product.find(product_taxon.product_id)
          @taxon = Taxon.find(product_taxon.taxon_id)
          unless @product.taxons.include?(@taxon)
            @product.taxons << @taxon
          else
            if @product.taxons.where("taxon_id = ? ",product_taxon.taxon_id).count > 1

              @product.taxons.delete @taxon
              @product.taxons << @taxon
            end
          end
          product_taxon.status = 203
          product_taxon.save
          message = {:sku => product_taxon.sku + ' ' + product_taxon.taxon_name, :status => product_taxon.status }
          @messages.push message
        end
      end
      @ok = true      
      @response_returned = {"ok" => @ok, 'messages' => @messages } 
      return @response_returned      
    end
 
    def step5
      @messages = Array.new 
      @ok = false 
      case self.collection_name
      when 'variants'
        @ok = true 
        @variants = ImportationVariant.where("importation_attachment_id = ? AND variant_id is not null AND is_master = false",self.id)
        @variants.each do |variant|
          variant.update_options
          message = {:sku => variant.sku, :status => variant.status }
          @messages.push message
        end
      else
        @messages.push "no mas datos que actualizar"
      end
        
      @response_returned = {"ok" => @ok, 'messages' => @messages } 
      return @response_returned      
    end  
    
    def step6
      @messages = Array.new 
      @ok = false 
      case self.collection_name
      when 'variants'
        @ok = true 
        @variants = ImportationVariant.where("importation_attachment_id = ? AND variant_id is not null ",self.id)
        @variants.each do |variant|
          variant.prepare_image
          message = {:sku => variant.sku  , :image => variant.imagen.to_s ,:status => variant.get_message_by_image_status, 
            :status_color => variant.get_color_by_image_status, :image_original => variant.original_image_path  }
          @messages.push message
        end
      else
        @messages.push "no mas datos que actualizar"
      end
     
      @response_returned = {"ok" => @ok, 'messages' => @messages } 
      return @response_returned      
    end   
      
    def step7
      @messages = Array.new 
      @ok = false 
      case self.collection_name
      when 'variants'
        @ok = true 
        @variants = ImportationVariant.where("importation_attachment_id = ? AND image_status = 2 ",self.id )
        @variants.each do |variant|
          variant.copy_asset
   
          message = {:sku => variant.sku  , :image => variant.imagen.to_s ,:status => variant.get_message_by_image_status, 
            :status_color => variant.get_color_by_image_status , :image_original => variant.get_url_image }
          @messages.push message
        end
      else
        @messages.push "no mas datos que actualizar"
      end
   
      @response_returned = {"ok" => @ok, 'messages' => @messages } 
      return @response_returned      
    end  
    
    def step8
      @messages = Array.new 
      @ok = false 
      case self.collection_name
      when 'variants'
        @ok = true 
        @images_attachment = ImportationAttachment.find(:first, :conditions => {:collection_name => "images", :importation_id => self.importation_id, :status => 2  })
        @files = Hash.new
        unless @images_attachment.nil?
          @files = @images_attachment.get_files
        end
     
        @variants = ImportationVariant.where("importation_attachment_id = ? AND image_status = ? ",self.id, 3 )
        @variants.each do |variant|
          @spree_variant = Variant.find(variant.variant_id)
          if  @files.has_key?(variant.imagen.to_s)
            @spree_variant.images.destroy_all
            @spree_variant.images.create!(:attachment => File.open(@files[variant.imagen.to_s][:file]) )
            variant.image_status = 10
            variant.save
   
          end

          message = {:sku => variant.sku  , :image => variant.imagen.to_s ,:status => variant.get_message_by_image_status, 
            :status_color => variant.get_color_by_image_status, :image_original => variant.get_url_image }
          @messages.push message
        end
      else
        @messages.push "no mas datos que actualizar"
      end

      @response_returned = {"ok" => @ok, 'messages' => @messages } 
      return @response_returned      
    end 

    def variant_images
      @messages = Array.new 
      @variants = ImportationVariant.where("importation_attachment_id = ?  ",self.id)
      @variants.each do |variant|
  
        message = {:sku => variant.sku  , :image => variant.imagen.to_s ,:status => variant.get_message_by_image_status, 
          :status_color => variant.get_color_by_image_status, :image_original => variant.get_url_image }
        @messages.push message
      end


      return @messages     
    end 
                 
    def final
      @messages = Array.new
      case self.collection_name
      when 'products'
        @products = ImportationProduct.find(:all,:conditions=> { :importation_attachment_id => self.id })
        @products.each do |product|
          message = {:sku => product.sku, :status => product.status }
          @messages.push message       
        end
      when 'variants'
        @variants = ImportationVariant.find(:all,:conditions=> { :importation_attachment_id => self.id })
        @variants.each do |variant|
          message = {:sku => variant.sku, :status => variant.status }
          @messages.push message
          end 
      when 'products_taxons'
        @products_taxons = ImportationProductsTaxon.find(:all,:conditions=> { :importation_attachment_id => self.id })
        @products_taxons.each do |product_taxon|
          message = {:sku => product_taxon.sku + ' ' + product_taxon.taxon_name, :status => product_taxon.status }
          @messages.push message
          end           
      end
      @response_returned = {'messages' => @messages } 
      return @response_returned 
    end
    def count_status_collections
      @messages = Array.new
      case self.collection_name
      when 'products'
        @products = ImportationProduct.select("status, count(id) as total").where("importation_attachment_id = ?", self.id ).group("status")
        @products.each do |product|
          message = {:status => product.status, :total => product.total }
          @messages.push message       
        end
      when 'variants'
        @variants = ImportationVariant.select("status, count(id) as total").where("importation_attachment_id = ?", self.id ).group("status")
        @variants.each do |variant|
          message = {:status => variant.status, :total => variant.total }
          @messages.push message
          end 
      end
      return @messages     
    end
    def process
      case self.status
      when 1
        @response_returned = self.step1 
        if @response_returned["ok"]
          self.status = 2
          self.data_hash = @response_returned["total_hash"]
          self.nrows = @response_returned["total_hash"].count          
        end  
      when 2        
        @response_returned = self.step2  
        if @response_returned["ok"]
          self.status = 3          
        end        
      when 3
        @response_returned = self.step3 
        if @response_returned["ok"]
          self.status = 4         
        end                      
      
      when 4
        @response_returned = self.step4
        if @response_returned["ok"]
          self.status = 5         
        end 
      when 5
        @response_returned = self.step5
        if @response_returned["ok"]
          self.status = 6         
        end 
      when 6
        @response_returned = self.step6
        if @response_returned["ok"]
          self.status = 7        
        end 
      when 7
        @response_returned = self.step7
        if @response_returned["ok"]
          self.status = 8       
        end        
      when 8
        @response_returned = self.step8
        if @response_returned["ok"]
          self.status = 9      
        end                  
      else
        @response_returned = self.final                     
      end      
      self.save
      return  @response_returned["messages"] 
    end

    def get_importation_table
      hash_map = self.importation.attachments_table_map
      return hash_map[self.collection_name]
    end
    
    def get_nrows
      if self.nrows == 0 && self.status > 1
        self.nrows = self.data_hash.count
        self.save
      end
      return self.nrows
    end
    
    def get_message_by_collection_status(status)
      @status_hash = { 0 => 'Inicial', 2 => 'Crear', 3 => 'Actualizar' , 10 => ' error sku de variante', 11 => 'sku de producto ' ,
        12 => 'no existe producto con ese sku', 13 => 'no existe categoria con ese nombre', 14 => 'no existe ni producto ni categoria',
         202 => 'Creado', 203 => 'Actualizado', 211 => 'producto actualizado',
         2202 => 'Creada y opciones actualizadas', 2203 => 'Actualizada y opciones actualizadas' }
      @message = 'estado desconocido'
      if  @status_hash.has_key?(status)  
         @message = @status_hash[status]       
      else 
        @message = 'debe crearse antes el producto' if status>99 && status<200
        @message = 'no se ha encontrado la variante' if status>999 && status<2000
      end
      return @message
    end
 
    
    def get_maximun_status
      case self.collection_name
      when 'variants'
        return 9
      when 'images'
        return 2    
      else
        return 5
      end      
    end
    
    def reset_status(status)
      case self.status   
      when 4
        case self.collection_name
        when 'products'
          products=ImportationProduct.where("importation_attachment_id = ? AND status> ? ", self.id,200)
          products.each do |product|       
            product.status-= 200 if product.status > 199 && product.status < 300
            product.save
          end         
            
        when 'variants'
          variants=ImportationVariant.where("importation_attachment_id = ? AND status > ? ", self.id, 200)
          variants.each do |variant|
            variant.status-= 2000 if variant.status > 1999 && variant.status < 3000
            variant.status-= 1000 if variant.status > 999 && variant.status < 2000         
            variant.status-= 200 if variant.status > 199 && variant.status < 300
            variant.save
          end 
        end         
      when 5
        if self.collection_name == 'variants'
          variants=ImportationVariant.where("importation_attachment_id = ? AND status > ? ", self.id, 999)
          variants.each do |variant|
            variant.status-= 2000 if variant.status > 1999 && variant.status < 3000
            variant.status-= 1000 if variant.status > 999 && variant.status < 2000
            variant.save
          end
        end     
  
      end  
      self.status = status
      self.save    
    end
        
    def get_step_name(status)
      @status_hash = { 1 => 'Validacion de Campos', 2 => 'Crear registros a importar', 3 => 'Preparar importacion' , 
        4 => 'actualizar y crear objetos' , 5 => 'Actualizar opciones de color y talla', 6 => 'Preparar imagenes' , 
        7 => 'Copiar imagenes' , 8 => 'Procesar imagenes subidas'}
      
      return @status_hash[status] if  @status_hash.key?(status)
      return " - "
    end
    def create_file
      directory =  self.get_path_files
      system "mkdir #{directory}"
      path = File.join(directory,self.filename)
      File.open(path, "w+") { |f| f.write(self.data.force_encoding("UTF-8"))}
    end
    
    def unzip_file
    
      directory = self.get_path_files
      f = File.join(directory,self.filename)      
      system "unzip  #{f} -d #{directory}"
      fdirname = File.basename(f,".zip")
      fdir = File.join(directory, fdirname)
      if File.directory?(fdir)
        system "mv #{fdir}/* #{directory} " 
        system "rmdir #{fdir}"
      end
      system "rm  #{f} "
      self.status = 2
      self.save
    end
    
    def get_path_files
      return Rails.root.join('public','spree', 'importations', self.importation_id.to_s) 
    end

    def get_files
      @files = Dir.glob(self.get_path_files + "*")
      @f = Hash.new
      for file in @files
        f= { :name => File.basename(file) , :url =>  "/spree/importations/" + self.importation_id.to_s + "/" + File.basename(file) , :file => file }
        @f[ File.basename(file) ] = f
      end
      return  @f
    end

    def remove_all_files
      directory =  self.get_path_files
      system "rm -rf #{directory}/* "     
    end   
    
    private
    def sanitize_filename(filename)
        #get only the filename, not the whole path (from IE)
        just_filename = File.basename(filename)
        #replace all non-alphanumeric, underscore or periods with underscores
        just_filename.gsub(/[^\w\.\-]/, '_')
    end        
    

  end  
end
