class ExternalDataSource < ActiveRecord::Base
    has_and_belongs_to_many :geo_graphs

    def method_missing(method, *args, &block)
        provider = class_name.constantize.new
        if provider.respond_to?(method)
            provider.send(method, *args)
        else
            super
        end
    end

    def respond_to?(method)
        if ['testing'].include? method.to_s
            true 
        else
            super
        end
    end
end
