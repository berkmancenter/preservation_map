Given /^I am an authorized user$/ do
    email = 'test@example.com'
    password = 'secretpass'
    User.new(:email => email, :password => password, :password_confirmation => password).save!
    visit new_user_session_path
    fill_in('Email', :with => email)
    fill_in('Password', :with => password)
    click_button('Sign in')
end

Given /^I am not an authorized user$/ do
    visit destroy_user_session_path
end

Given /^I am on the new geograph page$/ do
    visit('/geo_graphs/new')
end

When /^I navigate to the new geograph page$/ do
    visit('/geo_graphs/new')
end

When /^I create a geograph named "([^"]*)"$/ do |geograph_name|
    fill_in('Name', :with => geograph_name)
    click_button('Create')
end

Then /^I should be redirected to the place\-adding page for "([^"]*)"$/ do |geograph_name|
    page.find('h1').text.should eq('Add Places to ' + geograph_name)
end

Then /^I should be redirected to the sign-in page$/ do
    page.find('h2').should have_content('Sign in')
end
