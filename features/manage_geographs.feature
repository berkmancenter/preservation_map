Feature: Manage GeoGraphs
    In order to view meaningful spots on a map
    As an admin
    I want to create and edit geograph

    Scenario: unauthorized user
        Given I am not an authorized user
        When I navigate to the "new geo graph" page
        Then I should be redirected to the sign-in page

    Scenario: new valid geograph
        Given I am an authorized user
        And I am on the "new geo graph" page
        When I create a geograph named "Preservation Map"
        Then I should be redirected to the place-adding page for "Preservation Map"

    Scenario: new invalid geograph
        Given I am an authorized user
        And I am on the "new geo graph" page
        When I create a geograph named ""
        Then I should get an alert message
        And I should get an error message
