Feature: match data CSV headers to attributes
    In order to get data into a geograph in an easier fashion
    As a creator of geographs
    I want to be able to name CSV headers using specific words and have them used for attributes

    Scenario: upload CSV with specific headers using default header names
        Given I am an authorized user
        And I am on the "new geo graph" page
        When I name the geograph "Preservation Map"
        And I upload a CSV file containing places and measures with specific header fields
        Then the "Preservation Map" geograph should contain places
        And I should be redirected to the "edit columns" page for the "Preservation Map" geograph

    @wip
    Scenario: upload CSV with specific headers using configured header names
        Given I am an authorized user
        And the data CSV header fields are called "Location Name", "Lat.", "Lon.", and "Abbrevation"
        And I am on the "new geo graph" page
        When I name the geograph "Preservation Map"
        And I upload a CSV file containing places and measures with customized header fields
        Then the "Preservation Map" geograph should contain places
        And I should be redirected to the "edit columns" page for the "Preservation Map" geograph
