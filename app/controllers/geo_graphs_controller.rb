class GeoGraphsController < ApplicationController
    before_filter :authenticate_user!, :except => [:index, :show]

    def index
    end

    def new
        @geograph = GeoGraph.new
    end

    def create
        @geograph = GeoGraph.new(params[:geo_graph])
        @geograph.user = current_user
        @geograph.import_from_attachment!
        respond_to do |format|
            if @geograph.save
                format.html {redirect_to geo_graph_path(@geograph)}
            else
                flash[:alert] = 'Could not add that GeoGraph.'
                format.html { render :action => 'new' }
            end
        end
    end

    def show
        @geograph = GeoGraph.find(params[:id])
        if params[:color_measure]
            @geograph.color_measure = Measure.find(params[:color_measure])
        end
        if params[:size_measure]
            @geograph.size_measure = Measure.find(params[:size_measure])
        end
        respond_to do |format|
            format.html
            format.json { render_for_api :geo_graph,  :json => @geograph }
        end
    end

    def edit
        @geograph = GeoGraph.find(params[:id])
        unless @geograph.user == current_user
            flash[:alert] = 'You do not have access to that geograph.'
            redirect_to geo_graph_path(@geograph)
        end
    end

    def update
        @geograph = GeoGraph.find(params[:id])
        unless @geograph.user == current_user
            flash[:alert] = 'You do not have access to that geograph.'
            redirect_to geo_graph_path(@geograph)
        end
        respond_to do |format|
            if @geograph.update_attributes(params[:geo_graph])
              format.html  { redirect_to(@geograph,
                            :notice => 'Post was successfully updated.') }
              format.json  { head :no_content }
            else
              format.html  { render :action => "edit" }
              format.json  { render :json => @geograph.errors,
                            :status => :unprocessable_entity }
            end
        end
    end

    def destroy
    end
end
