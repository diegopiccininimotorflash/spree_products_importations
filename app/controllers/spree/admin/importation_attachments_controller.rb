module Spree
  module Admin
    class ImportationAttachmentsController < ResourceController
      # GET /importation_attachments
      # GET /importation_attachments.json
      def index
        @importation_attachments = ImportationAttachment.all
    
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @importation_attachments }
        end
      end
    
      # GET /importation_attachments/1
      # GET /importation_attachments/1.json
      def show
        @importation_attachment = ImportationAttachment.find(params[:id])
        
        respond_to do |format|
          format.html { redirect_to edit_admin_importation_path(@importation_attachment.importation) if @importation_attachment.collection_name == 'images' }
          format.json { render json: @importation_attachment }
        end
      end
    
      # GET /importation_attachments/new
      # GET /importation_attachments/new.json
      def new
        @importation_attachment = ImportationAttachment.new
    
        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @importation_attachment }
        end
      end
    

      # POST /importation_attachments
      # POST /importation_attachments.json
      def create
        @importation_attachment = ImportationAttachment.new
        
        if params[:attachment].blank?
          format.html { render action: "new" }
          format.json { render json: [:admin, @importation_attachment.errors], status: :unprocessable_entity }
        else
          @importation_attachment.uploaded_file = params[:attachment]
          @importation_attachment.collection_name = params[:collection_name]
          @importation_attachment.importation_id = session[:importation_actual_id]
        end
        

        respond_to do |format|
          if @importation_attachment.save
            format.html { redirect_to [:admin, @importation_attachment] , notice: 'Importation attachment was successfully created.' }
            format.json { render json:[:admin, @importation_attachment] , status: :created, location: [:admin ,@importation_attachment] }
          else
            format.html { render action: "new" }
            format.json { render json: [:admin, @importation_attachment.errors], status: :unprocessable_entity }
          end
        end
       
      end
    

      # DELETE /importation_attachments/1
      # DELETE /importation_attachments/1.json
      def destroy
        @importation_attachment = ImportationAttachment.find(params[:id])
        @importation=@importation_attachment.importation_id

        @importation_attachment.destroy
    
        respond_to do |format|
          format.html { redirect_to edit_admin_importation_path(@importation) }
          format.json { head :no_content }
        end
      end  



    end
  end
end