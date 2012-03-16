Feature: Log Scale
    In order to more easily see the differences between places with wildly different data
    As a creator
    I want some measures to use a logarithmic scale

    Background:
        Given I am an authorized user
        And I have a geograph
        And I am editing my geograph

    Scenario: Setting a measure to use a logarithmic scale
        When I set a measure to use a logarithmic scale
