Given /^I am logged in as an authorized user$/ do
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

Given /^I am at the "([^"]*)" page$/ do |path|
    visit send(path.gsub(' ', '_') + '_path')
end

When /^I navigate to the "([^"]*)" page$/ do |path|
    visit send(path.gsub(' ', '_') + '_path')
end

Then /^I should get an alert message$/ do
    page.find('p.alert').text.should_not be_empty
end

Then /^I should get an inline error message$/ do
    page.all('p.inline-errors').count.should be > 0
end

Then /^I should be redirected to the "([^"]*)" page$/ do |path|
    page.current_path.should eq send(path.gsub(' ', '_') + '_path')
end
