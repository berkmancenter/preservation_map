Code::Application.configure do

    # These are the names that the header columns in the data CSVs should take
    # if we want them to get picked up automatically.
    config.place_column_names = {
        :name => 'Place Name',
        :latitude => 'Latitude',
        :longitude => 'Longitude',
        :api_abbr => 'API Code'
    }

    config.yes_no = { :yes => [ 'yes', 'y' ], :no => [ 'no', 'n' ], :maybe => [ 'maybe', 'm' ] }
end
