Feature: Create a new GeoGraph
    In order to view meaningful spots on a map
    As an admin
    I want to create a new geograph

    Scenario: new valid geograph
        Given I am an admin
        When I create a valid geograph
        Then I should be redirected to the measure-adding page

    @wip
    Scenario: new invalid geograph
        Given I am an admin
        When I create an invalid geograph
        Then I should get a message explaining the error
        And I should be given a chance to fix the error
