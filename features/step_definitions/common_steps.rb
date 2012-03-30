Given /^I am an authorized user$/ do
    email = 'test@example.com'
    password = 'secretpass'
    step %{a user exists with email "#{email}" and password "#{password}"}
    step %{I am signed in as "#{email}" with password "#{password}"}
end

Given /^a user exists with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
    @user = User.new(:email => email, :password => password, :password_confirmation => password)
    @user.save!
end

Given /^I am signed in as "([^"]*)" with password "([^"]*)"$/ do |email, password|
    visit new_user_session_path
    fill_in('Email', :with => email)
    fill_in('Password', :with => password)
    click_button('Sign In')
end

Given /^I am an anonymous user$/ do
    visit destroy_user_session_path
end

Given /^I have a datamap$/ do
    @datamap_name = 'Testing'
    step %{I create a new datamap named "#{@datamap_name}" with a CSV file named "#{File.dirname(__FILE__) + '/../upload_files/valid.csv'}"}
end

Given /^I am creating a new datamap$/ do
    visit new_data_map_path
end

Given /^a datamap exists$/ do
    email = 'test2@example.com'
    password = 'secretpass'
    step %{a user exists with email "#{email}" and password "#{password}"}
    step %{I am signed in as "#{email}" with password "#{password}"}
    step 'I have a datamap'
    step 'I am an anonymous user'
end

Given /^I am editing my datamap$/ do
    visit root_path
    click_link 'Edit'
end

Given /^I am viewing a datamap$/ do
    step 'a datamap exists'
    step 'I view my datamap'
end

Given /^I am viewing my datamap$/ do
    step 'I view my datamap'
end

When /^I view my datamap$/ do
    visit root_path
    click_link @datamap_name
end

When /^I create a new datamap named "([^"]*)" with a CSV file named "([^"]*)"$/ do |name, filename|
    visit new_data_map_path
    fill_in('Name', :with => name)
    attach_file('Data', filename)
    click_button('Create')
end

When /^I refresh the page$/ do
    visit current_path
end

Then /^I should get an error message$/ do
    page.should have_selector('p.flash.alert, p.flash.error')
end

Then /^I should get an inline error message$/ do
    page.should have_selector('p.inline-errors')
end
