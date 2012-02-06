Feature: Add places to a GeoGraph
    In order to create meaningful spots on my geograph
    As an admin
    I want to be able to add places to my geograph

    Background:
        Given I am an authorized user
        And I have one geograph

    Scenario: upload a valid CSV file
        Given I am on the "add places" page for my geograph
        When I upload a valid CSV file
        Then my geograph should now contain the places

    @wip
    Scenario: upload an invalid CSV file
        Given I am editing one of my geographs
        When I upload an invalid CSV file
        Then I should get a message explaining why the CSV file was invalid
