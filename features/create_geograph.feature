Feature: DataMap Creation
    In order to see meaningful spots on a map
    As a connoisseur of map spots
    I want to be able to create new datamaps
    
    @wip
    Scenario: Creating an invalid datamap
        Given I am logged in as an authorized user
        And I am at the "new data map" page
        When I name the datamap ""
        And I create it
        Then I should get an alert message
        And I should get an inline error message

    @wip
    Scenario: Creating a datamap using a CSV file with specifically named columns
        Given I am logged in as an authorized user
        And I am at the "new data map" page
        When I name the datamap "Preservation Map"
        And I upload a CSV file containing places and fields with specific column names
        And I create it
        Then the "Preservation Map" datamap should contain places
        And the "Preservation Map" datamap should contain data for its places
        And I should be redirected to the "show" page for the "Preservation Map" datamap

    @wip
    Scenario: Pulling in data from a CSV with both yes/no/maybe data and non-numeric metadata

    @wip
    Scenario: Creating a datamap using a CSV file and an API module
        Given I am logged in as an authorized user
        And I am at the "new data map" page
        When I name the datamap "Preservation Map"
        And I upload a CSV file containing places and fields with specific column names
        And I add an external data provider
        And I create it
        Then the "Preservation Map" datamap should contain places
        And the "Preservation Map" should contain external data
        And I should be redirected to the "show" page for the "Preservation Map" datamap
        
    @wip
    Scenario: Creating a datamap using an invalid CSV file
        Given I am logged in as an authorized user
        And I am at the "new data map" page
        When I name the datamap "Preservation Map"
        And I upload an invalid CSV file
        Then I should get a message explaining why the CSV file was invalid

    
#    Scenario: Creating a datamap using a CSV file without specifically named columns
#        Given I am logged in as an authorized user
#        And I am at the "new data map" page
#        When I name the datamap "Preservation Map"
#        And I create it
#        And I should be redirected to the "select columns" page for the "Preservation Map" datamap

#    Scenario: Picking which fields get included in a datamap
