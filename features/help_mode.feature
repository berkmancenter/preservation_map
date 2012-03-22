Feature: Help Mode
    In order to figure out what the hell is going on
    As a confused user
    I want a button I can click that will explain things to me

    Background:
        Given I am an anonymous user
        And I am viewing a datamap

    Scenario: Looking for help on the datamap "show" page
        When I start help mode 
    Scenario: Finished getting help on the datamap "show" page
        When I exit help mode
