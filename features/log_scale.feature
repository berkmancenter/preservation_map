Feature: Log Scale
    In order to more easily see the differences between places with wildly different data
    As a creator
    I want some measures to use a logarithmic scale

    Background:
        Given I am an authorized user
        And I have a datamap
        And I am editing my datamap

    Scenario: Setting a measure to use a logarithmic scale
        When I set a measure to use a logarithmic scale
