class UsersController < ApplicationController
    def my_geo_graphs
        @geographs = current_user.geo_graphs
    end
end
