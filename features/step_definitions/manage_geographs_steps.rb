Given /^I am an authorized user$/ do
    email = 'test@example.com'
    password = 'secretpass'
    @user = User.new(:email => email, :password => password, :password_confirmation => password)
    @user.save!
    visit new_user_session_path
    fill_in('Email', :with => @user.email)
    fill_in('Password', :with => @user.password)
    click_button('Sign in')
end

Given /^I have one geograph$/ do
    visit new_geo_graph_path
    fill_in('Name', :with => 'Testing')
    click_button('Create')
end

Given /^I am not an authorized user$/ do
    visit destroy_user_session_path
end

Given /^I am on the "([^"]*)" page$/ do |path|
    visit send(path.gsub(' ', '_') + '_path')
end

When /^I navigate to the "([^"]*)" page$/ do |path|
    visit send(path.gsub(' ', '_') + '_path')
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

Then /^I should get an alert message$/ do
    page.find('p.alert').text.should_not be_empty
end

Then /^I should get an error message$/ do
    page.all('p.inline-errors').count.should be > 0
end
