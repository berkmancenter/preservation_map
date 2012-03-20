Feature: DataMap Deletion
    In order to get rid of datamaps I don't want up on the internet anymore
    As an owner of a datamap
    I want delete datamaps

    Scenario: Deleting a datamap I own
        Given I am an authorized user
        And I have a datamap
        When I delete my datamap
        Then my datamap should no longer exist

    @wip
    Scenario: Deleting a datamap I don't own
        Given a datamap exists
        And I am an authorized user
        When I attempt to delete someone else's datamap
        Then I should get an error message
