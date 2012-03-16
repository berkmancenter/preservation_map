Feature: Set Default Geograph View
    In order to make it easier to "show" aspects of the data to other users
    As a creator
    I want to set the default view for geographs

    Scenario: Setting the default view on a geograph
        Given I am an authorized user
        And I have a geograph
        And I am viewing my geograph
        When I set the default view
