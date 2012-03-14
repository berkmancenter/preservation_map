Feature: Configurable Legend
    In order to make some geographs easier to understand
    As someone who likes to configure every little bit
    I want to set how many sample sizes and color swatches show up in the legend

    Background:
        Given I am an authorized user
        And I have a geograph
        And I am editing my geograph

    Scenario: Setting the number of sample sizes and color swatches to reasonable numbers
        When I set the number of sample sizes and color swatches to reasonable numbers
    Scenario: Setting the number of sample sizes to zero
        When I set the number of sample sizes to zero
    Scenario: Setting the number of color swatches to zero
        When I set the number of color swatches to zero
    Scenario: Setting the number of sample sizes and color swatches to zero
        When I set the number of sample sizes and color swatches to zero
    Scenario: Setting the number of sample sizes or color swatches to a huge number
        When I set the number of sample sizes or color swatches to a huge number
        Then I should get an error message
    Scenario: Setting the number of sample sizes or color swatches to a negative number
        When I set the number of sample sizes or color swatches to a negative number
        Then I should get an error message
    Scenario: Setting the number of sample sizes or color swatches to a non-integer value
        When I set the number of sample sizes or color swatches to a non-integer value
        Then I should get an error message
