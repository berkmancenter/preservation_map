Feature: Additional Place Metadata
    In order to get more information about particular places that's not numerical
    As a creator
    I want to add my own non-numeric metadata to places

    Background:
        Given I am an authorized user
        And I am creating a new datamap

    Scenario: Including non-numerical data in a CSV
        When I create a new datamap with a CSV that has non-numerical data
    Scenario: Pulling non-numerical data from an API
        When I create a new datamap with an external data source that provides non-numerical data
