class GeoGraphsController < ApplicationController
    before_filter :authenticate_user!, :except => [:index, :show]

    def index
    end

    def new
        @geograph = GeoGraph.new
    end

    def add_places
        @geograph = GeoGraph.find(params[:geo_graph_id]) 
    end

    def edit_columns
        @geograph = GeoGraph.find(params[:geo_graph_id]) 
    end

    def create
        @geograph = GeoGraph.new(params[:geo_graph])
        @geograph.user = current_user
        respond_to do |format|
            if @geograph.save
                if params[:geo_graph][:import_data]
                    if @geograph.import_data.places?
                        @geograph.places = @geograph.import_data.places
                    end
                    format.html {redirect_to geo_graph_path(@geograph)}
                else
                    format.html {redirect_to geo_graph_add_places_path(@geograph)}
                end
            else
                flash[:alert] = 'Could not add that GeoGraph.'
                format.html { render :action => 'new' }
            end
        end
    end

    def show
    end

    def edit
    end

    def update
        @geograph = GeoGraph.find(params[:id])
        respond_to do |format|
            if @geograph.update_attributes(params[:geo_graph])
                format.html { redirect_to geo_graph_path(@geograph) }
            end
        end
    end

    def destroy
    end
end
