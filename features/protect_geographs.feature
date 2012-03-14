Feature: Protect geographs from unauthorized changes
    In order to keep geographs from being crap
    As a legitimate user
    I want to be able to login to edit geographs

    @wip
    Scenario: Logging in with good credentials
        Given I am at the "new user session" page
        And I am an existing user
        When I enter correct credentials
        Then I should see a list of my geographs
        
    @wip
    Scenario: Logging in with bad credentials
        Given I am not an authenticated user
        And I am at the "new user session" page
        When I enter incorrect credentials
        Then I should get an alert message
        And I should be given a chance to enter new credentials

    @wip
    Scenario: Unauthorized user accessing the "new geo graph" page
        Given I am not an authenticated user
        When I navigate to the "new geo graph" page
        Then I should be redirected to the "new user session" page
