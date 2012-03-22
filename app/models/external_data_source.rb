class ExternalDataSource < ActiveRecord::Base
    has_and_belongs_to_many :data_maps

    def method_missing(method, *args, &block)
        provider = class_name.constantize.new(self)
        if provider.respond_to?(method)
            provider.send(method, *args)
        else
            super
        end
    end

    def respond_to?(method)
        if ['name', 'fields', 'value'].include? method.to_s
            true 
        else
            super
        end
    end
end
