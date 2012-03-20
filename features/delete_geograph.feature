Feature: GeoGraph Deletion
    In order to get rid of geographs I don't want up on the internet anymore
    As an owner of a geograph
    I want delete geographs

    Scenario: Deleting a geograph I own
        Given I am an authorized user
        And I have a geograph
        When I delete my geograph
        Then my geograph should no longer exist

    @wip
    Scenario: Deleting a geograph I don't own
        Given a geograph exists
        And I am an authorized user
        When I attempt to delete someone else's geograph
        Then I should get an error message
