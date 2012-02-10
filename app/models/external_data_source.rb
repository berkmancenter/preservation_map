class ExternalDataSource < ActiveRecord::Base
    has_and_belongs_to_many :geo_graphs
end
