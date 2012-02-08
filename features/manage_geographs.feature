Feature: Manage GeoGraphs
    In order to view meaningful spots on a map
    As an admin
    I want to create and edit geograph

    @wip
    Scenario: unauthorized user
        Given I am not an authorized user
        When I navigate to the "new geo graph" page
        Then I should be redirected to the sign-in page

    @wip
    Scenario: new geograph without data CSV
        Given I am an authorized user
        And I am on the "new geo graph" page
        When I create a geograph named "Preservation Map"
        Then I should be redirected to the place-adding page for "Preservation Map"

    @wip
    Scenario: new invalid geograph
        Given I am an authorized user
        And I am on the "new geo graph" page
        When I create a geograph named ""
        Then I should get an alert message
        And I should get an error message

    @wip
    Scenario: new geograph with data CSV
        Given I am an authorized user
        And I am on the "new geo graph" page
        When I name the geograph "Preservation Map"
        And I upload a valid CSV file containing places and measures
        Then I should be redirected to the "edit columns" page for the "Preservation Map" geograph

    @wip
    Scenario: select "place name" column

    @wip
    Scenario: select "latitude" column

    @wip
    Scenario: select "longitude" column

    @wip
    Scenario: select "api code" column

    @wip
    Scenario: select data columns
