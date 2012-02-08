When /^I create a geograph named "([^"]*)"$/ do |geograph_name|
    fill_in('Name', :with => geograph_name)
    click_button('Create')
end

When /^I name the geograph "([^"]*)"$/ do |geograph_name|
    fill_in('Name', :with => geograph_name)
end

When /^I upload a valid CSV file containing places and measures$/ do
    attach_file("Import data", File.dirname(__FILE__) + '/../../../library2.csv')
    click_button('Create Geo graph')
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

Then /^I should be redirected to the "([^"]*)" page for the "([^"]*)" geograph$/ do |path, geograph_name|
    page.current_path.should eq send('geo_graph_' + path.gsub(' ', '_') + '_path', GeoGraph.find_by_name(geograph_name))
end
