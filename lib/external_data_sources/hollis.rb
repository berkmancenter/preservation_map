require 'nokogiri'
require 'open-uri'

class Hollis
    def initialize
        @url_pattern = 'http://webservices.lib.harvard.edu/rest/hollis/search/dc/?q=branches-id:{place-id}+NOT+material-id:matComputerFile'
        @photo_url_pattern = 'http://webservices.lib.harvard.edu/rest/hollis/search/dc/?add_ref=27280&q=branches-id:{place-id}+NOT+material-id:matComputerFile'
    end

    def name
        'Hollis'
    end

    def measures
        [Measure.new(:name => 'Records')]
    end

    def place_measure(place, measure)

    end

    def fetch(place_id)
        doc = Nokogiri::XML(open(@url_pattern.sub(/\{place\-id\}/, place_id)))
        doc.css('totalResults').first.content.to_i
    end
end
