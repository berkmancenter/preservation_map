require 'nokogiri'
require 'open-uri'

class Hollis
    def initialize(external_data_source)
        @url_pattern = 'http://webservices.lib.harvard.edu/rest/hollis/search/dc/?add_ref={measure-id}&q=branches-id:{place-id}+NOT+material-id:matComputerFile'
        @eds = external_data_source
    end

    def name
        'Hollis'
    end

    def measures
        [
            Measure.new(:name => 'Photos',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{measure-id}', '27280')
                       ),
            Measure.new(:name => 'Periodicals',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{measure-id}', '14652')
                       ),
            Measure.new(:name => 'DVDs',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{measure-id}', '1191372')
                       ),
            Measure.new(:name => 'Maps',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{measure-id}', '38248')
                       ),
            Measure.new(:name => 'Glass Negatives',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{measure-id}', '2803528')
                       ),
            Measure.new(:name => 'Prints',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{measure-id}', '2817308')
                       )
        ]
    end

    def value(place, measure) 
        url = measure.api_url.sub('{place-id}', place.api_abbr)
        p url
        doc = Nokogiri::XML(open(url))
        result = doc.css('totalResults').first.content
        p result
    end
end
