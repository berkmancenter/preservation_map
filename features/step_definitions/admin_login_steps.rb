Given /^I am at the login page$/ do
    visit('/accounts/sign_in')
end

Given /^I am an existing user$/ do
    @email = 'test@example.com'
    @password = 'secretpass'
    User.new(:email => @email, :password => @password, :password_confirmation => @password).save!
end

When /^I enter correct credentials$/ do
    fill_in('Email', :with => @email)
    fill_in('Password', :with => @password)
    click_button('Sign in')
end

Then /^I should see a list of my geographs$/ do
    page.find('h1').text.should eq('My GeoGraphs')
end

