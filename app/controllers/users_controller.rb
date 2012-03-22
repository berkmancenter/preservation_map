class UsersController < ApplicationController
    def my_data_maps
        @datamaps = current_user.data_maps
    end
end
