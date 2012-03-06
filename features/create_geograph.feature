Feature: Geograph Creation
    In order to see meaningful spots on a map
    As a connoisseur of map spots
    I want to be able to create new geographs

    Scenario: Creating an invalid geograph
        Given I am logged in as an authorized user
        And I am at the "new geo graph" page
        When I name the geograph ""
        And I create it
        Then I should get an alert message
        And I should get an inline error message

    Scenario: Creating a geograph using a CSV file with specifically named columns
        Given I am logged in as an authorized user
        And I am at the "new geo graph" page
        When I name the geograph "Preservation Map"
        And I upload a CSV file containing places and measures with specific column names
        And I create it
        Then the "Preservation Map" geograph should contain places
        And the "Preservation Map" geograph should contain data for its places
        And I should be redirected to the "show" page for the "Preservation Map" geograph

    @wip
    Scenario: Creating a geograph using a CSV file and an API module
        Given I am logged in as an authorized user
        And I am at the "new geo graph" page
        When I name the geograph "Preservation Map"
        And I upload a CSV file containing places and measures with specific column names
        And I add an external data provider
        And I create it
        Then the "Preservation Map" geograph should contain places
        And the "Preservation Map" should contain external data
        And I should be redirected to the "show" page for the "Preservation Map" geograph
        
    @wip
    Scenario: Creating a geograph using an invalid CSV file
        Given I am logged in as an authorized user
        And I am at the "new geo graph" page
        When I name the geograph "Preservation Map"
        And I upload an invalid CSV file
        Then I should get a message explaining why the CSV file was invalid

    
#    Scenario: Creating a geograph using a CSV file without specifically named columns
#        Given I am logged in as an authorized user
#        And I am at the "new geo graph" page
#        When I name the geograph "Preservation Map"
#        And I create it
#        And I should be redirected to the "select columns" page for the "Preservation Map" geograph

#    Scenario: Picking which measures get included in a geograph
