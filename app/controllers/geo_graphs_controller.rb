class GeoGraphsController < ApplicationController
    before_filter :authenticate_user!, :except => [:index, :show]
    before_filter :load_geograph, :except => [:index, :new, :create]
    before_filter :authorize_user!, :except => [:index, :show, :new, :create]

    def index
        @geographs = GeoGraph.all
    end

    def new
        @geograph = GeoGraph.new
    end

    def create
        @geograph = GeoGraph.new(params[:geo_graph])
        @geograph.user = current_user
        @geograph.import_data_from_attachment!.import_data_from_external_sources!
        if @geograph.save
            redirect_to geo_graph_path(@geograph)
        else
            redirect_to(new_geo_graph_path, :alert => t('geo_graphs.alerts.could_not_add', :geo_graph => GeoGraph.model_name.human.downcase))
        end
    end

    def show
        if params[:color_measure]
            @geograph.color_measure = Measure.find(params[:color_measure])
        end
        if params[:size_measure]
            @geograph.size_measure = Measure.find(params[:size_measure])
        end
        if params[:color_theme]
            @geograph.color_theme = ColorTheme.find(params[:color_theme])
        end
        respond_to do |format|
            format.html { render :layout => false }
            format.json { render :json => @geograph }
        end
    end

    def edit
    end

    def update
        respond_to do |format|
            if @geograph.update_attributes(params[:geo_graph])
              format.html  {
                  if request.xhr?
                      head :no_content
                  else
                      redirect_to(edit_geo_graph_path(@geograph), :notice => t('geo_graphs.alerts.successfully_updated', :geo_graph => GeoGraph.model_name.human, :name => @geograph.name))
                  end
              }
              format.json  { head :no_content }
            else
              format.html  { render "edit" }
              format.json  { render :json => @geograph.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy
        if @geograph.destroy
            redirect_to(geo_graphs_path, :notice => t('geo_graphs.alerts.successfully_deleted', :geo_graph => GeoGraph.model_name.human, :name => @geograph.name))
        else
            redirect_to(geo_graphs_path, :alert => t('geo_graphs.alerts.could_not_delete', :geo_graph => GeoGraph.model_name.human, :name => @geograph.name))
        end
    end

    def authorize_user!
        unless @geograph.user == current_user
            redirect_to(geo_graphs_path, :alert => t('geo_graphs.alerts.access_denied', :geo_graph => GeoGraph.model_name.human))
        end
    end

    def load_geograph
        @geograph = GeoGraph.find(params[:id])
    end
end
