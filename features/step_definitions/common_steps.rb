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
