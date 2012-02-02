Feature: Admin login
    In order to edit geographs
    As an admin
    I want to be able to login

    Scenario: log in with good creds
        Given I am at the login page
        And I am an existing user
        When I enter correct credentials
        Then I should see a list of my geographs

    @wip
    Scenario: log in with bad creds
        Given I am at the login page
        When I enter incorrect credentials
        Then I should get an error saying as much
        And I should be given a chance to enter new creds
