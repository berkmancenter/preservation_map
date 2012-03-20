Given /^I am not an authenticated user$/ do
    visit destroy_user_session_path
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

When /^I enter incorrect credentials$/ do
    fill_in('Email', :with => 'nonsense')
    fill_in('Password', :with => 'badpassword')
    click_button('Sign in')
end

Then /^I should see a list of my datamaps$/ do
    page.find('h1').text.should eq('My DataMaps')
end

Then /^I should be given a chance to enter new credentials$/ do
    page.current_path.should eq new_user_session_path
end
