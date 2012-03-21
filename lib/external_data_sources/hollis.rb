require 'nokogiri'
require 'open-uri'

class Hollis
    def initialize(external_data_source)
        @url_pattern = 'http://webservices.lib.harvard.edu/rest/hollis/search/dc/?add_ref={field-id}&q=branches-id:{place-id}+NOT+material-id:matComputerFile'
        @eds = external_data_source
    end

    def name
        'Hollis'
    end

    def fields
        [
            Field.new(:name => 'Photos',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{field-id}', '27280')
                       ),
            Field.new(:name => 'Periodicals',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{field-id}', '14652')
                       ),
            Field.new(:name => 'DVDs',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{field-id}', '1191372')
                       ),
            Field.new(:name => 'Maps',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{field-id}', '38248')
                       ),
            Field.new(:name => 'Glass Negatives',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{field-id}', '2803528')
                       ),
            Field.new(:name => 'Prints',
                        :external_data_source => @eds,
                        :api_url => @url_pattern.sub('{field-id}', '2817308')
                       )
        ]
    end

    def value(place, field) 
        begin
            url = field.api_url.sub('{place-id}', place.api_abbr)
            Rails.logger.debug('Fetching data from ' + url)
            doc = Nokogiri::XML(open(url))
            result = doc.css('totalResults').first.content
            rescue
                Rails.logger.error("Failed fetching from #{url} for place: #{place.id.to_s} and field: #{field.id.to_s}. Returned 0.0")
                return 0.0
        end
        return result
    end
end
