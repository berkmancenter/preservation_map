class GeoGraphsController < ApplicationController
    before_filter :authenticate_user!, :except => [:index, :show]

    def index
    end

    def new
        @geograph = GeoGraph.new
    end

    def create
        @geograph = GeoGraph.new
        @geograph.attributes = params[:geograph]
        respond_to do|format|
            if @hub.save
                current_user.has_role!(:owner, @hub)
                current_user.has_role!(:creator, @hub)
                flash[:notice] = 'Added that Hub.'
                format.html {redirect_to hub_path(@hub)}
            else
                flash[:error] = 'Could not add that Hub'
                format.html {render :action => :new}
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
