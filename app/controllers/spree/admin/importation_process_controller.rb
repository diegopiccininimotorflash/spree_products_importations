module Spree
  module Admin
    class ImportationProcessController <  Spree::Admin::BaseController
      def index
        @importation_attachment = ImportationAttachment.find(params[:id])

        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end
      def step1
        @importation_attachment = ImportationAttachment.find(params[:id])
        @importation_attachment.reset_status(1)

        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end
      def step2
        @importation_attachment = ImportationAttachment.find(params[:id])
        @importation_attachment.reset_status(2)

        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end
      def step3
        @importation_attachment = ImportationAttachment.find(params[:id])
        @importation_attachment.reset_status(3)

        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end  
      def step4
        @importation_attachment = ImportationAttachment.find(params[:id])
        @importation_attachment.reset_status(4)

        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end 
      def step5
        @importation_attachment = ImportationAttachment.find(params[:id])       
        @importation_attachment.reset_status(5)

        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end  
      def step6
        @importation_attachment = ImportationAttachment.find(params[:id])       
        @importation_attachment.reset_status(6)

        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end    
      def step7
        @importation_attachment = ImportationAttachment.find(params[:id])       
        @importation_attachment.reset_status(7)

        respond_to do |format|
          format.html 
          format.json { head :no_content }
        end
      end   
      def step8
        @importation_attachment = ImportationAttachment.find(params[:id])       
        @importation_attachment.reset_status(8)
        @images_to_upload = ImportationVariant.select("count(*) as total, imagen").where("importation_attachment_id = ? AND image_status = ? ", @importation_attachment.id,3).group("imagen").order("imagen")

        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end  
      def variant_images
        @importation_attachment = ImportationAttachment.find(params[:id])       
        @images_to_upload = ImportationVariant.select("count(*) as total, imagen").where("importation_attachment_id = ? AND image_status = ? ", @importation_attachment.id,3).group("imagen").order("imagen")

        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end                                
      def final
        @importation_attachment = ImportationAttachment.find(params[:id])
    
        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end    
      def final_products
        @importation_attachment = ImportationAttachment.find(params[:id])
        @importation_products = ImportationProduct.find(:all,:conditions=> { :importation_attachment_id => params[:id]})
        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end    
      def final_variants
        @importation_attachment = ImportationAttachment.find(params[:id])
        @importation_variants = ImportationVariant.find(:all,:conditions=> { :importation_attachment_id => params[:id]})
        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end   
      def final_products_taxons
        @importation_attachment = ImportationAttachment.find(params[:id])
        @importation_products_taxons = ImportationProductsTaxon.find(:all,:conditions=> { :importation_attachment_id => params[:id]})
        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end   
                         
      def unzip
        @importation_attachment = ImportationAttachment.find(params[:id])
        @importation_attachment.create_file
        @importation_attachment.unzip_file
        respond_to do |format|
          format.html
          format.json { head :no_content }
        end
      end    
      def showimages
        @importation_attachment = ImportationAttachment.find(params[:id])
        
        respond_to do |format|
          format.html { render template: "spree/admin/importation_process/unzip" }
          format.json { head :no_content }
        end
      end     
      def remove_images
        @importation = Importation.find(params[:id])
        @importation.remove_all_files
        ImportationAttachment.delete_all(["importation_id = ? AND collection_name = ? ", @importation.id, 'images'])
        respond_to do |format|
          format.html { redirect_to edit_admin_importation_path(@importation.id), notice: 'Las imagenes han sido borradas.' }
          format.json { head :no_content }
        end
      end                                 
    end
  end
end
