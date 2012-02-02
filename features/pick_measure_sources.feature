Feature: Pick the Measure sources
    In order to add measures to a geograph
    As an admin
    I want to be able to pick where my measures come from

    @wip
    Scenario: upload valid CSV file
        Given I am an admin
        And I am editing one of my geographs
        And my geograph already contains places
        When I upload a valid CSV file
        Then I should be able to pick measures from the CSV file

    @wip
    Scenario: upload invalid CSV file
        Given I am an admin
        And I am editing one of my geographs
        And my geograph already contains places
        When I upload an invalid CSV file
        Then I should get a message explaining why the CSV file was invalid

    @wip
    Scenario: pick existing API module
        Given I am an admin
        And I am editing one of my geographs
        And my geograph already contains places
        And an API module exists
        When I add that module to my geograph
        Then I should be able to pick measures from the API
