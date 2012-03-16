Feature: Configurable Spot Sizes
    In order to make some trends easier to spot (?)
    As someone who likes to configure every little bit
    I want to set the minimum and maximum spot sizes

    Background:
        Given I am an authorized user
        And I have a geograph
        And I am editing my geograph

    @javascript
    Scenario: Setting the minimum and maximum spot sizes to reasonable numbers
        When I set the minimum and maximum spot sizes to reasonable numbers
        And I view my geograph
        Then the minimum and maximum spot sizes should be those numbers

    @javascript
    Scenario: Setting the minimum spot size to something larger than the maximum spot size
        When I set the minimum spot size to a value larger than the maximum spot size
        And I view my geograph
        Then spots with greater values should be smaller than spots with lesser values

    @javascript
    Scenario: Setting the minimum or maximum spot sizes to huge numbers
        When I set the minimum or maximum spot sizes to huge numbers
        Then I should get an inline error message

    @javascript
    Scenario: Setting the minimum and maximum spot sizes to zero
        When I set the minimum and maximum spot sizes to zero
        Then I should get an inline error message

    @javascript
    Scenario: Setting the minimum or maximum spot size to a negative number
        When I set the minimum or maximum spot size to a negative number
        Then I should get an inline error message

    @javascript
    Scenario: Setting the minimum or maximum spot size to a non-integer value
        When I set the minimum or maximum spot size to a non-integer value
        Then I should get an inline error message
