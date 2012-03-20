Feature: Reversible Color Themes
    In order to have more intuitive mappings between colors and numbers
    As someone attempting to find trends in data
    I want to reverse the mapping of colors to numbers

    Background:
        Given I am an authorized user
        And I have a datamap
        And I am editing my datamap

    Scenario: Setting a measure to use a reversed color theme
        When I set a measure to use a reversed color theme
        And I view my datamap
    Scenario: Setting a yes/no/maybe measure to use a reversed color theme
        When I set a "yes/no/maybe" measure to use a reversed color theme
        And I view my datamap
