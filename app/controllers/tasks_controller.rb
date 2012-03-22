class TasksController < ApplicationController
    protect_from_forgery :except => :retrieve_external_data
    before_filter :authorize_user!

    def retrieve_external_data
        DataMap.with_external_data.each do |data_map|
            data_map.retrieve_external_data!
        end
        render :text => "Added job\n", :layout => false
    end

    def authorize_user!
        if params[:SHARED_KEY_FOR_TASKS].nil? || params[:SHARED_KEY_FOR_TASKS].gsub(/['"]/,'').strip != SHARED_KEY_FOR_TASKS
            flash[:notice] = 'You need to give me the shared key if you want to run scheduled tasks via a web request.'
            render :status => :not_acceptable,  :text => "Sorry, the SHARED_KEY_FOR_TASKS didn't match.\n", :layout => false and return
        end
    end
end
