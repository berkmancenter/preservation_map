class Place < ActiveRecord::Base
    has_many :place_measures
    has_many :measures, :through => :place_measures
    belongs_to :geo_graph

    validates :api_abbr, :presence => true
end
