Code::Application.configure do

    # These are the names that the header columns in the data CSVs should take
    # if we want them to get picked up automatically.
    config.place_column_names = {
        :name => 'Place Name',
        :latitude => 'Latitude',
        :longitude => 'Longitude',
        :api_abbr => 'API Code'
    }

    config.yes_no = {
        'Yes' => {
            :value => 2.0,
            :possibilities => [ 'yes', 'y' ]
        },
        'No' => {
            :value => 0.0,
            :possibilities => [ 'no', 'n' ]
        },
        'Maybe' => {
            :value => 1.0,
            :possibilities => [ 'maybe', 'm' ],
        }
    }
end
