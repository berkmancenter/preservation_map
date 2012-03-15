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
    click_button('Sign in')
end

Given /^I am an anonymous user$/ do
    visit destroy_user_session_path
end

Given /^I have a geograph$/ do
    @geograph_name = 'Testing'
    step %{I create a new geograph named "#{@geograph_name}" with a CSV file named "#{File.dirname(__FILE__) + '/../upload_files/valid.csv'}"}
end

Given /^I am creating a new geograph$/ do
    visit new_geo_graph_path
end

Given /^a geograph exists$/ do
    email = 'test2@example.com'
    password = 'secretpass'
    step %{a user exists with email "#{email}" and password "#{password}"}
    step %{I am signed in as "#{email}" with password "#{password}"}
    step 'I have a geograph'
    step 'I am an anonymous user'
end

Given /^I am editing my geograph$/ do
    visit root_path
    click_link 'Edit'
end

Given /^I am viewing a geograph$/ do
    step 'a geograph exists'
    step 'I view my geograph'
end

Given /^I am viewing my geograph$/ do
    step 'I view my geograph'
end

When /^I view my geograph$/ do
    visit root_path
    click_link @geograph_name
end

When /^I create a new geograph named "([^"]*)" with a CSV file named "([^"]*)"$/ do |name, filename|
    visit new_geo_graph_path
    fill_in('Name', :with => name)
    attach_file('Data', filename)
    click_button('Create')
end

Then /^I should get an error message$/ do
    page.find('p.flash').text.should_not be_empty
end

Then /^I should get an inline error message$/ do
    page.all('p.inline-errors').count.should be > 0
end
