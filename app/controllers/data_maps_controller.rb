class DataMapsController < ApplicationController
    before_filter :authenticate_user!, :except => [:index, :show]
    before_filter :load_datamap, :except => [:index, :new, :create]
    before_filter :authorize_user!, :except => [:index, :show, :new, :create]

    def index
        @datamaps = DataMap.all
    end

    def new
        @datamap = DataMap.new
    end

    def create
        @datamap = DataMap.new(params[:data_map])
        @datamap.user = current_user
        @datamap.import_data_from_attachment!
        if @datamap.save
            redirect_to data_map_path(@datamap)
        else
            redirect_to(new_data_map_path, :alert => t('data_maps.alerts.could_not_add', :data_map => DataMap.model_name.human.downcase))
        end
    end

    def show
        if params[:color_field]
            @datamap.color_field = Field.find(params[:color_field])
        end
        if params[:size_field]
            @datamap.size_field = Field.find(params[:size_field])
        end
        if params[:color_theme]
            @datamap.color_theme = ColorTheme.find(params[:color_theme])
        end
        respond_to do |format|
            format.html { render :layout => false }
            format.json { render :json => @datamap }
        end
    end

    def edit
    end

    def update
        respond_to do |format|
            if @datamap.update_attributes(params[:data_map])
              format.html  {
                  if request.xhr?
                      head :no_content
                  else
                      redirect_to(edit_data_map_path(@datamap), :notice => t('data_maps.alerts.successfully_updated', :data_map => DataMap.model_name.human, :name => @datamap.name))
                  end
              }
              format.json  { head :no_content }
            else
              format.html  { render "edit" }
              format.json  { render :json => @datamap.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy
        if @datamap.destroy
            redirect_to(data_maps_path, :notice => t('data_maps.alerts.successfully_deleted', :data_map => DataMap.model_name.human, :name => @datamap.name))
        else
            redirect_to(data_maps_path, :alert => t('data_maps.alerts.could_not_delete', :data_map => DataMap.model_name.human, :name => @datamap.name))
        end
    end

    def authorize_user!
        unless @datamap.user == current_user
            redirect_to(data_maps_path, :alert => t('data_maps.alerts.access_denied', :data_map => DataMap.model_name.human))
        end
    end

    def load_datamap
        @datamap = DataMap.find(params[:id])
    end
end
