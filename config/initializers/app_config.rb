Code::Application.configure do

    # These are the names that the header columns in the data CSVs should take
    # if we want them to get picked up automatically.
    config.place_column_names = ['Place Name', 'Latitude', 'Longitude', 'API Code']
end
