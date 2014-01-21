module Spree
  module Admin
    class ImportationsController < ResourceController

      # GET /importations
      # GET /importations.json
      def index
        
        @importation_actual_id = session[:importation_actual_id]
        @importation_actual = Importation.find(@importation_actual_id) if @importation_actual_id.to_s > "0"
        @importations = Importation.all
    
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @importations }
        end
      end
    
      # GET /importations/1
      # GET /importations/1.json
      def show
        @importation = Importation.find(params[:id])
    
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @importation }
        end
      end
    
      # GET /importations/new
      # GET /importations/new.json
      def new
        @importation = Importation.new
        @importation.status = 1
        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @importation }
        end
      end
    
      # GET /importations/1/edit
      def edit
        @importation = Importation.find(params[:id])
        session[:importation_actual_id] = @importation.id
        
      end
    
      # POST /importations
      # POST /importations.json
      def create
        @importation = Importation.new(params[:importation])
    
        respond_to do |format|
          if @importation.save
            session[:importation_actual_id] =@importation.id
            format.html { redirect_to edit_admin_importation_path(@importation.id), notice: 'La Importacion ha sido creada.' }
            format.json { render json: @importation, status: :created, location: @importation }
          else
            format.html { render action: "new" }
            format.json { render json: @importation.errors, status: :unprocessable_entity }
          end
        end
      end
    
      # PUT /importations/1
      # PUT /importations/1.json
      def update
        @importation = Importation.find(params[:id])
    
        respond_to do |format|
          if @importation.update_attributes(params[:importation])
            format.html { redirect_to edit_admin_importation_path(@importation.id), notice: 'La importacion ha sido actualizada.' }
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @importation.errors, status: :unprocessable_entity }
          end
        end
      end
    
      # DELETE /importations/1
      # DELETE /importations/1.json
      def destroy
        @importation = Importation.find(params[:id])
        session[:importation_actual_id] = "0"
        @importation.remove_all_files
        @importation.remove_directory
        @importation.destroy
    
        respond_to do |format|
          format.html { redirect_to admin_importations_path }
          format.json { head :no_content }
        end
      end
    end
  end
end
