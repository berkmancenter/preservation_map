Feature: Yes/No/Maybe Data
    In order to find trends in data that are best represented as yes/no/maybe
    As a creator
    I want to use yes/no/maybe data like any other data

    Background:
        Given I am an authorized user
        And I am creating a new datamap

    Scenario: Including yes/no/maybe data in a CSV
        When I create a new datamap with a CSV that has yes/no/maybe data
        Then that datamap should contain yes/no/maybe data

    @wip
    Scenario: Pulling yes/no/maybe data from an API 
        When I create a new datamap with an external data source that provides yes/no/maybe data
