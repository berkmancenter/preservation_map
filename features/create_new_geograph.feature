Feature: Create a new GeoGraph
    In order to view meaningful spots on a map
    As an admin
    I want to create a new geograph

    Scenario: unauthorized user
        Given I am not an authorized user
        When I navigate to the new geograph page
        Then I should get an "Unauthrorized Access" error

    @wip
    Scenario: new valid geograph
        Given I am an admin
        And I am on the new geograph page
        When I create a geograph named "Preservation Map"
        Then I should be redirected to the place-adding page for "Preservation Map"

    @wip
    Scenario: new invalid geograph
        Given I am an admin
        When I create an invalid geograph
        Then I should get a message explaining the error
        And I should be given a chance to fix the error
