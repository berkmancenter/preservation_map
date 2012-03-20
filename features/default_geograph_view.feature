Feature: Set Default GeoGraph View
    In order to make it easier to "show" aspects of the data to other users
    As a creator
    I want to set the default view for geographs

    @javascript
    Scenario: Setting the default view on a geograph
        Given I am an authorized user
        And I have a geograph
        And I am viewing my geograph
        When I change the map center
        And I change the map zoom
        And I change the color theme
        And I change the size criteria
        And I change the color criteria
        And I set the default view
        And I refresh the page
        Then the map center should be the same
        And the map zoom should be the same
        And color theme should be the same
        And the size criteria should be the same
        And the color criteria should be the same
