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

    def create
        @geograph = GeoGraph.new
        @geograph.attributes = params[:geograph]
        respond_to do|format|
            if @geograph.save
                flash[:notice] = 'Added that Geograph.'
                format.html {redirect_to geo_graph_add_places_path(@geograph.id)}
            else
                flash[:error] = 'Could not add that Geograph'
                format.html {redirect_to new_geo_graph_path}
            end
        end
    end

    def show
    end

    def edit
    end

    def update
    end

    def destroy
    end
end
